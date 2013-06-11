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

@interface RAFTableSection ()
- (RAFInputRow *)rowAtIndex:(NSUInteger)index;
@end

@implementation RAFTableSection
@synthesize headerTitle = _headerTitle;
@synthesize footerTitle = _footerTitle;

- (id)copyWithZone:(NSZone *)zone {
	RAFTableSection *copy = [super copyWithZone:zone];
	copy.headerTitle = _headerTitle;
	copy.footerTitle = _footerTitle;
	return copy;
}

- (NSArray *)rows {
	return self.allValues;
}

- (RAFInputRow *)rowAtIndex:(NSUInteger)index {
	return self.rows[index];
}

- (CGFloat)heightForRowAtIndex:(NSUInteger)index {
	return [self rowAtIndex:index].height;
}

- (UITableViewCell *)cellForRowAtIndex:(NSUInteger)index {
	return [self rowAtIndex:index].cell;
}

- (void)didSelectRowAtIndex:(NSUInteger)index {
	RAFInputRow *row = [self rowAtIndex:index];
	[row.rowWasSelected execute:row];
}

@end
