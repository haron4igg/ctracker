//
//  NSError+Additions.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import <Foundation/Foundation.h>


#define SetErrorAndReturn(__Error__, __ExternError__, __ReturnValue__) \
if (__ExternError__ != NULL) { \
*__ExternError__ = __Error__; \
} \
return __ReturnValue__;


#define CheckErrorAndReturn(__Error__, __ExternError__, __ReturnValue__) if (__Error__ != nil) { \
SetErrorAndReturn(__Error__, __ExternError__, __ReturnValue__); \
}

#define ErrorDomainDefault NSStringFromClass(self.class)

@interface NSError (Additions)

+ (NSError *)errorWithCode:(NSInteger)code message:(NSString *)message;

+ (id)errorWithCode:(NSInteger)code message:(NSString *)errorMessage userInfo:(NSDictionary *)userInfo;

+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)errorMessage userInfo:(NSDictionary *)userInfo;
+ (id)errorWithDomain:(NSString *)domain code:(NSInteger)code message:(NSString *)errorMessage;

+ (id)errorWithException:(NSException *)exception;

- (NSString *)message;

- (BOOL)isNetworkProblem;

- (ErrorCode)errorCode;

@end
