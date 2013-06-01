//
//  RAFTableSection.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFFormlet.h"

@class UITableViewCell;

@protocol RAFTableSection
@property (copy) NSString *headerTitle;
@property (copy) NSString *footerTitle;
@end

@interface RAFTableSection : RAFCompoundFormlet <RAFTableSection>
- (NSUInteger)numberOfRows;
- (UITableViewCell *)cellForRow:(NSUInteger)row;
@end
