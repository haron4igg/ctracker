//
//  JsonRemoteManager.m
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//


#import "JsonRemoteManager.h"


@interface JsonRemoteManager ()

@property (nonatomic) NSOperationQueue *networkQueue;

@end


@implementation JsonRemoteManager

- (id)init {
    self = [super init];
    if (self) {
        self.networkQueue = [NSOperationQueue new];
        self.networkQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

- (JsonRemoteOperation *)executeRequestWithURL:(NSString *)URL
                                 requestObject:(JsonEntity *)requestObject
                                          type:(HTTPMethodType)type
                                      canceled:(BOOL *)canceled
                                         error:(NSError **)anError {
    
    NSError *error = nil;
    NSDictionary *dictionaryRep = [requestObject remoteDictionaryRepresentation];
    DLog(@"\n--------\nRequest %@\n", URL);
    DLog(@"\n\n Request Dictionary:\n\n%@", dictionaryRep);
    
    NSData *jsonData = [dictionaryRep JSONDataWithError:&error];
    DLog(@"\n\n Request JSON body:\n\n%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
    if (error) {
        error = [NSError errorWithDomain:ErrorDomainDefault
                                    code:LocalErrorUnableToSerializeObject
                                userInfo:dictionaryRep];
        SetErrorAndReturn(error, anError, nil);
    }
    
    NSDictionary *headers = [self defaultHeaders];
    
    JsonRemoteOperation *operation = [[JsonRemoteOperation alloc] initWithURL:URL
                                                                      headers:headers
                                                                  requestBody:jsonData
                                                                   httpMethod:type
                                                                      timeout:20
                                                                     canceled:canceled];
    
    [self.networkQueue addOperation:operation];
    
    [operation waitUntilFinished];
    
    return operation;
}


- (id)callServiceMethod:(NSString *)method
          requestObject:(id)aRequestObject
          responseClass:(Class)clazz
                   type:(HTTPMethodType)type
                  error:(NSError **)error {
    
    DLog(@"\n\n\n\n\t\t\t\t\t\t\t\t\t\t\t\t\t\t---=== %@ ===---\n\n\n", method);
    
    NSError *anError = nil;
    NSString *url = [self fullServicePath:method];
    id requestObject = nil;
    
    if ([type isEqualToString:HTTPMethodGET]) {
        
        NSDictionary *requestDict = aRequestObject ? ([aRequestObject isKindOfClass:[NSDictionary class]] ? aRequestObject : [aRequestObject remoteDictionaryRepresentation]) : @{};
        
        DLog(@"requestDict %@", requestDict);
        
        NSDictionary *additionalParameters = [self additionalParameters];
        
        if (additionalParameters.count) {
            NSMutableDictionary * dict = [requestDict mutableCopy];
            [dict addEntriesFromDictionary:additionalParameters];
            requestDict = dict;
        }
        
        url = [url stringByAppendingQueryParameters:requestDict];
    }
    else if ([type isEqualToString:HTTPMethodPOST] || [type isEqualToString:HTTPMethodPUT]) {
        requestObject = aRequestObject;
        CheckErrorAndReturn(anError, error, nil);
    }
    else {
        NSAssert(NO, @"Unsupported method type '%@'", type);
    }
    
    
    JsonRemoteOperation *operation = [self executeRequestWithURL:url
                                                  requestObject:requestObject
                                                           type:type
                                                       canceled:nil
                                                          error:&anError];
    
    CheckErrorAndReturn(anError, error, nil);
    CheckErrorAndReturn(operation.error, error, nil);
    
    if (!operation.result) {
        anError = [NSError errorWithDomain:ErrorDomainDefault
                                      code:NetworkErrorServerIsUnreachable
                                   message:@"Empty response body."];
        SetErrorAndReturn(anError, error, nil);
    }
    
    id returningResult = [self handleResponseData:operation.result
                                         forClass:clazz
                                           method:method
                                            error:&anError];
    CheckErrorAndReturn(anError, error, nil);
    
    return returningResult;
}

- (NSDictionary *)defaultHeaders {
    return nil;
}

- (NSString *)fullServicePath:(NSString *)method {
    return nil;
}

- (NSDictionary *)additionalParameters {
    return nil;
}

- (id)handleResponseData:(id)responseData
                forClass:(Class)clazz
                  method:(NSString *)method
                   error:(NSError *__autoreleasing *)anError {
    
    return nil;
}

@end
