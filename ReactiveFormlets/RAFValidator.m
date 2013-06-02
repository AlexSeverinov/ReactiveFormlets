//
//  RAFValidator.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFValidator.h>
#import <ReactiveFormlets/RAFValidation.h>

@implementation RAFValidator

- (id)initWithPredicate:(RAFValidationPredicate)predicate {
	NSParameterAssert(predicate);
	if (self = [self init]) {
		_predicate = [predicate copy];
	}

	return self;
}

+ (instancetype)predicate:(RAFValidationPredicate)predicate {
	return [[self alloc] initWithPredicate:predicate];
}

#pragma mark - RAFApply

- (id)raf_apply:(id)operand {
	return self.predicate(operand);
}

#pragma mark - RAFSemigroup

- (instancetype)raf_append:(RAFValidator *)validator {
	return [self.class predicate:^RAFValidation *(id value) {
		return [[self raf_apply:value] raf_append:[validator raf_apply:value]];
	}];
}

#pragma mark - RAFMonoid

+ (instancetype)raf_zero {
	return [self predicate:^RAFValidation *(id object) {
		return [RAFValidation success:object];
	}];
}

@end
