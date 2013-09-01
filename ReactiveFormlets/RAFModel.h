//
//  RAFFormletModels.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFCast.h"

@protocol RAFText <RAFCast>
@concrete
- (NSString *)raf_cast;
@end

@protocol RAFNumber <RAFCast>
@concrete
- (NSNumber *)raf_cast;
@end

@protocol RAFUnit <RAFCast>
@concrete
- (RACUnit *)raf_cast;
@end

@interface NSString (RAFText) <RAFText>
@end

@interface NSNumber (RAFNumber) <RAFNumber>
@end

@interface RACUnit (RAFUnit) <RAFUnit>
@end
