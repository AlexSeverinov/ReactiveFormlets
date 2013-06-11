//
//  RAFButtonRow.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/10/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import "RAFTableRow.h"

@interface RAFButtonRow : RAFTableRow <RAFUnit>
@property (strong, nonatomic) RACCommand *command;
@property (copy, nonatomic) NSString *title;
@end
