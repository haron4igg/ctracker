//
//  BaseOperation.m
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "BaseOperation.h"
#import "CTCoreService.h"

@implementation BaseOperation {
    BOOL cancelInternal;
}

- (id)initWithCompetion:(OperationCompletion)completion {
    self = [self init];
    if (self) {
        cancelInternal = NO;
        self.completion = completion;
    }
    return self;
}

- (void)main {
    if (self.isCancelled) {
        return;
    }
    
    @autoreleasepool {
        @try {
            NSError *error = nil;
            //[CoreService openTransaction];
            self.result = [self run:&error]; //[[self run:&error] objectContainer];
            @try {
                //[CoreService closeTransaction];
            }
            @catch (NSException *exception) {
                DLog(@"%@", exception);
            }
            
            self.error = error;
            if (error) {
                DLog(@"%@", error);
            }
        }
        @catch (NSException *exception) {
            self.error = [NSError errorWithDomain:NSStringFromClass([self class])
                                             code:0
                                         userInfo:exception.userInfo];
            DLog(@"Exception: %@", exception.name);
            DLog(@"Reason: %@", exception.reason);
            DLog(@"Call stack: %@", [exception callStackSymbols]);
            
#ifdef DEBUG
            @throw exception;
#endif
            
        }
        @finally {
            [self fireCompletion];
        }
    }
}

- (void)fireCompletion {
    if (_completion) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            //_completion([self.result originalObject], self.isCancelled, self.error);
            _completion(self.result, self.isCancelled, self.error);
        });
    }
}

- (void)cancel {
    [super cancel];
    cancelInternal = YES;
}

@end
