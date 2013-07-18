//
//  RAFTableRow.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/10/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/ReactiveFormlets.h>

@interface RAFTableRow : RAFPrimitiveFormlet
@property (strong, readonly) UITableViewCell *cell;
@property (assign) BOOL lastInTabOrder;

- (RACSignal *)fieldDidFinishEditingSignal; // RACSignal[RACUnit]
- (BOOL)canEdit;
- (void)beginEditing;

+ (Class)cellClass;
- (CGFloat)height;
- (void)rowWasSelected __attribute__((objc_requires_super));
@end
