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

@interface RAFPrimitiveFormlet ()
@property (strong, readwrite, nonatomic) RAFValidator *validator;
@end

@implementation RAFPrimitiveFormlet {
	RACSignal *_validation;
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

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	RAFPrimitiveFormlet *copy = [self.class new];
	copy.validator = self.validator;
	return copy;
}

#pragma mark - RAFFormlet

- (RACSignal *)rawDataSignal {
	@throw [NSException exceptionWithName:NSGenericException
								   reason:@"Subclasses of RAFPrimitiveFormlet must override -rawDataSignal"
								 userInfo:nil];
	return nil;
}

- (RACSignal *)validationSignal {
	if (!_validation) {
		RACSignal *dataSignal = [RACSignal merge:@[ self.rawDataSignal, self.hardUpdateSignal ]];
		_validation = [RACSignal combineLatest:@[ RACObserve(self, validator), dataSignal ] reduce:^(RAFValidator * validator, id value) {
			return [validator validate:value];
		}].switchToLatest;
	}

	return _validation;
}

- (RAFValidator *)validator {
	return _validator ? _validator : [RAFValidator raf_zero];
}

#pragma mark - RAFLens

- (NSString *)keyPathForLens {
	@throw [NSException exceptionWithName:NSGenericException
								   reason:@"Subclasses of RAFPrimitiveFormlet must override -keyPathForLens"
								 userInfo:nil];
	return nil;
}

@end

@interface RAFCompoundFormlet ()
@property (strong) id compoundValue;
@end

@implementation RAFCompoundFormlet {
	RACSignal *_rawDataSignal;
	RACSignal *_validation;
}

@dynamic compoundValue;
@synthesize editable = _editable;

- (id)initWithOrderedDictionary:(RAFOrderedDictionary *)dictionary {
	if (self = [super initWithOrderedDictionary:dictionary]) {
		self.editable = YES;
	}

	return self;
}

- (id)compoundValue {
	RAFReifiedProtocol *modelData = [[RAFReifiedProtocol model:self.class.model] new];
	return [modelData modify:^(id<RAFMutableOrderedDictionary> dict) {
		for (id key in self) {
			id data = self[key].raf_extract;
			if (data) dict[key] = data;
		}
	}];
}

- (void)setCompoundValue:(id)value {
	for (id key in self) {
		[self[key] updateInPlace:value[key]];
	}
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
	[copy updateInPlace:self.raf_extract];
	return copy;
}

#pragma mark - Signals

- (RACSignal *)rawDataSignal {
	if (!_rawDataSignal) {
		@weakify(self);

		RACSequence *signals = [self.allValues.rac_sequence map:^id(id<RAFFormlet> subform) {
			return subform.rawDataSignal;
		}];

		_rawDataSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			@strongify(self);
			return [[RACSignal combineLatest:signals] subscribeNext:^(RACTuple *tuple) {
				[subscriber sendNext:self.raf_extract];
			} error:^(NSError *error) {
				[subscriber sendError:error];
			} completed:^{
				[subscriber sendCompleted];
			}];
		}];
	}

	return [RACSignal merge:@[ [_rawDataSignal startWith:self.raf_extract], self.hardUpdateSignal ]];
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
				RAFValidation *start = [RAFValidation success:self.raf_extract];
				[subscriber sendNext:[RAFValidation raf_sum:tuple.rac_sequence onto:start]];
			} error:^(NSError *error) {
				[subscriber sendError:error];
			} completed:^{
				[subscriber sendCompleted];
			}];
		}];
	}

	return _validation;
}


#pragma mark - RAFLens

- (NSString *)keyPathForLens {
	return @keypath(self.compoundValue);
}

- (id)raf_extract {
	return self.compoundValue;
}

@end
