//
//  RAFTableSectionMoment.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/24/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "RAFTableSectionMoment.h"

@implementation RAFTableSectionMoment

- (id)initWithRows:(NSArray *)rows headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle  headerView:(UIView *)headerView footerView:(UIView *)footerView {
	if (self = [super init]) {
		_rows = [rows copy];
		_headerTitle = [headerTitle copy];
		_footerTitle = [footerTitle copy];
		_headerView = headerView;
		_footerView = footerView;
	}

	return self;
}

@end
