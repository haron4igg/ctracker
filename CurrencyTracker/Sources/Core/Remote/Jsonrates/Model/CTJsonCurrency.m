//
//  CTJsonCurrency.h
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "CTJsonCurrency.h"
#import "CTDoublePropertyTransformer.h"
#import "CTUtcDatePropertyTransformer.h"





@implementation CTJsonCurrency

@synthesize from;
@synthesize to;
@synthesize rate;
@synthesize date;

+ (void)setUpEntityDescription:(RemoteEntityDescription *)entityDescription {
    [super setUpEntityDescription:entityDescription];
    
    [entityDescription addPropertyTransformersByLocalKey:@{
                                                                @"date" : CTUtcDateTransformerCreate(@"utctime"),
                                                                @"rate" : CTDoubleTransformerCreate(nil)
                                                           }];
}

@end
