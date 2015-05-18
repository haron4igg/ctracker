//
//  LOVJsonBucketsResponse.m
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "CTGetCurrencyHistoryResponse.h"
#import "CTJsonCurrency.h"


@implementation CTGetCurrencyHistoryResponse

@synthesize error;
@synthesize rates;

- (id)model {
    return self;
}

@end
