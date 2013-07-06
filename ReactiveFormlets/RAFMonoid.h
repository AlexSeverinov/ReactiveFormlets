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

@concrete
// objects - a sequence of objects conforming to <RAFMonoid>.
// Returns the result of folding these objects left onto the receiver's +raf_zero.
+ (instancetype)raf_sum:(RACSequence *)objects;
@end
