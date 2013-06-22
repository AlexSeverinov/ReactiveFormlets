//
//  RAFValidator.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RAFApply.h"
#import "RAFMonoid.h"

@class RAFValidation;

typedef RAFValidation *(^RAFValidationBuilder)(id object);

// RAFValidator models a function that analyzes a function and returns
// an RAFValidation.
@interface RAFValidator : NSObject <RAFApply, RAFMonoid>
@property (copy, readonly) RAFValidationBuilder builder;

- (id)initWithBuilder:(RAFValidationBuilder)builder;
+ (instancetype)builder:(RAFValidationBuilder)builder;
+ (instancetype)predicate:(BOOL(^)(id object))predicate errors:(NSArray *(^)(id object))errors;
@end
