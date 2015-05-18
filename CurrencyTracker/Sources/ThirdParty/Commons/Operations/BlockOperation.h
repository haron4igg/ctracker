//
//  BlockOperation.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "BaseOperation.h"


typedef id(^OperationMainBlock)(NSError *__autoreleasing *error);


@interface BlockOperation : BaseOperation

@property (nonatomic, copy) OperationMainBlock mainBlock;

- (id)initWithMainBlock:(OperationMainBlock)mainBlock completion:(OperationCompletion)completion;

@end
