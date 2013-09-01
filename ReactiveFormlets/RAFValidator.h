//
//  RAFValidator.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAFMonoid.h"

@class RAFValidation, RACSignal;

// RAFValidationBuilder ≈ ∀ A. A → RACSignal[RAFValidation[A]]
typedef RACSignal *(^RAFValidationBuilder)(id object);

// RAFValidator models a function that analyzes a function and returns
// an signal of RAFValidations. This is more powerful than a typical validator,
// which gives a single validation for every value tested; the streaming behavior
// is helpful if the validation of a particular value depends on some other state
// which may be changing over time (such as, say, if a value is only valid when
// the user is holding his/her phone in a certain direction).
@interface RAFValidator : NSObject <RAFMonoid>
@property (copy, readonly) RAFValidationBuilder builder;

// Returns RACSignal[RAFValidation[A]].
- (RACSignal *)validate:(id)object;

+ (instancetype)builder:(RAFValidationBuilder)builder;
+ (instancetype)predicate:(BOOL(^)(id object))predicate errors:(NSArray *(^)(id object))errors;
@end
