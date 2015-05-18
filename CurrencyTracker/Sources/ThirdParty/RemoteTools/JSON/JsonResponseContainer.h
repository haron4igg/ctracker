//
//  JsonResponseContainer.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "ResponseContainer.h"



@interface JsonResponseContainer : NSObject <ResponseContainer>

@property (nonatomic) id response;
@property (nonatomic) id result;

@end
