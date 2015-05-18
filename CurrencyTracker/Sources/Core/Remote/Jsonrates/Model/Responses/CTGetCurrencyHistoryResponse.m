//
//  LOVJsonBucketsResponse.m
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "CTGetCurrencyHistoryResponse.h"
#import "PropertyTransformer.h"
#import "CTJsonCurrency.h"
#import "DateUtilities.h"

@implementation CTGetCurrencyHistoryResponse

@synthesize error;
@synthesize rates;

- (id)model {
    return self;
}

- (void)awakeFromMapping {
    
    //NSString *targetDate = [DateUtilities stringSqlDateFromDate:self.date];
    NSDictionary *currencyRates = [[self.rates allValues] firstObject];
    
    id entityDesc = [self entityDescription];
    
    self.date = [[entityDesc propertyTransformerForLocalKey:@"utctime"] localFromRemoteValue:currencyRates[@"utctime"]];
    self.rate = [[entityDesc propertyTransformerForLocalKey:@"rate"] localFromRemoteValue:currencyRates[@"rate"]];
    
    self.rates = nil;    
}

@end
