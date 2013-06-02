//
//  RAFApplicative.h
//  ReactiveFormlets
//
//  Created by Jon Sterling on 6/1/13.
//  Copyright (c) 2013 Jon Sterling. All rights reserved.
//

#import <ReactiveFormlets/RAFApply.h>

@protocol RAFApplicative <RAFApply>
+ (instancetype)raf_point:(id)value;
@end
