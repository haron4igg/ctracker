//
//  NSError+Additions.m
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "NSError+Additions.h"


NSString * const ErrorDomain = @"com.currencytracker";


@implementation NSError (Additions)

+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message {
    return [NSError errorWithDomain:ErrorDomain
                               code:code
                           userInfo:message ? @{ NSLocalizedDescriptionKey : message } : nil
            ];
}

- (NSString *)message {
    return self.userInfo[NSLocalizedDescriptionKey];
}

- (BOOL)isNetworkProblem {
    return (self.code == NetworkErrorNoConnection || self.code == NetworkErrorServerIsUnreachable);
}

- (ErrorCode)errorCode {
    return (ErrorCode)self.code;
}

+ (id)errorWithCode:(NSInteger)code message:(NSString *)errorMessage userInfo:(NSDictionary *)userInfo {
    return [self errorWithDomain:ErrorDomain code:code message:errorMessage userInfo:userInfo];
}

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)errorMessage userInfo:(NSDictionary *)userInfo {
    
    NSMutableDictionary *finalDictionary = [NSMutableDictionary dictionaryWithDictionary:userInfo ?: @{}];
    if (errorMessage != nil) {
        [finalDictionary setObject:errorMessage forKey:NSLocalizedDescriptionKey];
    }
    
    return [NSError errorWithDomain:domain
                               code:code
                           userInfo:finalDictionary];
}

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)errorMessage {
    return [NSError errorWithDomain:domain
                               code:code
                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:errorMessage, NSLocalizedDescriptionKey,nil]];
}

+ (id)errorWithException:(NSException *)exception {
    return [NSError errorWithDomain:ErrorDomain
                               code:LocalErrorRaisedException
                           userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Raised Exception: %@ Reason: %@",exception.name, exception.reason], NSLocalizedDescriptionKey,nil]];
}

+ (id)errorWithURLRequestError:(NSError *)error {
    NSInteger errorCode = -1;
    NSString *errorMsg  = nil;
    
    switch (error.code) {
        case kCFURLErrorNetworkConnectionLost:
        case kCFURLErrorNotConnectedToInternet:
            errorCode = NetworkErrorNoConnection;
            errorMsg = [NSString stringWithFormat:@"Please check your internet connection. ErrorCode: %ld", (long)error.code];
            break;
            
        case kCFURLErrorUnknown:
        case kCFURLErrorCancelled:
        case kCFURLErrorBadURL:
        case kCFURLErrorTimedOut:
        case kCFURLErrorUnsupportedURL:
        case kCFURLErrorCannotFindHost:
        case kCFURLErrorCannotConnectToHost:
        case kCFURLErrorResourceUnavailable:
        case kCFURLErrorBadServerResponse:
        case kCFURLErrorZeroByteResource:
        case kCFURLErrorCannotDecodeRawData:
        case kCFURLErrorCannotDecodeContentData:
        case kCFURLErrorCannotParseResponse:
        case kCFURLErrorDataLengthExceedsMaximum:
        case 22: //from NSPOSIXErrorDomain
            errorMsg = [NSString stringWithFormat:@"Server is not responding. Please try again. ErrorCode: %ld", (long)error.code];
            errorCode = NetworkErrorServerIsUnreachable;
            break;
        default:
            errorCode = NetworkErrorServerIsUnreachable;
            errorMsg  = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
            break;
    }
    
    return [NSError errorWithCode:errorCode
                          message:errorMsg];
}

@end
