//
//  RAFTableSectionMoment.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/24/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RAFTableSectionMoment : NSObject
@property (copy, readonly) NSString *headerTitle;
@property (copy, readonly) NSString *footerTitle;
@property (copy, readonly) NSArray *rows;

- (id)initWithRows:(NSArray *)rows headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle;
@end