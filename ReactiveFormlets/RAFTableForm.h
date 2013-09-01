//
//  RAFTableForm.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RAFFormlet.h"
#import "RAFTableSection.h"

@interface RAFTableForm : RAFCompoundFormlet
@property (strong, readonly) UITableView *tableView;
@property (copy) NSArray *sections;           // NSArray[RAFTableSection]

// Defaults to linear order of rows for which -canEdit is YES.
@property (copy) NSArray *rowsByEditingOrder; // NSArray[RAFTableRow]

+ (Class)tableFormMomentClass;    // Defaults to RAFTableFormMoment
@end
