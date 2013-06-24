//
//  RAFTableSection.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/12/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFFormlet.h"

@interface RAFTableSection : RAFCompoundFormlet
@property (copy) NSString *headerTitle;
@property (copy) NSString *footerTitle;
@property (copy) NSArray *rows;
@end
