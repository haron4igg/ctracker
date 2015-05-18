//
//  JsonResponseContainer.m
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "JsonResponseContainer.h"

@implementation JsonResponseContainer

- (BOOL)success {
    return self.result != nil;
}

@end
