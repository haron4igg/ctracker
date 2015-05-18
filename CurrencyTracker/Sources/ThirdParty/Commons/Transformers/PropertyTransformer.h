//
//  PropertyTransformer.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PropertyTransformer : NSObject

@property (nonatomic, strong) NSString *remoteKey;
@property (nonatomic, strong, readonly) NSArray *remoteKeyPath;


+ (id)propertyTransformerWithRemoteKey:(NSString *)remoteKey;
- (id)initWithRemoteKey:(NSString *)remoteKey;

- (Class)inputRemoteValueClass;

- (id)localFromRemoteValue:(id)value;
- (id)remoteFromLocalValue:(id)value;

@end

id TransformerCreate(NSString *remoteKey);