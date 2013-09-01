//
//  RAFSemigroup.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/22/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "RAFSemigroup.h"

@concreteprotocol(RAFSemigroup)

- (instancetype)raf_append:(id<RAFSemigroup>)value {
	return nil;
}

#pragma mark - Concrete

+ (instancetype)raf_sum:(RACSequence *)objects onto:(id<RAFSemigroup>)zero {
	return [objects foldLeftWithStart:zero reduce:^(id accumulator, id value) {
		return [accumulator raf_append:value];
	}];
}

@end
