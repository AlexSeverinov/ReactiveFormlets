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

@implementation RAFTextFieldInputRow {
	RACSubject *_fieldDidFinishEditingSignal;
}

- (id)init {
	if (self = [super init]) {
		_fieldDidFinishEditingSignal = [RACSubject subject];
		
		_textField = [[UITextField alloc] initWithFrame:CGRectMake(0.f, 5.f, 285.f, 35.f)];
		_textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		_textField.returnKeyType = UIReturnKeyDone;
		_textField.delegate = self;

		@weakify(self);
		[RACObserve(self, lastInTabOrder) subscribeNext:^(NSNumber *isLast) {
			@strongify(self);
			self.textField.returnKeyType = isLast.boolValue ? UIReturnKeyDone : UIReturnKeyNext;
		}];

		self.cell.accessoryView = _textField;

		RAC(self, textField.enabled) = RACObserve(self, editable);

		[RACObserve(self, configureTextField) subscribeNext:^(void (^configure)(UITextField *)) {
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

- (RACSignal *)fieldDidFinishEditingSignal {
	return _fieldDidFinishEditingSignal;
}

- (BOOL)canEdit {
	return YES;
}

- (void)beginEditing {
	[self.textField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	[_fieldDidFinishEditingSignal sendNext:RACUnit.defaultUnit];
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
