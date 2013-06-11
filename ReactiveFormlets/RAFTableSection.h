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

@class RAFInputRow;
@interface RAFTableSection : RAFCompoundFormlet <RAFTableSection>
- (NSArray *)rows;
- (CGFloat)heightForRowAtIndex:(NSUInteger)index;
- (void)didSelectRowAtIndex:(NSUInteger)index;
- (UITableViewCell *)cellForRowAtIndex:(NSUInteger)row;
@end
