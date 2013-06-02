//
//  RAFMonoid.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFSemigroup.h>

@protocol RAFMonoid <RAFSemigroup>
+ (instancetype)raf_zero;
@end
