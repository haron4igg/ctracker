//
//  RemoteEntity.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteEntityDescription.h"
#import "EntityImp.h"


@interface RemoteEntity : EntityImp

+ (void)setUpEntityDescription:(RemoteEntityDescription *)entityDescription;

- (void)awakeFromMapping;

+ (Class)entityDescriptionClass;

@end
