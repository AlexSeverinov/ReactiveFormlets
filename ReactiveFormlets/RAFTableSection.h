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

/// Table sections are quotiented by the equality of their unique identifiers;
/// that is, two `RAFTableSections` are considered equal if their unique identifiers
/// are equal. When a uniqueIdentifier is not present, we fall back to pointer
/// equality.
@property (copy, nonatomic) NSString *uniqueIdentifier;

- (id)initWithUniqueIdentifier:(NSString *)identifier rows:(NSArray *)rows headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle headerView:(UIView *)headerView footerView:(UIView *)footerView;

+ (instancetype)uniqueIdentifier:(NSString *)identifier rows:(NSArray *)rows;
+ (instancetype)uniqueIdentifier:(NSString *)identifier rows:(NSArray *)rows headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle;

/// Returns a signal of `RAFTableSection` objects which fires for every change
/// to the receiver. `RAFTableSection` is mutable, but each element of the signal
/// will be a copy.
- (RACSignal *)moments;
@end
