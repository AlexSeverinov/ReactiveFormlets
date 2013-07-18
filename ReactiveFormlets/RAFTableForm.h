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

// When YES, the form's `sections` property is automatically set to -allValues.
// When NO, the form's `sections` property must be set manually.
//
// Default: YES.
+ (BOOL)sectionsMirrorData;

+ (Class)tableFormMomentClass;    // Defaults to RAFTableFormMoment
+ (Class)tableSectionMomentClass; // Defaults to RAFTableSectionMoment
@end

// +[RAFCustomTableForm sectionsMirrorData] returns NO.
@interface RAFCustomTableForm : RAFTableForm
@end

// This is a premade form which will mirror the model (and the protocol) of the
// section that is provided it.
@interface RAFOneSectionTableForm : RAFTableForm
+ (id)section:(RAFTableSection *)section;
@end