//
//  RAFTableFormMoment.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/24/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RAFTableRow.h"

@interface RAFTableFormMoment : NSObject <UITableViewDataSource, UITableViewDelegate>
@property (strong, readonly) NSArray *sectionMoments;

- (id)initWithSectionMoments:(NSArray *)sections;
- (NSIndexPath *)indexPathForRow:(RAFTableRow *)row;
@end
