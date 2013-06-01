//
//  RAFFormletModels.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFLens.h"

@protocol RAFText
@end

@protocol RAFNumber
@end

@interface NSString (RAFText) <RAFText>
@end

@interface NSNumber (RAFNumber) <RAFNumber>
@end
