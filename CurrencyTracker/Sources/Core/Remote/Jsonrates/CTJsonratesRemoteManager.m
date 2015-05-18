//
//  CTJsonratesRemoteManager.m
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "CTJsonratesRemoteManager.h"
#import "JsonResponseContainer.h"
#import "DateUtilities.h"
#import "JsonEntityDescription.h"

#import "CTJsonCurrency.h"

#import "CTGetCurrencyRequest.h"
#import "CTGetCurrencyHistoryRequest.h"

#import "CTGetCurrencyResponse.h"
#import "CTGetCurrencyHistoryResponse.h"

#import "PropertyTransformer.h"


static NSString * const CTServiceURLString                          = @"http://jsonrates.com/";
static NSString * const CTServiceApiKey                             = @"jr-99b86e7086e988bec638a2a6557aec57";

static NSString * const CTServiceMethodGet                          = @"get/";
static NSString * const CTServiceMethodHistory                      = @"historical/";


@implementation CTJsonratesRemoteManager


- (NSString *)fullServicePath:(NSString *)method {
    return [CTServiceURLString stringByAppendingString:method];
}

- (NSDictionary *)additionalParameters {
    return nil;
}

- (id)handleResponseData:(id)responseData forClass:(Class)clazz method:(NSString *)method error:(NSError **)anError {
    
    NSError *error = nil;
    
    id<CTJsonError> result = [clazz remoteObjectFromJSONData:responseData
                                                         error:&error];
    
    CheckErrorAndReturn(error, anError, nil);
    
    if (result.error) {
        *anError = [NSError errorWithCode:ServiceError message:result.error];
        return nil;
    }
    
    return result;
}


#pragma mark - JsonratesRemoteManager implementation

- (NSObject <Result> *)getCurrencyRatesFrom:(NSString *)from to:(NSString *)to error:(NSError **)anError {
    
    
    CTGetCurrencyRequest *request = [CTGetCurrencyRequest new];
    
    request.from = from;
    request.to = to;
    request.apiKey = CTServiceApiKey;
    
    return [self callServiceMethod:CTServiceMethodGet
                     requestObject:request
                     responseClass:[CTGetCurrencyResponse class]
                              type:HTTPMethodGET
                             error:anError];
}

- (NSObject <Result> *)getCurrencyHistoricalRatesFrom:(NSString *)from to:(NSString *)to date:(NSDate *)date error:(NSError **)anError {
    NSError *error = nil;
    
    CTGetCurrencyHistoryRequest *request = [CTGetCurrencyHistoryRequest new];
    
    request.from = from;
    request.to = to;
    request.apiKey = CTServiceApiKey;
    request.date = date;
    
    NSObject<Result> *result = [self callServiceMethod:CTServiceMethodHistory
                                      requestObject:request
                                      responseClass:[CTGetCurrencyHistoryResponse class]
                                               type:HTTPMethodGET
                                              error:&error];
    
    CheckErrorAndReturn(error, anError, nil);

    
    if (result) {
        CTGetCurrencyHistoryResponse * response = (CTGetCurrencyHistoryResponse*)result;
        
        NSString *targetDate = [DateUtilities stringSqlDateFromDate:date];
        NSDictionary *currencyRates = response.rates[targetDate];
        
        response.date = [[[response entityDescription] propertyTransformerForLocalKey:@"utctime"] localFromRemoteValue:currencyRates[@"utctime"]];
        response.rate = [[[response entityDescription] propertyTransformerForLocalKey:@"rate"] localFromRemoteValue:currencyRates[@"rate"]];
        
        response.rates = nil;
    }
    
    
    return result;
}

@end
