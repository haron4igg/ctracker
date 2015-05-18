//
//  DictionaryRepresentation.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EntityDescription;


@protocol DictionaryRepresentation <NSObject>

@optional // Warning! Actually it is not optional... but warnings abount not implemented methods is to annoying.
- (NSMutableDictionary *)remoteDictionaryRepresentationUsingEntityDescription:(id <EntityDescription>)entityDescription;
- (NSMutableDictionary *)remoteDictionaryRepresentation;
- (NSMutableDictionary *)localDictionaryRepresentation;

@end
