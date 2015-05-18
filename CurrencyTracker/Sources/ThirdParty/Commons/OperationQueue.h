//
//  OperationQueue.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface OperationQueue : NSOperationQueue

@property (nonatomic, strong, readonly) NSMutableDictionary *registry;

- (void)addOperation:(NSOperation *)op forKey:(NSString *)key owerrideIfExist:(BOOL)owerrideIfExist;

- (void)addOperation:(NSOperation *)op forKey:(NSString *)key;

- (void)removeOperationWithKey:(NSString *)key;

- (BOOL)hasOperationWithKey:(NSString *)key;

@end
