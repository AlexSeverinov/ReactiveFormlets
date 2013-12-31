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

@end

