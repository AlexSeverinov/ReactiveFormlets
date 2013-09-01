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

- (id)initWithBuilder:(RACSignal *(^)(id object))builder {
	NSParameterAssert(builder);
	if (self = [self initWithSignalBlock:builder]) {
		self.allowsConcurrentExecution = YES;
	}

	return self;
}

+ (instancetype)builder:(RACSignal *(^)(id object))builder {
	return [[self alloc] initWithBuilder:builder];
}

+ (instancetype)predicate:(BOOL(^)(id object))predicate error:(NSError *(^)(id object))error {
	NSParameterAssert(predicate);
	NSParameterAssert(error);
	return [self builder:^(id object) {
		RAFValidation *validation = predicate(object) ? [RAFValidation success:object] : [RAFValidation failure:@[ error(object) ]];
		return [RACSignal return:validation];
	}];
}

#pragma mark - RAFSemigroup

- (instancetype)raf_append:(RAFValidator *)validator {
	return [self.class builder:^RACSignal *(id object) {
		return [RACSignal combineLatest:@[ [self execute:object], [validator execute:object] ] reduce:^(RAFValidation *leftValidation, RAFValidation *rightValidation) {
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

