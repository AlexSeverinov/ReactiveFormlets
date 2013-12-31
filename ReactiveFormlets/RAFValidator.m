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

- (id)initWithSignalBlock:(RACSignal *(^)(id))signalBlock {
	if (self = [super initWithSignalBlock:signalBlock]) {
		self.allowsConcurrentExecution = YES;
	}

	return self;
}

+ (instancetype)predicate:(BOOL(^)(id object))predicate error:(NSError *(^)(id object))error {
	NSParameterAssert(predicate);
	NSParameterAssert(error);
	return [[self alloc] initWithSignalBlock:^RACSignal *(id input) {
		RAFValidation *validation = predicate(input) ? [RAFValidation success:input] : [RAFValidation failure:@[ error(input) ]];
		return [RACSignal return:validation];
	}];
}

+ (instancetype)identityValidator {
	return [[self alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal return:[RAFValidation success:input]];
	}];
}

- (instancetype)and:(RAFValidator *)validator {
	return [[self.class alloc] initWithSignalBlock:^RACSignal *(id input) {
		return [RACSignal combineLatest:@[ [self execute:input], [validator execute:input] ] reduce:^(RAFValidation *first, RAFValidation *second) {
			return [first caseSuccess:^(id _) {
				return [second caseSuccess:^(id _) {
					return [RAFValidation success:input];
				} failure:^(NSArray *errors) {
					return [RAFValidation failure:errors];
				}];
			} failure:^(NSArray *firstErrors) {
				return [second caseSuccess:^(id _) {
					return [RAFValidation failure:firstErrors];
				} failure:^(NSArray *secondErrors) {
					return [RAFValidation failure:[firstErrors arrayByAddingObjectsFromArray:secondErrors]];
				}];
			}];
		}];
	}];
}

@end

