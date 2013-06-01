//
//  RAFFormletModels.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFLens.h"

// A suitable model protocol
@protocol RAFModel
@end

// Some primitive models are provided.
@protocol RAFText <RAFModel>
@end

@protocol RAFNumber <RAFModel>
@end

@interface NSString (RAFText) <RAFText>
@end

@interface NSNumber (RAFNumber) <RAFNumber>
@end
