//
//  Serializable.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//
#import <Foundation/Foundation.h>


@interface Serializable : NSObject <NSCoding, NSCopying>

- (void)enumerateIvarListUsingBlock:(void (^)(NSString *key))block;

- (NSMutableDictionary *)dictionaryRepresentation;

@end
