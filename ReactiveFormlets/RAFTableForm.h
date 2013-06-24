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
@property (copy) NSArray *sections;
@end

// This is a premade form which will mirror the model (and the protocol) of the
// section that is provided it.
@interface RAFOneSectionTableForm : RAFTableForm
+ (id)section:(RAFTableSection *)section;
@end