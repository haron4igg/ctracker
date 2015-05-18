//
//  RemoteEntityDescription.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EntityDescription.h"


@interface RemoteEntityDescription : NSObject <EntityDescription, NSCopying>

@property (nonatomic) Class defaultModelClass;

- (void)addPropertyTransformersByLocalKey:(NSDictionary *)propertyTransformers;

- (void)addSubEntityDescriptionsByLocalKey:(NSDictionary *)subEntityDescriptions;

- (void)addExceptionKeys:(NSSet *)exceptionKeys;
- (void)addRequiredKeys:(NSSet *)requiredKeys;

- (void)setDefaultPropertyTransformerClass:(Class)class;

@end
