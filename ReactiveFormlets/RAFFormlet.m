//
//  RAFFormlet.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 5/31/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFFormlet.h"
#import "RAFValidation.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "EXTScope.h"
#import "RAFIdentityValueTransformer.h"

@implementation RAFPrimitiveFormlet {
	RACChannel *_channel;
}

@synthesize editable = _editable;
@synthesize validationSignal = _validationSignal;
@synthesize totalDataSignal = _totalDataSignal;

- (id)init {
	if (self = [super init]) {
		self.editable = YES;

		_totalDataSignal = [RACSignal defer:^RACSignal *{
			return [RACSignal merge:@[ self.channel.followingTerminal, self.channel.leadingTerminal ]];
		}].replayLazily;

		RACSignal *validatorSignal = RACObserve(self, validator);
		_validationSignal = [RACSignal defer:^RACSignal *{
			return [RACSignal combineLatest:@[ validatorSignal, [_totalDataSignal startWith:nil] ] reduce:^(RAFValidator *validator, id value) {
				return [validator execute:value];
			}].switchToLatest;
		}].replayLazily;
	}

	return self;
}

- (RACChannel *)channel {
	return nil;
}

- (RACChannelTerminal *)channelTerminal {
	return self.channel.followingTerminal;
}

- (NSValueTransformer *)valueTransformer {
	return [NSValueTransformer valueTransformerForName:RAFIdentityValueTransformerName];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	RAFPrimitiveFormlet *copy = [self.class new];
	copy.validator = self.validator;
	return copy;
}

#pragma mark - RAFFormlet

- (RAFValidator *)validator {
	return _validator ? _validator : [RAFValidator raf_zero];
}

@end

@interface RAFCompoundFormlet ()
@end

@implementation RAFCompoundFormlet {
	RACSignal *_totalDataSignal;
	RACChannel *_channel;
}

@synthesize editable = _editable;
@synthesize validationSignal = _validationSignal;
@synthesize totalDataSignal = _totalDataSignal;

- (id)initWithOrderedDictionary:(RAFOrderedDictionary *)dictionary {
	if (self = [super initWithOrderedDictionary:dictionary]) {
		self.editable = YES;
		_totalDataSignal = [RACSignal merge:@[ self.channel.followingTerminal, self.channel.leadingTerminal ]].replay;

		RACSequence *signals = [self.allValues.rac_sequence map:^id(id<RAFFormlet> subform) {
			return subform.validationSignal;
		}];

		Class Model = [RAFReifiedProtocol model:self.class.model];
		NSArray *allKeys = self.allKeys;

		_validationSignal = [[RACSignal combineLatest:signals] map:^id(RACTuple *tuple) {
			NSMutableArray *errorSequences = [NSMutableArray array];
			id dict = [[Model new] modify:^(id<RAFMutableOrderedDictionary> dict) {
				[allKeys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
					[tuple[idx] ?: [RAFValidation failure:@[]] caseSuccess:^id(id value) {
						dict[key] = value;
						return nil;
					} failure:^id(NSArray *errors) {
						[errorSequences addObject:errors.rac_sequence];
						return nil;
					}];
				}];
			}];

			return errorSequences.count ? [RAFValidation failure:errorSequences.rac_sequence.flatten.array] : [RAFValidation success:dict];
		}].replayLazily;

	}

	return self;
}

- (void)setEditable:(BOOL)editable
{
	[self willChangeValueForKey:@keypath(self.editable)];

	_editable = editable;

	for (id key in self) {
		id<RAFFormlet> subform = self[key];
		subform.editable = editable;
	}

	[self didChangeValueForKey:@keypath(self.editable)];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [self deepCopyWithZone:zone];
}

- (instancetype)deepCopyWithZone:(NSZone *)zone {
	RAFCompoundFormlet *copy = [super deepCopyWithZone:zone];
	copy.editable = self.editable;
	return copy;
}

#pragma mark - Channels

- (RACChannelTerminal *)channelTerminal {
	return self.channel.followingTerminal;
}

- (RACChannel *)channel {
	if (!_channel) {

		RACSequence *channels = [self.sequence reduceEach:^(id key, id<RAFFormlet> subform) {
			return RACTuplePack(key, subform.channel);
		}];

		_channel = [RACChannel new];

		RACSignal *seededTerminals = [RACSignal combineLatest:[channels reduceEach:^(id key, RACChannel *channel) {
			return [channel.followingTerminal startWith:nil];
		}]];

		Class Model = [RAFReifiedProtocol model:self.class.model];

		[[seededTerminals map:^(RACTuple *tuple) {
			return [[Model alloc] initWithValues:tuple.rac_sequence.array];
		}] subscribe:_channel.leadingTerminal];

		[_channel.leadingTerminal subscribeNext:^(RAFOrderedDictionary *value) {
			for (RACTuple *pair in channels)
			{
				RACTupleUnpack(id key, RACChannel *subchannel) = pair;
				id subvalue = value[key];
				[subchannel.followingTerminal sendNext:([subvalue isKindOfClass:[NSNull class]] ? nil : subvalue)];
			}
		}];
	}

	return _channel;
}

@end
