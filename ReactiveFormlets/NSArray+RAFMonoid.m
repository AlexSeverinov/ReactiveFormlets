//
//  NSArray+RAFMonoid.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "NSArray+RAFMonoid.h"

@implementation NSArray (RAFMonoid)

+ (instancetype)raf_zero {
	return @[];
}

- (instancetype)raf_append:(NSArray *)value {
	return [self arrayByAddingObjectsFromArray:value];
}

@end
