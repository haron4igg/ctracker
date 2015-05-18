//
//  JsonRemoteManager.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonRemoteManager.h"
#import "JsonRemoteOperation.h"
#import "JsonMapper.h"
#import "JsonEntity.h"


@interface JsonRemoteManager : NSObject

@end



@interface JsonRemoteManager (protected)

- (id)callServiceMethod:(NSString *)method
          requestObject:(id)aRequestObject
          responseClass:(Class)clazz
                   type:(HTTPMethodType)type
                  error:(NSError **)error;

- (JsonRemoteOperation *)executeRequestWithURL:(NSString *)URL
                                    requestObject:(JsonEntity *)requestObject
                                             type:(HTTPMethodType)type
                                         canceled:(BOOL *)canceled
                                            error:(NSError **)anError;

- (id)handleResponseData:(id)responseData forClass:(Class)clazz method:(NSString *)method error:(NSError **)anError;
- (NSDictionary *)defaultHeaders;
- (NSString *)fullServicePath:(NSString *)method;
- (NSDictionary *)additionalParameters;

@end
