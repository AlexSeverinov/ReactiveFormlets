//
//  RAFTableSectionMoment.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/24/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RAFTableSectionMoment : NSObject
@property (copy, readonly) NSString *headerTitle;
@property (copy, readonly) NSString *footerTitle;
@property (copy, readonly) UIView *headerView;
@property (copy, readonly) UIView *footerView;
@property (copy, readonly) NSArray *rows;

- (id)initWithRows:(NSArray *)rows headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle headerView:(UIView *)headerView footerView:(UIView *)footerView;
@end