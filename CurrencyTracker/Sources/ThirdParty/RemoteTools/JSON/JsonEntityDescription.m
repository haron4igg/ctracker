//
//  JsonEntityDescription.m
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "JsonEntityDescription.h"
#import "PropertyTransformer.h"


NSString *const UnderscoreString = @"_";


@interface JsonEntityDescription ()

@property (nonatomic) NSMutableDictionary *propertyTransformersByLocalName;

@end


@implementation JsonEntityDescription


- (NSString *)convertToRemoteKey:(NSString *)localKey {
    if ([[localKey substringToIndex:1] isEqualToString:UnderscoreString]) {
        return [localKey substringFromIndex:1];
    }
    return localKey;
}

- (PropertyTransformer *)propertyTransformerForLocalKey:(NSString *)localKey {
    
    id transformer = self.propertyTransformersByLocalName[localKey];
    if (transformer) {
        if ([transformer isKindOfClass:[NSString class]]) {
            transformer = TransformerCreate(transformer);
            self.propertyTransformersByLocalName[localKey] = transformer;
        }
        
        if (!((PropertyTransformer *)transformer).remoteKey.length) {
            ((PropertyTransformer *)transformer).remoteKey = [self convertToRemoteKey:localKey];
        }
    }
    else {
        transformer = TransformerCreate([self convertToRemoteKey:localKey]);
        if (transformer) {
            self.propertyTransformersByLocalName[localKey] = transformer;
        }
    }
    
    return transformer;
}

@end
