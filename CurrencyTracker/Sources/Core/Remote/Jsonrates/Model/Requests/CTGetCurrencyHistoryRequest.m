//
//  CTGetCurrencyHistoryRequest.m
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "CTGetCurrencyHistoryRequest.h"
#import "CTUtcDatePropertyTransformer.h"

@implementation CTGetCurrencyHistoryRequest

@synthesize date;

+ (void)setUpEntityDescription:(RemoteEntityDescription *)entityDescription {
    [super setUpEntityDescription:entityDescription];
    [entityDescription addPropertyTransformersByLocalKey:@{@"date": CTDateOnlyTransformerCreate(nil)}];
}


@end
