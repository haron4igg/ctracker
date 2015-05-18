//
//  Constants.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import <Foundation/Foundation.h>



#pragma mark - Property Keys

FOUNDATION_EXPORT NSString * const HTTPMethodGET;
FOUNDATION_EXPORT NSString * const HTTPMethodPOST;
FOUNDATION_EXPORT NSString * const HTTPMethodPUT;
typedef NSString * HTTPMethodType;


#pragma mark - Error Codes


typedef enum {
    ServiceError                                 = 1,
    NetworkErrorNoConnection                     = -10000,
    NetworkErrorServerIsUnreachable              = -10001,
    LocalErrorFailedToParseResponce              = -10002,
    LocalErrorRaisedException                    = -10003,
    LocalErrorUnableToSerializeObject            = -10004
}   ErrorCode;




#pragma mark - Other

#define ONE_DAY_IN_SECONDS 60*60*24

