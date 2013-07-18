//
//  RAFInputRow.m
//  ReactiveCocoa
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFInputRow.h"
#import "RAFNumberStringValueTransformer.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "EXTScope.h"

@implementation RAFInputRow

- (id)init {
	if (self = [super init]) {
		self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	return self;
}

- (instancetype)placeholder:(NSString *)placeholder {
	return nil;
}

@end

@implementation RAFTextFieldInputRow

- (id)init {
	if (self = [super init]) {
		_textField = [[UITextField alloc] initWithFrame:CGRectMake(0.f, 5.f, 285.f, 35.f)];
		_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		_textField.returnKeyType = UIReturnKeyDone;
		_textField.delegate = self;

		self.cell.accessoryView = _textField;

		RAC(self.textField.enabled) = RACAbleWithStart(self.editable);

		@weakify(self);
		[RACAbleWithStart(self.configureTextField) subscribeNext:^(void (^configure)(UITextField *)) {
			@strongify(self);
			if (configure) configure(self.textField);
		}];
	}

	return self;
}

- (id)copyWithZone:(NSZone *)zone
{
	RAFTextFieldInputRow *copy = [super copyWithZone:zone];
	copy.configureTextField = self.configureTextField;
	return copy;
}

- (void)rowWasSelected {
	[super rowWasSelected];
	[self.textField becomeFirstResponder];
}

- (NSString *)keyPathForLens {
	return @keypath(self.textField.text);
}

- (RACSignal *)rawDataSignal {
	return [self.textField.rac_textSignal map:^(NSString *text) {
		return [self.valueTransformer transformedValue:text ?: @""];
	}];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return NO;
}

@end

@implementation RAFTextInputRow

@end

@implementation RAFNumberInputRow

- (id)init {
	if (self = [super init]) {
		self.textField.keyboardType = UIKeyboardTypeNumberPad;
	}

	return self;
}

- (NSValueTransformer *)valueTransformer {
	return [NSValueTransformer valueTransformerForName:RAFNumberStringValueTransformerName];
}

@end
