//
//  RAFFormletModels.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 12/18/12.
//  Copyright (c) 2012 Jon Sterling. All rights reserved.
//

#import "RAFCast.h"

#define RAFDefinePrimitiveModel(ModelName, ClassName)\
	@protocol ModelName <RAFCast>\
	- (ClassName *)raf_cast;\
	@end\
	@interface ClassName (ModelName) <ModelName>\
	@end

RAFDefinePrimitiveModel(RAFString, NSString);
RAFDefinePrimitiveModel(RAFNumber, NSNumber);
RAFDefinePrimitiveModel(RAFUnit, RACUnit);
