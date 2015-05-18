//
//  BaseOperation.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OperationCompletion)(id result, BOOL canceled, NSError *error);


@interface BaseOperation : NSOperation

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id result;
@property (nonatomic, copy) OperationCompletion completion;

- (id)initWithCompetion:(OperationCompletion)completion;

@end


@interface BaseOperation (Abstract)

/*
 To be overriden by subclasess to perform action
 */
- (id)run:(NSError **)error;

@end