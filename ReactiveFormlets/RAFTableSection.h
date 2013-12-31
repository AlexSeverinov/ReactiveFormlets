//
//  RAFTableSection.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFFormlet.h"

@interface RAFTableSection : RAFCompoundFormlet
@property (copy, nonatomic) NSString *headerTitle;
@property (copy, nonatomic) NSString *footerTitle;
@property (strong, nonatomic) UIView *headerView;
@property (strong, nonatomic) UIView *footerView;
@property (copy, nonatomic) NSArray *rows;

// Table sections are quotiented by the equality of their uniqueIdentifiers;
// that is, two RAFTableSections are considered equal if their uniqueIdentifiers
// are equal. When a uniqueIdentifier is not present, we fall back to pointer
// equality.
@property (copy, nonatomic) NSString *uniqueIdentifier;

- (id)initWithUniqueIdentifier:(NSString *)identifier rows:(NSArray *)rows headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle headerView:(UIView *)headerView footerView:(UIView *)footerView;

+ (instancetype)uniqueIdentifier:(NSString *)identifier rows:(NSArray *)rows;
+ (instancetype)uniqueIdentifier:(NSString *)identifier rows:(NSArray *)rows headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle;

// A signal of immutable RAFTableSection objects which fires for every change to a mutable receiver.
- (RACSignal *)moments; // RACSignal[RAFTableSection]
@end
