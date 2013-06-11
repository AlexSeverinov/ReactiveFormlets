//
//  RAFButtonRow.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/10/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "RAFButtonRow.h"

@interface RAFButtonRow ()
@property (strong, nonatomic) RACUnit *unit;
@end

@implementation RAFButtonRow

- (id)init {
	if (self = [super init]) {
		self.unit = [RACUnit defaultUnit];
	}

	return self;
}

- (UITableViewCell *)cell {
	UITableViewCell *cell = [super cell];
	cell.textLabel.text = self.title;
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	return cell;
}

- (id)copyWithZone:(NSZone *)zone {
	RAFButtonRow *copy = [super copyWithZone:zone];
	copy.unit = self.unit;
	copy.command = self.command;
	copy.title = self.title;
	return copy;
}

- (RACSignal *)rawDataSignal {
	return RACAble(self.unit);
}

- (NSString *)keyPathForLens {
	return @keypath(self.unit);
}

- (void)rowWasSelected {
	[super rowWasSelected];
	[self.command execute:self];

	[self.cell setSelected:NO animated:YES];
}

@end
