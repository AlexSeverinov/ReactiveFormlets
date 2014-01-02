//
//  RAFReifiedProtocol.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFReifiedProtocol.h"
#import "RAFOrderedDictionary.h"
#import "NSInvocation+RAFExtensions.h"
#import "RAFObjCRuntime.h"
#import <ReactiveCocoa/RACTuple.h>
#import <ReactiveCocoa/RACSequence.h>

// An empty model to serve as the default model for RAFReifiedProtocol.
@protocol RAFEmpty
@end

static void *kModelAssociatedObjectKey = &kModelAssociatedObjectKey;

@implementation RAFReifiedProtocol

+ (Class)model:(Protocol *)model {
	NSString *name = [NSString stringWithFormat:@"%@_%s", self, protocol_getName(model)];

	Class class = [RAFObjCRuntime subclass:self name:name adopting:@[ model ]];
	objc_setAssociatedObject(class, &kModelAssociatedObjectKey, model, OBJC_ASSOCIATION_ASSIGN);

	return class;
}

+ (Protocol *)model {
	return objc_getAssociatedObject(self, &kModelAssociatedObjectKey) ?: @protocol(RAFEmpty);
}

- (id)initWithValues:(NSArray *)values {
	return [[self init] modify:^(id<RAFMutableOrderedDictionary> dict) {
		[self.allKeys enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
			dict[key] = values[idx];
		}];
	}];
}

#pragma mark - Message Forwarding

+ (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	return [RAFObjCRuntime classMethodSignatureForSelector:aSelector inProtocol:self.class.model];
}

+ (void)forwardInvocation:(NSInvocation *)invocation {
	[invocation retainArguments];

	RAFOrderedDictionary *arguments = [invocation.raf_argumentDictionary modify:^(id<RAFMutableOrderedDictionary> dict) {
		for (NSString *key in dict.allKeys)
		{
			if ([dict[key] isKindOfClass:[NSNull class]])
				dict[key] = nil;
		}
	}];

	invocation.returnValue = &(__unsafe_unretained id){
		[[self alloc] initWithOrderedDictionary:arguments]
	};
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
	return [RAFObjCRuntime instanceMethodSignatureForSelector:aSelector inProtocol:self.class.model];
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	NSString *key = NSStringFromSelector(anInvocation.selector);
	anInvocation.returnValue = &(__unsafe_unretained id){
		self[key]
	};
}

- (BOOL)respondsToSelector:(SEL)aSelector {
	return ([self.allKeys containsObject:NSStringFromSelector(aSelector)] ||
			[super respondsToSelector:aSelector]);
}

@end

