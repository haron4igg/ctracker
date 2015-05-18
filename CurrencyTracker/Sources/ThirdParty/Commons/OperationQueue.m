//
//  OperationQueue.m
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "OperationQueue.h"


@interface OperationQueue ()

@property (nonatomic, strong) NSMutableDictionary *registry;

@end


@implementation OperationQueue

- (id)init {
    self = [super init];
    if (self) {
        self.registry = [NSMutableDictionary dictionary];
        [self addObserver:self forKeyPath:@"operationCount" options:0 context:NULL];
    }
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"operationCount"]) {
        for (NSString *key in self.registry.allKeys) {
            NSOperation *operation = [self.registry objectForKey:key];
            if (![[self operations] containsObject:operation]) {
                [self.registry removeObjectForKey:key];
            }
        }
    }
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"operationCount"];
}


- (void)addOperation:(NSOperation *)op forKey:(NSString *)key owerrideIfExist:(BOOL)owerrideIfExist {
    NSOperation *existed = [self.registry objectForKey:key];
    
    if (owerrideIfExist) {
        [existed cancel];
        [self.registry removeObjectForKey:key];
        [self addOperation:op];
        [self.registry setObject:op forKey:key];
    } else {
        [self addOperation:op];
        [self.registry setObject:op forKey:key];
    }
}

- (void)addOperation:(NSOperation *)op forKey:(NSString *)key {
    [self addOperation:op forKey:key owerrideIfExist:YES];
}

- (void)removeOperationWithKey:(NSString *)key {
    NSOperation *op = [self.registry objectForKey:key];
    [op cancel];
    [self.registry removeObjectForKey:key];
}

- (BOOL)hasOperationWithKey:(NSString *)key {
    return ([self.registry objectForKey:key] != nil);
}

@end
