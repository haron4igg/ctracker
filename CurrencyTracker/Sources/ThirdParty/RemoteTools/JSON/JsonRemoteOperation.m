//
//  JsonRemoteOperation.m
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//


#import "JsonRemoteOperation.h"
#import "Constants.h"
#import "Utilities.h"


static NSTimeInterval const LOVRequestConnectionTimeout = 60.0;
static NSTimeInterval const LOVRequestIOTimeout = 60.0;


@interface JsonRemoteOperation ()

@property (nonatomic, strong) NSURLConnection *connection;
@property (nonatomic, assign) BOOL isConnectionFinished;

@property (nonatomic, strong) NSMutableURLRequest *requestInternal;
@property (nonatomic, strong) NSHTTPURLResponse *responseInternal;
@property (nonatomic, strong) NSMutableData *dataInternal;

- (void)notifyCanceled;
- (void)notifyDone;
- (void)notifyFailed;

@end


@implementation JsonRemoteOperation

- (id)init {
    self = [super init];
    if (self) {
        self.headersEnabled = YES;
    }
    return self;
}

- (id)initWithURL:(NSString *)URL
          headers:(NSDictionary *)headers
      requestBody:(NSData *)body
       httpMethod:(NSString *)method
          timeout:(NSTimeInterval)timeout
         canceled:(BOOL *)canceled {
    
    self = [self init];
    if (self) {
        self.responseInternal = nil;
        self.headers = headers;
        self.httpMethod = method;
        self.URL = URL;
        self.postBody = body;
        self.connectionTimeout = timeout > 0 ? timeout : LOVRequestConnectionTimeout;
        self.dataIOTimeout = LOVRequestIOTimeout;
        _canceled = canceled;
    }
    return self;
}

- (int)calculateHeadersSize:(NSDictionary *)headers {
	int res = 0;
	for (NSString * key in headers.allKeys) {
		res += key.length + [(NSString *)[headers objectForKey:key] length] + 4;
	}
	return res;
}

- (void)cancel {
    [super cancel];
    [self.connection cancel];
    self.connection = nil;
    self.isConnectionFinished = YES;
}

- (BOOL)isCancelled {
    return [super isCancelled] || (_canceled != NULL && *_canceled == YES);
}

- (void)main {
    
    if (self.isCancelled) {
        return;
    }
    NSURL *url = [[NSURL alloc] initWithString:self.URL];
    
    DLog(@"url %@ method %@", url, self.httpMethod);
    
    self.requestInternal = [[NSMutableURLRequest alloc] initWithURL:url
                                                        cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                    timeoutInterval:self.connectionTimeout + self.dataIOTimeout];
    
    NSMutableDictionary *headers = [NSMutableDictionary dictionaryWithDictionary:self.requestInternal.allHTTPHeaderFields];
    
    if ([self.httpMethod isEqualToString:HTTPMethodPOST] || [self.httpMethod isEqualToString:HTTPMethodPUT]) {
        [headers setObject:[@(self.postBody.length) stringValue] forKey:@"Content-Length"];
        [headers setObject:@"application/json; charset=utf-8" forKey:@"Content-Type"];
    }
    
    [headers addEntriesFromDictionary:self.headers];
    
    [self.requestInternal setAllHTTPHeaderFields:self.headersEnabled ? headers : @{}];
    [self.requestInternal setHTTPMethod:self.httpMethod];
    [self.requestInternal setHTTPBody:self.postBody];
    [self setAuthenticationForRequest:self.requestInternal];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:self.requestInternal delegate:self startImmediately:NO];
    
    NSRunLoop* rl = [NSRunLoop currentRunLoop];
    self.isConnectionFinished = NO;
    [self.connection scheduleInRunLoop:rl forMode:NSDefaultRunLoopMode];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.connection start];
    
    while(!self.isConnectionFinished) {
        if (_canceled != NULL && *_canceled == YES) {
            [self cancel];
            break;
        }
        if (!self.isConnectionFinished) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    self.result = self.dataInternal;
    
    if (!self.isCancelled) {
        if (self.error != nil) {
            [self notifyFailed];
        } else {
            [self notifyDone];
        }
    } else {
        [self notifyCanceled];
    }
    
    if (self.completion) {
        self.completion();
    }
}


