//
//  RAFSemigroup.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <ReactiveCocoa/RACSequence.h>
#import "EXTConcreteProtocol.h"

@protocol RAFSemigroup
// A semigroup `M` has an associative operation, where `M` is a class adopting
// <RAFSemigroup>.
//
// [receiver] - a value in M.
// value - a value in M.
//
// Returns a value in M.
- (instancetype)raf_append:(id<RAFSemigroup>)value;

@concrete
// objects - a sequence of objects conforming to <RAFSemigroup>.
// zero - an object conforming to <RAFSemigroup>.
// Returns the result of folding objects left onto zero.
+ (instancetype)raf_sum:(RACSequence *)objects onto:(id<RAFSemigroup>)zero;
@end
