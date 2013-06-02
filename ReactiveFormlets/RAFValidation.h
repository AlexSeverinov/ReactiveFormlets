//
//  RAFValidation.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <ReactiveFormlets/RAFApplicative.h>
#import <ReactiveFormlets/RAFSemigroup.h>

@protocol RAFValidationCase;
@class RAFSuccess, RAFFailure;

@interface RAFValidation : NSObject <RAFApplicative, RAFSemigroup>
+ (RAFValidation *)success:(id)value;
+ (RAFValidation *)failure:(id<RAFSemigroup>)errors;
- (id)caseSuccess:(id(^)(id value))success failure:(id(^)(id<RAFSemigroup> errors))failure;
@end

@interface RACSignal (RAFValidation)
- (RACSignal *)raf_isSuccessSignal;
@end
