//
//  RAFButtonRow.m
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/10/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "RAFButtonRow.h"
#import "EXTScope.h"

@implementation RAFButtonRow

- (id)initWithValidator:(RAFValidator *)validator {
	if (self = [super initWithValidator:validator]) {
		RAC(self, cell.textLabel.text) = RACObserve(self, title);
		self.cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	return self;
}

- (RACChannel *)buildChannel
{
	RACChannel *channel = [RACChannel new];
	[[RACObserve(self, command) map:^(RACCommand *command) {
		return [command.executionSignals mapReplace:RACUnit.defaultUnit];
	}].switchToLatest subscribe:channel.leadingTerminal];

	@weakify(self);
	[channel.leadingTerminal subscribeNext:^(id value) {
		@strongify(self);
		[self.command execute:value];
	}];

	return channel;
}

- (void)rowWasSelected {
	[super rowWasSelected];
	[self.command execute:self];

	[self.cell setSelected:NO animated:YES];
}

@end
