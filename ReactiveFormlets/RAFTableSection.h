//
//  RAFTableSection.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFFormlet.h"

@protocol RAFMutableTableSection;

@protocol RAFTableSection <NSCopying, NSMutableCopying>
@property (copy, readonly) NSString *headerTitle;
@property (copy, readonly) NSString *footerTitle;
@property (strong, readonly) UIView *headerView;
@property (strong, readonly) UIView *footerView;
@property (copy, readonly) NSArray *rows;

// Table sections are quotiented by the equality of their uniqueIdentifiers;
// that is, two RAFTableSections are considered equal if their uniqueIdentifiers
// are equal. When a uniqueIdentifier is not present, we fall back to pointer
// equality.
@property (copy, readonly) NSString *uniqueIdentifier;
@end

@protocol RAFMutableTableSection <RAFTableSection>
@property (copy, readwrite) NSString *headerTitle;
@property (copy, readwrite) NSString *footerTitle;
@property (strong, readwrite) UIView *headerView;
@property (strong, readwrite) UIView *footerView;
@property (copy, readwrite) NSArray *rows;
@property (copy, readwrite) NSString *uniqueIdentifier;
@end

@interface RAFTableSection : RAFCompoundFormlet <RAFTableSection>
- (id)initWithUniqueIdentifier:(NSString *)identifier rows:(NSArray *)rows headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle headerView:(UIView *)headerView footerView:(UIView *)footerView;

+ (instancetype)uniqueIdentifier:(NSString *)identifier rows:(NSArray *)rows;
+ (instancetype)uniqueIdentifier:(NSString *)identifier rows:(NSArray *)rows headerTitle:(NSString *)headerTitle footerTitle:(NSString *)footerTitle;

// A signal of immutable RAFTableSection objects which fires for every change to a mutable receiver.
- (RACSignal *)moments; // RACSignal[RAFTableSection]
@end

@interface RAFTableSection (TypeRefinement)
- (RAFTableSection *)copyWithZone:(NSZone *)zone;
- (RAFTableSection *)copy;

- (RAFTableSection<RAFMutableTableSection> *)mutableCopyWithZone:(NSZone *)zone;
- (RAFTableSection<RAFMutableTableSection> *)mutableCopy;
@end
