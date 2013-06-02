//
//  RAFValidator.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveFormlets/RAFApply.h>
#import <ReactiveFormlets/RAFMonoid.h>

@class RAFValidation;

typedef RAFValidation *(^RAFValidationPredicate)(id object);

@interface RAFValidator : NSObject <RAFApply, RAFMonoid>
@property (copy, readonly) RAFValidationPredicate predicate;

- (id)initWithPredicate:(RAFValidationPredicate)predicate;
+ (instancetype)predicate:(RAFValidationPredicate)predicate;
@end
