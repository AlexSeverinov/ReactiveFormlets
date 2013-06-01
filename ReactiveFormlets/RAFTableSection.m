//
//  RAFTableSection.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFTableSection.h"
#import "RAFInputRow.h"
#import "RAFTableForm.h"
#import "RAFFormlet.h"

@implementation RAFTableSection
@synthesize headerTitle = _headerTitle;
@synthesize footerTitle = _footerTitle;

- (id)copyWithZone:(NSZone *)zone {
	RAFTableSection *copy = [super copyWithZone:zone];
	copy.headerTitle = _headerTitle;
	copy.footerTitle = _footerTitle;
	return copy;
}

- (NSUInteger)numberOfRows {
	return self.count;
}

- (UITableViewCell *)cellForRow:(NSUInteger)index {
	RAFInputRow *row = (self.allValues)[index];
	UITableViewCell *cell = row.cell;
	return cell;
}

@end
