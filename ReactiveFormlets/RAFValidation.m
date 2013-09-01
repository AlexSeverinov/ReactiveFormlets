//
//  RAFValidation.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "RAFValidation.h"

@interface RAFSuccess : RAFValidation
@property (strong, readonly) id value;
- (id)initWithValue:(id)value;
@end

@interface RAFFailure : RAFValidation
@property (copy, readonly) NSArray *errors;
- (id)initWithErrors:(NSArray *)errors;
@end

@implementation RAFValidation

+ (RAFValidation *)success:(id)value {
	return [[RAFSuccess alloc] initWithValue:value];
}

+ (RAFValidation *)failure:(NSArray *)errors {
	return [[RAFFailure alloc] initWithErrors:errors];
}

+ (instancetype)raf_point:(id)value {
	return [self success:value];
}

- (id)raf_map:(id (^)(id))function {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (id)raf_apply:(id)operand {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (id)raf_append:(id<RAFSemigroup>)value {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (id)caseSuccess:(id (^)(id))success failure:(id (^)(NSArray *))failure {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

@end

@implementation RAFSuccess

- (id)initWithValue:(id)value {
	if (self = [self init]) {
		_value = value;
	}

	return self;
}

- (id)caseSuccess:(id (^)(id))success failure:(id (^)(NSArray *))failure {
	return success(self.value);
}

- (id)raf_map:(id (^)(id))function {
	return [RAFValidation success:function(self.value)];
}

- (RAFValidation *)raf_apply:(RAFValidation *)validation {
	return [validation raf_map:^(id value) {
		id (^function)(id) = self.value;
		return function(value);
	}];
}

- (instancetype)raf_append:(RAFValidation *)validation {
	return [validation caseSuccess:^id(id value) {
		return self;
	} failure:^(NSArray *errors) {
		return [RAFFailure failure:errors];
	}];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"(Success: %@)", self.value];
}

@end

@implementation RAFFailure

- (id)initWithErrors:(NSArray *)errors {
	if (self = [self init]) {
		_errors = errors;
	}

	return self;
}

- (id)caseSuccess:(id (^)(id))success failure:(id (^)(NSArray *))failure {
	return failure(self.errors);
}

- (id)raf_map:(id (^)(id))function {
	return self;
}

- (RAFValidation *)raf_apply:(RAFValidation *)validation {
	return [validation caseSuccess:^(id _) {
		return self;
	} failure:^id(NSArray *errors) {
		return [RAFFailure failure:[self.errors arrayByAddingObjectsFromArray:errors]];
	}];
}

- (instancetype)raf_append:(RAFValidation *)validation {
	return [validation caseSuccess:^(id _) {
		return self;
	} failure:^id(NSArray *errors) {
		return [RAFFailure failure:[self.errors arrayByAddingObjectsFromArray:errors]];
	}];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"(Failure: %@)", self.errors];
}

@end


@implementation RACSignal (RAFValidation)

- (RACSignal *)raf_isSuccessSignal {
	return [[self map:^(RAFValidation *validation) {
		return [validation caseSuccess:^(id value) {
			return @YES;
		} failure:^(NSArray *errors) {
			return @NO;
		}];
	}] ignore:nil];
}

@end

