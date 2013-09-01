//
//  RAFInputRow.h
//  ReactiveCocoa
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFFormlet.h"
#import "RAFTableRow.h"

@class UIView, UITableViewCell;

@interface RAFInputRow : RAFTableRow
@end

@interface RAFTextFieldInputRow : RAFInputRow <UITextFieldDelegate>
@property (strong, readonly) UITextField *textField;
@end

@interface RAFTextInputRow : RAFTextFieldInputRow <RAFString>
@end

@interface RAFNumberInputRow : RAFTextFieldInputRow <RAFNumber>
@end
