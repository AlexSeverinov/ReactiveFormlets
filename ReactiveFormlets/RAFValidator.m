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
	return [self builder:^RAFValidation *(id object) {
		return predicate(object) ? [RAFValidation success:object] : [RAFValidation failure:errors(object)];
	}];
}

#pragma mark - RAFApply

- (id)raf_apply:(id)operand {
	return self.builder(operand);
}

#pragma mark - RAFSemigroup

- (instancetype)raf_append:(RAFValidator *)validator {
	return [self.class builder:^RAFValidation *(id value) {
		return [[self raf_apply:value] raf_append:[validator raf_apply:value]];
	}];
}

#pragma mark - RAFMonoid

+ (instancetype)raf_zero {
	return [self builder:^RAFValidation *(id object) {
		return [RAFValidation success:object];
	}];
}

@end
