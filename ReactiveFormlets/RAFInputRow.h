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

@interface RAFTextFieldInputRow : RAFInputRow
@property (copy) void (^configureTextField)(UITextField *field);
@end

@interface RAFTextInputRow : RAFTextFieldInputRow <RAFText>
@end

@interface RAFNumberInputRow : RAFTextFieldInputRow <RAFNumber>
@end
