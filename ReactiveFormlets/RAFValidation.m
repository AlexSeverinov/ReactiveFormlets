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
@property (copy, readonly) id<RAFSemigroup> errors;
- (id)initWithErrors:(id<RAFSemigroup>)errors;
@end

@implementation RAFValidation

+ (RAFValidation *)success:(id)value {
	return [[RAFSuccess alloc] initWithValue:value];
}

+ (RAFValidation *)failure:(id<RAFSemigroup>)errors {
	return [[RAFFailure alloc] initWithErrors:errors];
}

+ (instancetype)raf_point:(id)value {
	return [self success:value];
}

- (id)raf_apply:(id)operand {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (id)raf_append:(id<RAFSemigroup>)value {
	[self doesNotRecognizeSelector:_cmd];
	return nil;
}

- (id)caseSuccess:(id (^)(id))success failure:(id (^)(id<RAFSemigroup>))failure {
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

- (id)caseSuccess:(id (^)(id))success failure:(id (^)(id<RAFSemigroup>))failure {
	return success(self.value);
}

- (RAFValidation *)raf_apply:(RAFValidation *)validation {
	NSAssert([self.value conformsToProtocol:@protocol(RAFApply)],
			 @"Receiver of -[RAFSuccess raf_apply:] must be RAFValidation[RAFApply]");
	return [validation caseSuccess:^(id value) {
		return [self.value raf_apply:value];
	} failure:^(id<RAFSemigroup> errors) {
		return [RAFFailure failure:errors];
	}];
}

- (instancetype)raf_append:(RAFValidation *)validation {
	return [validation caseSuccess:^id(id value) {
		return self;
	} failure:^(id<RAFSemigroup> errors) {
		return [RAFFailure failure:errors];
	}];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"(Success: %@)", self.value];
}

@end

@implementation RAFFailure

- (id)initWithErrors:(id<RAFSemigroup>)errors {
	if (self = [self init]) {
		_errors = errors;
	}

	return self;
}

- (id)caseSuccess:(id (^)(id))success failure:(id (^)(id<RAFSemigroup>))failure {
	return failure(self.errors);
}

- (RAFValidation *)raf_apply:(RAFValidation *)validation {
	return [validation caseSuccess:^(id _) {
		return self;
	} failure:^id(id<RAFSemigroup> errors) {
		return [RAFFailure failure:[self.errors raf_append:errors]];
	}];
}

- (instancetype)raf_append:(RAFValidation *)validation {
	return [validation caseSuccess:^(id _) {
		return self;
	} failure:^id(id<RAFSemigroup> errors) {
		return [RAFFailure failure:[self.errors raf_append:errors]];
	}];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"(Failure: %@)", self.errors];
}

@end


@implementation RACSignal (RAFValidation)

- (RACSignal *)raf_isSuccessSignal {
	return [self map:^id(RAFValidation *validation) {
		return [validation caseSuccess:^id(id value) {
			return @(YES);
		} failure:^id(id<RAFSemigroup> errors) {
			return @(NO);
		}];
	}];
}

@end
