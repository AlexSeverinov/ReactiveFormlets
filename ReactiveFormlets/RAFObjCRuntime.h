//
//  RAFObjCRuntime.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/27/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface RAFObjCRuntime : NSObject
+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)selector inProtocol:(Protocol *)protocol;
+ (NSMethodSignature *)classMethodSignatureForSelector:(SEL)selector inProtocol:(Protocol *)protocol;

/// Allocates and registers a subclass.
///
/// superclass - the class to be subclassed
/// name - the name to be given the subclass.
/// protocols - the protocols which the subclass should adopt.
///
/// Returns the subclass.
+ (Class)subclass:(Class)superclass name:(NSString *)name adopting:(NSArray *)protocols;
@end
