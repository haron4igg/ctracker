//
//  JsonRemoteOperation.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//


#import <Foundation/Foundation.h>

@protocol JsonRemoteOperationDelegate;


@interface JsonRemoteOperation : NSOperation <NSURLConnectionDelegate, NSURLConnectionDataDelegate> {
     BOOL *_canceled;
}

@property (nonatomic, weak) NSObject <JsonRemoteOperationDelegate> * delegate;
@property (nonatomic, assign) NSTimeInterval connectionTimeout;
@property (nonatomic, assign) NSTimeInterval dataIOTimeout;

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) NSData *result;

@property (nonatomic, strong) NSString *URL;
@property (nonatomic, strong) NSDictionary *headers;
@property (nonatomic, strong) NSString *httpMethod;
@property (nonatomic, strong) NSData *postBody;

@property (nonatomic, strong) dispatch_block_t completion;
@property (nonatomic, assign) BOOL headersEnabled;

- (id)initWithURL:(NSString *)URL
          headers:(NSDictionary *)headers
      requestBody:(NSData *)body
       httpMethod:(NSString *)method
          timeout:(NSTimeInterval)timeout
         canceled:(BOOL *)canceled ;

- (void)setCompletion:(dispatch_block_t)completion;

@end


@protocol JsonRemoteOperationDelegate <NSObject>

@optional
- (void)remoteOperationFailed:(JsonRemoteOperation *)operation;
- (void)remoteOperationDone:(JsonRemoteOperation *)operation;
- (void)remoteOperationCanceled:(JsonRemoteOperation *)operation;

@end

