//
//  RAFFormletModels.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFLens.h"

@protocol RAFText <RAFExtract>
@concrete
- (NSString *)raf_extract;
@end

@protocol RAFNumber <RAFExtract>
@concrete
- (NSNumber *)raf_extract;
@end

@protocol RAFUnit <RAFExtract>
@concrete
- (RACUnit *)raf_extract;
@end

@interface NSString (RAFText) <RAFText>
@end

@interface NSNumber (RAFNumber) <RAFNumber>
@end

@interface RACUnit (RAFUnit) <RAFUnit>
@end