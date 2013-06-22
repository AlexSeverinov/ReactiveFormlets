//
//  RAFMonoid.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/22/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "RAFMonoid.h"

@concreteprotocol(RAFMonoid)

- (instancetype)raf_append:(id<RAFSemigroup>)value {
	return nil;
}

+ (instancetype)raf_zero {
	return nil;
}

+ (instancetype)raf_sum:(RACSequence *)objects {
	return [self raf_sum:objects onto:self.raf_zero];
}

@end