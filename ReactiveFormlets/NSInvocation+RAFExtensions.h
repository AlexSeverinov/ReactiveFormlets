//
//  NSInvocation+RAFExtensions.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/27/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RACSequence;
@class RAFOrderedDictionary;

@interface NSInvocation (RAFExtensions)

/// An array of `NSString` of the invocation's argument keywords
- (NSArray *)raf_keywords;

/// An array of the invocation's arguments.
- (NSArray *)raf_arguments;

/// An ordered dictionary of the invocation's keywords and arguments.
- (RAFOrderedDictionary *)raf_argumentDictionary;

@end
