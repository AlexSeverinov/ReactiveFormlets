//
//  RAFLens.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/19/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFValidator.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "EXTConcreteProtocol.h"

// A concrete protocol designed to support typesafe extraction of values from
// objects of protocol type. -raf_cast is the identity function,
// and serves as a type-safe cast.
@protocol RAFCast
- (id)raf_cast;
@end

@interface NSObject (RAFCast) <RAFCast>
@end
