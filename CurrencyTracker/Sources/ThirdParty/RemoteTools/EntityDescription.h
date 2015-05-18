//
//  EntityDescription.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PropertyTransformer;


@protocol EntityDescription <NSObject>

- (PropertyTransformer *)propertyTransformerForLocalKey:(NSString *)localKey;
- (id <EntityDescription>)subEntityDescriptionForKey:(NSString *)localKey;

- (NSSet *)exceptionKeys;
- (NSSet *)requiredKeys;

- (Class)defaultModelClass;

- (void)objectDidParse:(id)object toDictionary:(NSMutableDictionary *)dictionary;

@end
