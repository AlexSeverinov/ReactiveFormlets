//
//  RAFTableSectionMoment.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/24/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "RAFTableSectionMoment.h"

@implementation RAFTableSectionMoment

- (id)initWithRows:(NSArray *)rows headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle {
	if (self = [super init]) {
		_rows = [rows copy];
		_headerTitle = [headerTitle copy];
		_footerTitle = [footerTitle copy];
	}

	return self;
}

@end
