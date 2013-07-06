//
//  RAFTableRow.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/10/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "RAFTableRow.h"

@implementation RAFTableRow
@synthesize cell = _cell;

- (id)init
{
	if (self = [super init])
	{
		_cell = [[self.class.cellClass alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass(self.class)];
	}

	return self;
}

+ (Class)cellClass {
	return [UITableViewCell class];
}

- (id)copyWithZone:(NSZone *)zone {
	RAFTableRow *row = [super copyWithZone:zone];
	[row updateInPlace:self.raf_extract];
	return row;
}

- (CGFloat)height {
	return 44.f;
}

- (void)rowWasSelected {
	
}

@end
