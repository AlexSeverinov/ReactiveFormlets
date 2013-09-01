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
#import "EXTConcreteProtocol.h"
#import "RAFIdentityValueTransformer.h"

@concreteprotocol(RAFFormlet)
@dynamic editable;

- (RACChannel *)channel {
	return nil;
}

- (RACSignal *)validationSignal {
	return nil;
}

- (id)copyWithZone:(NSZone *)zone {
	return nil;
}

#pragma mark - Concrete

- (NSValueTransformer *)valueTransformer {
	return [NSValueTransformer valueTransformerForName:RAFIdentityValueTransformerName];
}

@end

@interface RAFPrimitiveFormlet ()
@property (strong, readwrite, nonatomic) RAFValidator *validator;
@end

@implementation RAFPrimitiveFormlet {
	RACSignal *_validation;
	RACChannel *_channel;
}

@synthesize editable = _editable;

- (id)init {
	if (self = [super init]) {
		self.editable = YES;
	}

	return self;
}

- (instancetype)validator:(RAFValidator *)validator {
	RAFPrimitiveFormlet *copy = [self copy];
	copy.validator = validator;
	return copy;
}

- (RACChannel *)channel {
	return nil;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	RAFPrimitiveFormlet *copy = [self.class new];
	copy.validator = self.validator;
	return copy;
}

#pragma mark - RAFFormlet

- (RACSignal *)validationSignal {
	if (!_validation) {
		RACSignal *value = [[RACSignal merge:@[ self.channel.followingTerminal, self.channel.leadingTerminal ]] startWith:nil];
		_validation = [RACSignal combineLatest:@[ RACObserve(self, validator), value ] reduce:^(RAFValidator * validator, id value) {
			return [validator validate:value];
		}].switchToLatest;
	}

	return _validation;
}

- (RAFValidator *)validator {
	return _validator ? _validator : [RAFValidator raf_zero];
}

@end

@interface RAFCompoundFormlet ()
@property (strong) id compoundValue;
@end

@implementation RAFCompoundFormlet {
	RACSignal *_validation;
	RACChannel *_channel;
}

@dynamic compoundValue;
@synthesize editable = _editable;

- (id)initWithOrderedDictionary:(RAFOrderedDictionary *)dictionary {
	if (self = [super initWithOrderedDictionary:dictionary]) {
		self.editable = YES;
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

#pragma mark - Signals

- (RACChannel *)channel {
	if (!_channel) {

		RACSequence *channels = [self.allValues.rac_sequence map:^id(id<RAFFormlet> subform) {
			return subform.channel;
		}];

		_channel = [RACChannel new];
		[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			RACSignal *seededTerminals = [RACSignal combineLatest:[channels map:^(RACChannel *channel) {
				return [channel.followingTerminal startWith:nil];
			}]];

			return [seededTerminals subscribeNext:^(RACTuple *tuple) {
				id dict = [[[RAFReifiedProtocol model:self.class.model] new] modify:^(id<RAFMutableOrderedDictionary> dict) {
					[self.allKeys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
						dict[key] = tuple[idx];
					}];
				}];
				[subscriber sendNext:dict];
			} error:^(NSError *error) {
				[subscriber sendError:error];
			} completed:^{
				[subscriber sendCompleted];
			}];
		}] subscribe:_channel.leadingTerminal];

		[_channel.leadingTerminal subscribeNext:^(RAFOrderedDictionary *value) {
			[channels.array enumerateObjectsUsingBlock:^(RACChannel *subchannel, NSUInteger idx, BOOL *stop) {
				[subchannel.followingTerminal sendNext:value.allValues[idx]];
			}];
		}];
	}

	return _channel;
}

- (RACSignal *)validationSignal {
	if (!_validation) {
		RACSequence *signals = [self.allValues.rac_sequence map:^id(id<RAFFormlet> subform) {
			return subform.validationSignal;
		}];

		@weakify(self);
		_validation = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			@strongify(self);
			return [[RACSignal combineLatest:signals] subscribeNext:^(RACTuple *tuple) {
				NSMutableArray *merrors = [NSMutableArray array];
				id dict = [[[RAFReifiedProtocol model:self.class.model] new] modify:^(id<RAFMutableOrderedDictionary> dict) {
					[self.allKeys enumerateObjectsUsingBlock:^(id key, NSUInteger idx, BOOL *stop) {
						[tuple[idx] ?: [RAFValidation failure:@[]] caseSuccess:^id(id value) {
							dict[key] = value;
							return nil;
						} failure:^id(NSArray *errors) {
							[merrors addObject:errors];
							return nil;
						}];
					}];
				}];
				NSArray *errors = [merrors valueForKeyPath:@"@unionOfArrays.self"];
				[subscriber sendNext:(merrors.count ? [RAFValidation failure:errors] : [RAFValidation success:dict])];
			} error:^(NSError *error) {
				[subscriber sendError:error];
			} completed:^{
				[subscriber sendCompleted];
			}];
		}];
	}


	return _validation;
}

@end
