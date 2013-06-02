//
//  RAFSemigroup.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

@protocol RAFSemigroup
- (instancetype)raf_append:(id<RAFSemigroup>)value;
@end
