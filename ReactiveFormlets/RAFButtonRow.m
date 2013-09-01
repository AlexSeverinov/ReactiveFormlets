//
//  RAFButtonRow.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/10/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "RAFButtonRow.h"
#import "EXTScope.h"

@implementation RAFButtonRow {
	RACChannel *_channel;
}

- (id)init {
	if (self = [super init]) {
		RAC(self, cell.textLabel.text) = RACObserve(self, title);
		self.cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

		_channel = [RACChannel new];
		[[self.command.executionSignals mapReplace:RACUnit.defaultUnit] subscribe:_channel.leadingTerminal];

		@weakify(self);
		[_channel.leadingTerminal subscribeNext:^(id value) {
			@strongify(self);
			[self.command execute:value];
		}];
	}

	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	RAFButtonRow *copy = [super copyWithZone:zone];
	copy.command = self.command;
	copy.title = self.title;
	return copy;
}

- (RACChannel *)channel {
	return _channel;
}

- (void)rowWasSelected {
	[super rowWasSelected];
	[self.command execute:self];

	[self.cell setSelected:NO animated:YES];
}

@end
