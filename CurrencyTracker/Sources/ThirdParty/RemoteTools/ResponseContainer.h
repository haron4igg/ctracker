//
//  ResponseContainer.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Entity.h"

@protocol Result;


@protocol ResponseContainer <Entity>

@property (nonatomic) NSObject <Result> * result;
@property (nonatomic, readonly) BOOL success;

@end


@protocol Result <Entity>

@property (nonatomic, strong, readonly) id model;

@end
