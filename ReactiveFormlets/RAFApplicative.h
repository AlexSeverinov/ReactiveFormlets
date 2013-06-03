//
//  RAFApplicative.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "RAFApply.h"

@protocol RAFApplicative <RAFApply>

// The identity to -[<RAFApply> raf_apply:].
//
// value - a value :: a.
//
// Returns a value in a context :: F a.
+ (instancetype)raf_point:(id)value;
@end
