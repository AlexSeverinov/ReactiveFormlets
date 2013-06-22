//
//  RAFMonoid.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "RAFSemigroup.h"

@protocol RAFMonoid <RAFSemigroup>
// The identity to -[<RAFSemigroup> raf_append:].
//
// Returns a value in a monoid M such that
//
//    ∀ x : M, ([x raf_append:[M raf_zero]] ≡ x)
//           ∧ ([[M raf_zero] raf_append:x] ≡ x)
//
+ (instancetype)raf_zero;
@end
