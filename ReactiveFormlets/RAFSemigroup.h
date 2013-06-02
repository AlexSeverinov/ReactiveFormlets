//
//  RAFSemigroup.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

@protocol RAFSemigroup
// A semigroup `M` has an associative operation, where `M` is a class adopting
// <RAFSemigroup>.
//
// [receiver] - a value in M.
// value - a value in M.
//
// Returns a value in M.
- (instancetype)raf_append:(id<RAFSemigroup>)value;
@end
