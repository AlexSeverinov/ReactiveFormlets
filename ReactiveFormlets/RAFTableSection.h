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

// Optionally a function that reorders the form elements; this can be
// used to prevent certain subforms from displaying, or to introduce
// other subforms which have no bearing on the data model (such as buttons).
@property (copy) NSArray *(^elementOrdering)(id form);
@end

@interface RAFTableSection : RAFCompoundFormlet <RAFTableSection>
- (NSArray *)rows;
- (CGFloat)heightForRowAtIndex:(NSUInteger)index;
- (void)didSelectRowAtIndex:(NSUInteger)index;
- (UITableViewCell *)cellForRowAtIndex:(NSUInteger)row;
@end
