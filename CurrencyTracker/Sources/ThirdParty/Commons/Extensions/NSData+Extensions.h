//
//  NSData+Extensions.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSData (Extensions)

- (NSString *)base64String;

+ (NSData *)dataWithBase64String:(NSString *)aString;

@end
