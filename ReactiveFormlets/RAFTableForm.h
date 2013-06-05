//
//  RAFTableForm.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RAFFormlet.h"

// Many RAFTableSection
@interface RAFTableForm : RAFCompoundFormlet <UITableViewDataSource, UITableViewDelegate>
- (UITableView *)buildView;
@end

// Many RAFTableRow
@interface RAFSingleSectionTableForm : RAFTableForm
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *footerTitle;
@end
