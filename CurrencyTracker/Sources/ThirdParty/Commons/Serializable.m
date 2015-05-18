//
//  Serializable.m
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "Serializable.h"
#import <objc/runtime.h>


@implementation Serializable

- (void)enumerateIvarListUsingBlock:(void (^)(NSString *key))block {
    unsigned int ivarCount;
    Ivar *ivarList = NULL;
    Class currentClass = [self class];
    //TODO: make enumeration by properties, not by ivars
    while ([currentClass isSubclassOfClass:[Serializable class]]) {
        ivarList = class_copyIvarList(currentClass, &ivarCount);
        for (unsigned int i = 0; i < ivarCount; i++) {
            block([NSString stringWithUTF8String:ivar_getName(ivarList[i])]);
        }
        free(ivarList);
        currentClass = [currentClass superclass];
    }
}

- (NSMutableDictionary *)dictionaryRepresentation{
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    __block id nativeValue = nil;
    __block id dictionaryValue = nil;
    
    [self enumerateIvarListUsingBlock:^(NSString *localKey) {

        dictionaryValue = nativeValue = [self valueForKey:localKey];
        
        if (nativeValue != nil) {
            
            if ([nativeValue isKindOfClass:[Serializable class]]) {
                dictionaryValue = [(Serializable *)nativeValue dictionaryRepresentation];
            }
            else if (([nativeValue isKindOfClass:[NSArray class]]) ||
                     ([nativeValue isKindOfClass:[NSSet class]] ||
                      [nativeValue isKindOfClass:[NSOrderedSet class]])) {
                         
                NSMutableArray *array = [NSMutableArray array];
                for (id subValue in nativeValue) {
                    if ([subValue isKindOfClass:[Serializable class]]) {
                        [array addObject:[subValue dictionaryRepresentation]];
                    }
                    else {
                        [array addObject:subValue];
                    }
                    
                }
                dictionaryValue = array;
            }
            
            dictionary[localKey] = dictionaryValue;
        }
    }];
    return dictionary;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {
        [self enumerateIvarListUsingBlock:^(NSString *key) {
            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
        }];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [self enumerateIvarListUsingBlock:^(NSString *key) {
        [coder encodeObject:[self valueForKey:key] forKey:key];
    }];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    id object = [[[self class] allocWithZone:zone] init];
    [self enumerateIvarListUsingBlock:^(NSString *key) {
        id value = [self valueForKey:key];
        if (([[value class] isCollection] && [[value class] isMutable]) || [value isKindOfClass:[NSMutableDictionary class]] || [value isKindOfClass:[NSMutableString class]]) {
            [object setValue:[value mutableCopy] forKey:key];
        } else {
            [object setValue:[value copy] forKey:key];
        }
        
    }];
    return object;
}

@end
