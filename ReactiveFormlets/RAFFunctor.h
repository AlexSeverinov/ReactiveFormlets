//
//  RAFFunctor.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/22/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

@protocol RAFFunctor
// Corresponds to `fmap` in Haskell's Functor. Apply a pure function
// `(a -> b)` to a value `F a` (the receiver, where `F` is the class of the
// receiver which implements <RAFFunctor>.
//
// [receiver] - a value in a context :: F a
// function - a pure function :: a -> b
//
// Returns a value in the context :: F b.
- (id)raf_map:(id(^)(id value))function;
@end
