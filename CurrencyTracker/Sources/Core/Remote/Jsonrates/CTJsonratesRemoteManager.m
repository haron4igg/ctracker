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

static NSString * const CTServiceURLString                          = @"http://apilayer.net/api/";
static NSString * const CTServiceApiKey                             = @"961cc99ba572057b6c28c612fd2255fa";

static NSString * const CTServiceMethodGet                          = @"live";
static NSString * const CTServiceMethodHistory                      = @"historical";


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
    
    CTGetCurrencyResponse *response = [self callServiceMethod:CTServiceMethodGet
                                                requestObject:request
                                                responseClass:[CTGetCurrencyResponse class]
                                                         type:HTTPMethodGET
                                                        error:anError];
    
    response.from = from;
    response.to = to;
    
    return response;
}

- (NSObject <Result> *)getCurrencyHistoricalRatesFrom:(NSString *)from to:(NSString *)to date:(NSDate *)date error:(NSError **)anError {
    CTGetCurrencyHistoryRequest *request = [CTGetCurrencyHistoryRequest new];
    
    request.from = from;
    request.to = to;
    request.apiKey = CTServiceApiKey;
    request.date = date;

    CTGetCurrencyHistoryResponse *response = [self callServiceMethod:CTServiceMethodHistory
                                                       requestObject:request
                                                       responseClass:[CTGetCurrencyHistoryResponse class]
                                                                type:HTTPMethodGET
                                                               error:anError];
    
    response.from = from;
    response.to = to;
    
    return response;
}

@end