- (void)setAuthenticationForRequest:(NSMutableURLRequest *)request
{
   /*
    NSMutableString* dataString = [[NSMutableString alloc] initWithString:[NSString stringWithFormat:@"%@:%@", HTTP_USERNAME, HTTP_PASSWORD]];
    NSData* encodeData = [dataString dataUsingEncoding:NSUTF8StringEncoding];
    
    char encodeArray[512];
    memset(encodeArray, '\0', sizeof(encodeArray));
    base64encode([encodeData length], (char *)[encodeData bytes], sizeof(encodeArray), encodeArray);

    NSString* encodeString = [NSString stringWithCString:encodeArray encoding:NSASCIIStringEncoding];
    NSString* authenticationString = [@"" stringByAppendingFormat:@"Basic %@", encodeString];
    [request addValue:authenticationString forHTTPHeaderField:@"Authorization"];
    */
}



- (void)resetConnection {
    DLog(@"Reset connection by manual timeout");
    self.error = [NSError errorWithCode:NetworkErrorServerIsUnreachable
                                message:@"Server is not responding. Please try again. ErrorCode: (manual timeout)"];
    
    [self cancel];
}

- (void)setResetTimeout:(NSTimeInterval)nextTimeOut {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self performSelector:@selector(resetConnection) withObject:nil afterDelay:nextTimeOut];
}

- (void)stopTimeout {
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (NSURLRequest *)connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)response {
    [self setResetTimeout:self.connectionTimeout];
    
    
    if (!self.headersEnabled) {
        request = [request mutableCopy];
        [(NSMutableURLRequest *)request setAllHTTPHeaderFields:@{}];
    }
    
    DLog(@"Connection will send reqest with url: %@\nHeaders:\n%@\nBody Length %lu\n timeout: %f", request.URL, request.allHTTPHeaderFields, (unsigned long)request.HTTPBody.length, self.connectionTimeout);
#ifdef DEBUG
    NSString *string = [[NSString alloc] initWithData:request.HTTPBody encoding:NSUTF8StringEncoding];
    DLog(@"JSON Request: %@", string);
#endif
    return request;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response {
    [self setResetTimeout:self.dataIOTimeout];
    
    self.responseInternal = (NSHTTPURLResponse *)response;
    
    DLog(@"Connection did receive response: %ld data timeout: %f. Headers:\n\n%@\n\n", (long)[response statusCode], self.dataIOTimeout, response.allHeaderFields);
    
    self.dataInternal = [NSMutableData data];
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self setResetTimeout:self.dataIOTimeout];
    [self.dataInternal appendData:data];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    [self stopTimeout];
    DLog(@"%@", error);
    
    self.error = error;
    self.isConnectionFinished = YES;
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
    [self stopTimeout];
    
    if (self.responseInternal.statusCode != 200) {
        NSString *string = [[NSString alloc] initWithData:self.dataInternal encoding:NSUTF8StringEncoding];
        self.error = [NSError errorWithCode:NetworkErrorServerIsUnreachable
                                    message:[NSString stringWithFormat:@"Server is not responding. Status Code: %ld. Responce: %@", (long)self.responseInternal.statusCode, string]];
    }
#ifdef DEBUG
    NSString *string = [[NSString alloc] initWithData:self.dataInternal encoding:NSUTF8StringEncoding];
    DLog(@"JSON Response: %@", string);
#endif
    self.isConnectionFinished = YES;
}


- (void)notifyCanceled {
    if ([self.delegate respondsToSelector:@selector(remoteOperationCanceled:)]) {
        [self.delegate remoteOperationCanceled:self];
    }
}

- (void)notifyDone {
    if ([self.delegate respondsToSelector:@selector(remoteOperationDone:)]) {
        [self.delegate remoteOperationDone:self];
    }
}

- (void)notifyFailed {
    if ([self.delegate respondsToSelector:@selector(remoteOperationFailed:)]) {
        [self.delegate remoteOperationFailed:self];
    }
}


@end
