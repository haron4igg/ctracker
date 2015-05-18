//
//  PropertyTransformer.m
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "PropertyTransformer.h"


@interface PropertyTransformer ()

@property (nonatomic, strong) NSArray *remoteKeyPath;

@end


@implementation PropertyTransformer

+ (id)propertyTransformerWithRemoteKey:(NSString *)remoteKey {
    return [[self alloc] initWithRemoteKey:remoteKey];
}

- (id)initWithRemoteKey:(NSString *)remoteKey {
    self = [self init];
    if (self) {
        self.remoteKey = remoteKey;
    }
    return self;
}

- (void)setRemoteKey:(NSString *)remoteKey {
    _remoteKey = remoteKey;
    self.remoteKeyPath = [remoteKey componentsSeparatedByString:@"."];
}

- (Class)inputRemoteValueClass {
    return nil;
}

- (id)localFromRemoteValue:(id)value {
    return value;
}

- (id)remoteFromLocalValue:(id)value {
    return value;
}

@end

id TransformerCreate(NSString *remoteKey) {
    return [PropertyTransformer propertyTransformerWithRemoteKey:remoteKey];
}
