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

// RAFInputRow is a table row with a text field.
@interface RAFInputRow : RAFTableRow
- (instancetype)placeholder:(NSString *)placeholder;
@end

@interface RAFTextFieldInputRow : RAFInputRow
- (instancetype)modifyTextField:(void (^)(UITextField *field))block;
@end

@interface RAFTextInputRow : RAFTextFieldInputRow <RAFText>
@end

@interface RAFNumberInputRow : RAFTextFieldInputRow <RAFNumber>
@end
