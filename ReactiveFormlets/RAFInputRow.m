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

@implementation RAFInputRow

- (id)init
{
	if (self = [super init])
	{
		self.cell.selectionStyle = UITableViewCellSelectionStyleNone;
	}

	return self;
}

- (instancetype)placeholder:(NSString *)placeholder {
	return nil;
}

@end


@interface RAFTextFieldInputRow () <UITextFieldDelegate>
@property (strong, readonly) UITextField *textField;
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
	}

	return self;
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

- (instancetype)placeholder:(NSString *)placeholder {
	return [self modifyTextField:^(UITextField *field) {
		field.placeholder = placeholder;
	}];
}

- (instancetype)modifyTextField:(void (^)(UITextField *field))block {
	RAFTextFieldInputRow *copy = [self copy];
	block(copy.textField);
	return copy;
}

- (id)copyWithZone:(NSZone *)zone {
	RAFTextFieldInputRow *row = [super copyWithZone:zone];
	UITextField *textField = row.textField;
	textField.font = row.textField.font;
	textField.textColor = row.textField.textColor;
	textField.textAlignment = row.textField.textAlignment;
	textField.frame = self.textField.frame;
	textField.placeholder = self.textField.placeholder;
	textField.secureTextEntry = self.textField.secureTextEntry;
	textField.autocorrectionType = self.textField.autocorrectionType;
	textField.autocapitalizationType = self.textField.autocapitalizationType;
	textField.keyboardType = self.textField.keyboardType;
	textField.keyboardAppearance = self.textField.keyboardAppearance;
	return row;
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

- (id)init
{
	if (self = [super init])
	{
		self.textField.keyboardType = UIKeyboardTypeNumberPad;
	}

	return self;
}

- (NSValueTransformer *)valueTransformer {
	return [NSValueTransformer valueTransformerForName:RAFNumberStringValueTransformerName];
}

@end
