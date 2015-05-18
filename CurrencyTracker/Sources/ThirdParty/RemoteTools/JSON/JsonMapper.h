//
//  JsonMapper.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RemoteEntity.h"


#define JSONMapper [JsonMapper mapper]


@interface JsonMapper : NSObject

+ (JsonMapper *)mapper;

- (id)parseJSONData:(NSData *)jsonData withClass:(Class)classOfObject error:(NSError **)anError;
- (id)parseJSONString:(NSString *)jsonString withClass:(Class)classOfObject error:(NSError **)anError;

- (NSData *)JSONDataFromRemoteEntity:(RemoteEntity *)remoteEntity error:(NSError **)error;
- (NSData *)JSONDataFromDictionary:(NSDictionary *)dictionary error:(NSError **)error;

@end


#pragma mark - Categories

@interface NSData (JSONMapperDeserializing)

- (id)remoteObjectWithClass:(Class)classOfObject error:(NSError **)error;

@end


@interface NSDictionary (JSONMapperDeserializing)

- (id)remoteObjectWithClass:(Class)classOfObject error:(NSError **)error;

@end


@interface NSString (JSONMapperDeserializing)

- (id)remoteObjectWithClass:(Class)classOfObject error:(NSError **)error;
- (id)objectFromJSONWithError:(NSError **)anError;

@end


@interface RemoteEntity (JSONMapperDeserializing)

+ (id)remoteObjectFromJSONData:(NSData *)jsonData error:(NSError **)error;

@end


@interface RemoteEntity (JSONMapperSerializing)

- (NSData *)JSONDataWithError:(NSError **)error;

@end


@interface NSDictionary (JSONMapperSerializing)

- (NSData *)JSONDataWithError:(NSError **)error;
- (NSString *)JSONStringWithError:(NSError **)error;

@end


@interface NSString (JSONMapperSerializing)

- (NSData *)JSONDataWithError:(NSError **)error;

@end


@interface NSArray (JSONMapperSerializing)

- (NSData *)JSONDataWithError:(NSError **)error;
- (NSString *)JSONStringWithError:(NSError *__autoreleasing *)anError;

@end