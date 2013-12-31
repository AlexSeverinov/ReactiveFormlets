//
//  RAFValidation.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

/// `RAFValidation` represents a validity decision of an object.
///
/// | RAFValidation (A : Type) : Type
@interface RAFValidation : NSObject

/// The constructor for successful validations.
///
/// | (success : A) → RAFValidation A
+ (RAFValidation *)success:(id)value;

/// The constructor for failed validations.
///
/// | (failure : NSArray NSError) → RAFValidation A
+ (RAFValidation *)failure:(NSArray *)errors;

/// The eliminator for validations.
///
/// Returns either the result of the success block or the failure block depending
/// on whether the validation was created with +success: or +failure:.
///
/// | Π {B : Type}. (success : A → B, failure : NSArray NSError → B) → B
- (id)caseSuccess:(id(^)(id value))success failure:(id(^)(NSArray *errors))failure;

/// A side-effecting eliminator for validations.
///
/// Executes the success block or the failure block depending on whether
/// the validation was created with +success: or +failure:.
///
/// | (success : A → void, failure : NSArray NSError → void) → void
- (void)ifSuccess:(void(^)(id value))success failure:(void(^)(NSArray *errors))failure;

@end

@interface RACSignal (RAFValidation)
/// Transforms RACSignal[RAFValidation] to RACSignal[Bool], where successes are
/// mapped to YES and failures to NO.

/// | Π {A : Type}. {self : RACSignal (RAFValidation A)} → RACSignal Bool.
- (RACSignal *)raf_isSuccessSignal;
@end
