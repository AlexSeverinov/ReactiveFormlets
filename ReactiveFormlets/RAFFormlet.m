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

@implementation RAFPrimitiveFormlet

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
	@weakify(self);
	return [[RACSignal merge:@[ self.dataSignal, self.hardUpdateSignal ]] map:^id(id value) {
		@strongify(self);
		return @([self raf_isValid:value]);
	}];
}

#pragma mark - RAFLens

- (NSString *)keyPathForLens {
	@throw [NSException exceptionWithName:NSGenericException
								   reason:@"Subclasses of RAFPrimitiveFormlet must override -keyPathForLens"
								 userInfo:nil];
	return nil;
}

#pragma Validation

- (BOOL)raf_isValid:(id)value {
	BOOL isValid = YES;
	for (RAFValidator validator in self.customValidators) {
		isValid = isValid && validator(value);
	}

	return isValid;
}

#pragma mark - Message Forwarding

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	return [(id)self.dataSignal methodSignatureForSelector:aSelector];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	[anInvocation invokeWithTarget:self.dataSignal];
}

@end

@interface RAFCompoundFormlet ()
@property (strong) id compoundValue;
@end

@implementation RAFCompoundFormlet {
	RACSignal *_signal;
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

- (BOOL)raf_isValid:(id)value {
	BOOL isValid = YES;
	for (id key in self) {
		isValid = isValid && ([self[key] raf_isValid:value[key]]);
	}

	return isValid;
}

- (RACSignal *)validation
{
	@weakify(self);
	return [self.dataSignal map:^id(id value) {
		@strongify(self);
		return @([self raf_isValid:value]);
	}];
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
	if (!_signal) {
		_signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
			NSMutableSet *disposables = [NSMutableSet setWithCapacity:self.count];
			NSMutableSet *extantSignals = [NSMutableSet setWithArray:self.allValues];

			for (id key in self) {
				RACSignal *signal = self[key];
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
	return [RACSignal merge:@[ [_signal startWith:self.extract], self.hardUpdateSignal ]];
}

#pragma mark - RAFLens

- (NSString *)keyPathForLens {
	return @keypath(self.compoundValue);
}

@end
