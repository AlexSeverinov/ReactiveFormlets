//
//  NSInvocation+RAFExtensions.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/27/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "NSInvocation+RAFExtensions.h"
#import "RAFOrderedDictionary.h"
#import <ReactiveCocoa/RACSequence.h>
#import <ReactiveCocoa/RACTuple.h>
#import <ReactiveCocoa/NSArray+RACSequenceAdditions.h>
#import <ReactiveCocoa/EXTScope.h>

@implementation NSInvocation (RAFExtensions)

- (NSArray *)raf_keywords {
	NSPredicate *notEmpty = [NSPredicate predicateWithBlock:^BOOL (NSString *string, id _) {
		return string.length > 0;
	}];

	NSString *selector = NSStringFromSelector(self.selector);
	NSArray *components = [selector componentsSeparatedByString:@":"];
	return [components filteredArrayUsingPredicate:notEmpty];
}

- (NSArray *)raf_arguments {
	NSUInteger count = self.methodSignature.numberOfArguments;
	NSMutableArray *arguments = [NSMutableArray arrayWithCapacity:count];

	for (NSUInteger i = 2; i < count; ++i) {
		__unsafe_unretained id argument = nil;
		[self getArgument:&argument atIndex:i];
		[arguments addObject:argument ?: [NSNull null]];
	}

	return arguments;
}

- (RAFOrderedDictionary *)raf_argumentDictionary {
	NSArray *keywords = self.raf_keywords;
	NSArray *values = self.raf_arguments;

	return [[RAFOrderedDictionary new] modify:^(id<RAFMutableOrderedDictionary> dict) {
		for (NSInteger i = 0; i < keywords.count; ++i) {
			dict[keywords[i]] = values[i];
		}
	}];
}

@end
