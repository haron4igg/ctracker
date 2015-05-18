//
//  EntityImp.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "Serializable.h"
#import "Entity.h"
#import "DictionaryRepresentation.h"

@class RemoteEntityDescription;


@interface EntityImp : Serializable <DictionaryRepresentation>

+ (RemoteEntityDescription *)entityDescription;
- (RemoteEntityDescription *)entityDescription;

@end
