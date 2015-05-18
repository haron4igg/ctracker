//
//  BlockOperation.m
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "BlockOperation.h"

@implementation BlockOperation

- (id)initWithMainBlock:(OperationMainBlock)mainBlock completion:(OperationCompletion)completion{
    self = [self initWithCompetion:completion];
    if (self) {
        self.mainBlock = mainBlock;
    }
    return self;
}

- (id)run:(NSError *__autoreleasing *)error {
    return self.mainBlock ? self.mainBlock(error) : nil;
}

@end
