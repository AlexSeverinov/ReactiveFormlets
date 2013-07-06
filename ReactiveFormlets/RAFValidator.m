//
//  RAFValidator.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "RAFValidator.h"
#import "RAFValidation.h"

@implementation RAFValidator

- (id)initWithBuilder:(RAFValidationBuilder)builder {
	NSParameterAssert(builder);
	if (self = [self init]) {
		_builder = [builder copy];
	}

	return self;
}

+ (instancetype)builder:(RAFValidationBuilder)builder {
	return [[self alloc] initWithBuilder:builder];
}

+ (instancetype)predicate:(BOOL(^)(id object))predicate errors:(NSArray *(^)(id object))errors {
	NSParameterAssert(predicate);
	NSParameterAssert(errors);
	return [self builder:^RACSignal *(id object) {
		RAFValidation *validation = predicate(object) ? [RAFValidation success:object] : [RAFValidation failure:errors(object)];
		return [RACSignal return:validation];
	}];
}

- (RACSignal *)validate:(id)object {
	return self.builder(object);
}

#pragma mark - RAFSemigroup

- (instancetype)raf_append:(RAFValidator *)validator {
	return [self.class builder:^RACSignal *(id object) {
		return [RACSignal combineLatest:@[ [self validate:object], [validator validate:object] ] reduce:^(RAFValidation *leftValidation, RAFValidation *rightValidation) {
			return [leftValidation raf_append:rightValidation];
		}];
	}];
}

#pragma mark - RAFMonoid

+ (instancetype)raf_zero {
	return [self builder:^RACSignal *(id object) {
		return [RACSignal return:[RAFValidation success:object]];
	}];
}

@end
