//
//  RAFApply.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "RAFFunctor.h"

@protocol RAFApply <RAFFunctor>
// Corresponds to `(<*>)` in Haskell's Control.Applicative. Apply a function
// `F (a -> b)` (where `F` is a class adopting <RAFApply>) to a value `F a`.
//
// [receiver] - a function in a context :: F (a -> b).
// operand - a value in a context :: F a.
//
// Returns a value in the context :: F b.
- (id)raf_apply:(id)operand;
@end
