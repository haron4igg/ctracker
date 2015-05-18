//
//  JsonEntity.m
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "JsonEntity.h"
#import "JsonEntityDescription.h"


@implementation JsonEntity

//TODO: implement handling private ivars (_ivarName)

+ (Class)entityDescriptionClass {
    return [JsonEntityDescription class];
}

+ (JsonEntityDescription *)entityDescription {
    return (JsonEntityDescription *)[super entityDescription];
}

- (JsonEntityDescription *)entityDescription {
    return (JsonEntityDescription *)[super entityDescription];
}

@end
