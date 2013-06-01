//
//  RAFFormlet.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 5/31/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFFormlet.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "EXTScope.h"

@implementation RAFPrimitiveFormlet {
	RACSignal *_validation;
}

- (instancetype)validators:(NSArray *)validators {
	RAFPrimitiveFormlet *copy = [self copy];
	copy->_customValidators = [validators copy];
	return copy;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	RAFPrimitiveFormlet *copy = [self.class new];
	copy->_customValidators = self.customValidators;
	return copy;
}

#pragma mark - RAFFormlet

- (RACSignal *)dataSignal {
	@throw [NSException exceptionWithName:NSGenericException
								   reason:@"Subclasses of RAFPrimitiveFormlet must override -dataSignal"
								 userInfo:nil];
	return nil;
}

- (RACSignal *)validation {
	if (!_validation) {
		@weakify(self);
		_validation = [self.dataSignal map:^id(id data) {
			@strongify(self);
			BOOL isValid = YES;
			for (RAFValidator validator in self.customValidators) {
				isValid = isValid && validator(data);
			}
			
			return @(isValid);
		}];
	}

	return _validation;
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
	RACSignal *_dataSignal;
	RACSignal *_validation;
}

@dynamic compoundValue;

- (id)compoundValue {
	RAFReifiedProtocol *modelData = [[RAFReifiedProtocol model:self.class.model] new];
	return [modelData modify:^(id<RAFMutableOrderedDictionary> dict) {
		for (id key in self) {
			id data = self[key].extract;
			if (data) dict[key] = data;
		}
	}];
}

- (void)setCompoundValue:(id)value {
	for (id key in self) {
		[self[key] updateInPlace:value[key]];
	}
}

- (RACSignal *)validation {
	if (!_validation) {
		RACSequence *subValidations = [self.allValues.rac_sequence map:^(id<RAFFormlet> formlet) {
			return formlet.validation;
		}];

		_validation = [[RACSignal combineLatest:subValidations] map:^(RACTuple *validations) {
			return [validations.rac_sequence foldLeftWithStart:@(YES) combine:^(NSNumber *accumulator, NSNumber *isValid) {
				return @(accumulator.boolValue && isValid.boolValue);
			}];
		}];
	}

	return _validation;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [self deepCopyWithZone:zone];
}

- (instancetype)deepCopyWithZone:(NSZone *)zone {
	id copy = [super deepCopyWithZone:zone];
	[copy updateInPlace:self.extract];
	return copy;
}

#pragma mark - RAFValidatedSignalSource

- (RACSignal *)dataSignal {
	if (!_dataSignal) {
		_dataSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			NSMutableSet *disposables = [NSMutableSet setWithCapacity:self.count];
			NSMutableSet *extantSignals = [NSMutableSet setWithArray:self.allValues];

			for (id key in self) {
				RACSignal *signal = [self[key] dataSignal];
				RACDisposable *disposable = [signal subscribeNext:^(id value) {
					[subscriber sendNext:self.extract];
				} error:^(NSError *error) {
					[subscriber sendError:error];
				} completed:^{
					[extantSignals removeObject:signal];
					if (!extantSignals.count) {
						[subscriber sendCompleted];
					}
				}];

				if (disposable != nil) {
					[disposables addObject:disposable];
				}
			}

			return [RACDisposable disposableWithBlock:^{
				for (RACDisposable *disposable in disposables) {
					[disposable dispose];
				}
			}];
		}];
	}
	return [RACSignal merge:@[ [_dataSignal startWith:self.extract], self.hardUpdateSignal ]];
}

#pragma mark - RAFLens

- (NSString *)keyPathForLens {
	return @keypath(self.compoundValue);
}

@end
