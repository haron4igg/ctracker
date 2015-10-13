//
//  CTGetCurrencyRequest.m
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "CTGetCurrencyRequest.h"


@implementation CTGetCurrencyRequest

@synthesize apiKey;
@synthesize from;
@synthesize to;



+ (void)setUpEntityDescription:(RemoteEntityDescription *)entityDescription {
    [super setUpEntityDescription:entityDescription];
    [entityDescription addPropertyTransformersByLocalKey:@{@"apiKey" : @"access_key"}];
    [entityDescription addPropertyTransformersByLocalKey:@{@"from"   : @"source"}];
    [entityDescription addPropertyTransformersByLocalKey:@{@"to"     : @"currencies"}];
}

@end
