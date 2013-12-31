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

- (id)initWithValidator:(RAFValidator *)validator {
	if (self = [super initWithValidator:validator]) {
		RAC(self, cell.textLabel.text) = RACObserve(self, title);
		self.cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
	}

	return self;
}

- (RACChannel *)channel {
	if (!_channel) {
		_channel = [RACChannel new];
		[[RACObserve(self, command) map:^id(RACCommand *command) {
			return [command.executionSignals mapReplace:RACUnit.defaultUnit];
		}].switchToLatest subscribe:_channel.leadingTerminal];

		@weakify(self);
		[_channel.leadingTerminal subscribeNext:^(id value) {
			@strongify(self);
			[self.command execute:value];
		}];
	}
	return _channel;
}

- (void)rowWasSelected {
	[super rowWasSelected];
	[self.command execute:self];

	[self.cell setSelected:NO animated:YES];
}

@end
