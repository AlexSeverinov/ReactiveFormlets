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
@property (strong, readonly, nonatomic) UITableView *tableView;

/// An array of `RAFTableSection`.
@property (copy, nonatomic) NSArray *sections;

/// An array of `RAFTableRow`.
///
/// Defaults to linear order of rows for which -canEdit is YES.
@property (copy, nonatomic) NSArray *rowsByEditingOrder;

/// The class to use to represent table states at a given moment. This
/// defaults to (and must be a subclass of) RAFTableFormMoment.
+ (Class)tableFormMomentClass;
@end
