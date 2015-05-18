//
//  EntityImp.m
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "RemoteEntity.h"
#import "RemoteEntityDescription.h"
#import "PropertyTransformer.h"


@implementation EntityImp

+ (RemoteEntityDescription *)entityDescription {
    return nil;
}

- (RemoteEntityDescription *)entityDescription {
    return nil;
}

#pragma mark - Dictionary Representation

- (NSMutableDictionary *)dictionaryRepresentationUsingEntityDescription:(id <EntityDescription>)entityDescription
                                                          forRemoteData:(BOOL)forRemoteData {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    __block NSString *remoteKey = nil;
    __block PropertyTransformer *transformer = nil;
    __block id nativeValue = nil;
    __block id dictionaryValue = nil;
    
    id <EntityDescription> currentEntity = (entityDescription ?: ([self entityDescription]));
    __block NSSet *exceptionKeys = [currentEntity exceptionKeys];
    
    [self enumerateIvarListUsingBlock:^(NSString *localKey) {
        
        if ([exceptionKeys containsObject:localKey]) {
            return;
        }
        
        dictionaryValue = nativeValue = [self valueForKey:localKey];
        
        
        if (nativeValue != nil) {
            
            if (forRemoteData) {
                transformer = [currentEntity propertyTransformerForLocalKey:localKey];
                remoteKey = transformer ? transformer.remoteKey : localKey;
            }
            else {
                remoteKey = localKey;
            }
            
            if ([nativeValue isKindOfClass:[RemoteEntity class]]) {
                dictionaryValue = [(RemoteEntity *)nativeValue dictionaryRepresentationUsingEntityDescription:entityDescription forRemoteData:forRemoteData];
            }
            else if ([nativeValue conformsToProtocol:@protocol(DictionaryRepresentation)]) {
                dictionaryValue = [(id <DictionaryRepresentation>)nativeValue remoteDictionaryRepresentationUsingEntityDescription:[currentEntity subEntityDescriptionForKey:localKey]];
            }
            else if (([nativeValue isKindOfClass:[NSArray class]] && [[nativeValue lastObject] conformsToProtocol:@protocol(DictionaryRepresentation)]) ||
                     ([nativeValue isKindOfClass:[NSSet class]] || [nativeValue isKindOfClass:[NSOrderedSet class]])) {
                NSMutableArray *array = [NSMutableArray array];
                for (id subValue in nativeValue) {
                    //TODO: perform refactoring. Optimize.
                    if ([subValue isKindOfClass:[RemoteEntity class]]) {
                        [array addObject:[subValue dictionaryRepresentationUsingEntityDescription:[currentEntity subEntityDescriptionForKey:localKey]
                                                                                    forRemoteData:forRemoteData]];
                    }
                    else if ([subValue conformsToProtocol:@protocol(DictionaryRepresentation)]) {
                        [array addObject:[subValue remoteDictionaryRepresentationUsingEntityDescription:[currentEntity subEntityDescriptionForKey:localKey]]];
                    }
                    else {
                        [array addObject:subValue];
                    }
                    
                }
                dictionaryValue = array;
            }
            
            if (forRemoteData && transformer) {
                dictionaryValue = [transformer remoteFromLocalValue:dictionaryValue]; //TODO: check it. Do we need pass dictionaryValue... maybe nativeValue?
            }
            
            [dictionary setObject:dictionaryValue forKey:remoteKey];
        }
    }];
    
    [currentEntity objectDidParse:self toDictionary:dictionary];
    
    return dictionary;
}

- (NSMutableDictionary *)remoteDictionaryRepresentationUsingEntityDescription:(RemoteEntityDescription *)entityDescription {
    return [self dictionaryRepresentationUsingEntityDescription:entityDescription forRemoteData:YES];
}

- (NSMutableDictionary *)dictionaryRepresentationForRemoteData:(BOOL)forRemoteData {
    return [self dictionaryRepresentationUsingEntityDescription:nil forRemoteData:forRemoteData];
}

- (NSMutableDictionary *)remoteDictionaryRepresentation {
    return [self dictionaryRepresentationForRemoteData:YES];
}

- (NSMutableDictionary *)localDictionaryRepresentation {
    return [self dictionaryRepresentationForRemoteData:NO];
}

@end
