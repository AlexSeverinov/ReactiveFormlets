//
//  RAFObjCRuntime.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/27/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFObjCRuntime.h"

typedef enum : BOOL {
	RAFInstanceMethodScope = YES,
	RAFClassMethodScope = NO
} RAFMethodScope;

typedef enum : BOOL {
	RAFRequiredMethod = YES,
	RAFOptionalMethod = NO
} RAFMethodObligation;

@implementation RAFObjCRuntime

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)selector inProtocol:(Protocol *)protocol scope:(RAFMethodScope)scope obligation:(RAFMethodObligation)obligation {
	const char *types = protocol_getMethodDescription(protocol, selector, obligation, scope).types;
	return types ? [NSMethodSignature signatureWithObjCTypes:types] : nil;
}

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)selector inProtocol:(Protocol *)protocol scope:(RAFMethodScope)scope {
	return ([self methodSignatureForSelector:selector
								  inProtocol:protocol
									   scope:scope
								  obligation:RAFRequiredMethod] ?:
			[self methodSignatureForSelector:selector
								  inProtocol:protocol
									   scope:scope
								  obligation:RAFOptionalMethod]);
}

+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)selector inProtocol:(Protocol *)protocol {
	return [self methodSignatureForSelector:selector inProtocol:protocol scope:RAFInstanceMethodScope];
}

+ (NSMethodSignature *)classMethodSignatureForSelector:(SEL)selector inProtocol:(Protocol *)protocol {
	return [self methodSignatureForSelector:selector inProtocol:protocol scope:RAFClassMethodScope];
}

+ (Class)subclass:(Class)superclass name:(NSString *)name adopting:(NSArray *)protocols {
	Class subclass = objc_getClass(name.UTF8String);
	if (subclass != nil) return subclass;

	subclass = objc_allocateClassPair(superclass, name.UTF8String, 0);
	objc_registerClassPair(subclass);

	for (Protocol *protocol in protocols) {
		class_addProtocol(subclass, protocol);
	}

	return subclass;
}

@end
