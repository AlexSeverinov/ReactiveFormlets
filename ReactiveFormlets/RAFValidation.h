//
//  RAFValidation.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RAFSemigroup.h"

// RAFValidation represents a reasoned validity-judgement of an object.
@interface RAFValidation : NSObject <RAFSemigroup>

// value - the value which has been validated
// Returns a successful validation with given value.
+ (RAFValidation *)success:(id)value;

// errors - a collection of errors.
// Returns a failed validation with the given errors.
+ (RAFValidation *)failure:(NSArray *)errors;

// The eliminator for validations.
//
// success - A block from a valid value to some object.
// failure - A block from a collection of errors to some object.
//
// Returns either the result of the success block or the failure block depending
// on whether the validation was created with +success: or +failure:.
- (id)caseSuccess:(id(^)(id value))success failure:(id(^)(NSArray *errors))failure;
- (void)ifSuccess:(void(^)(id value))success failure:(void(^)(NSArray *errors))failure;
@end

@interface RACSignal (RAFValidation)
// Transforms RACSignal[RAFValidation] to RACSignal[Bool], where successes are
// mapped to YES and failures to NO.
- (RACSignal *)raf_isSuccessSignal;
@end
