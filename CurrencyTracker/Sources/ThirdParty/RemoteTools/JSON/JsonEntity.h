//
//  JsonEntity.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "RemoteEntity.h"

@class JsonEntityDescription;


@interface JsonEntity : RemoteEntity

+ (JsonEntityDescription *)entityDescription;
- (JsonEntityDescription *)entityDescription;

@end
