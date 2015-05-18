//
//  RemoteEntity.m
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "RemoteEntity.h"
#import "PropertyTransformer.h"


@implementation RemoteEntity

static NSMutableDictionary *_entityDescriptionsByClassName = nil;

+ (NSMutableDictionary *)entityDescriptionsByClassName {
    if (!_entityDescriptionsByClassName) {
        _entityDescriptionsByClassName = [NSMutableDictionary dictionary];
    }
    
    return _entityDescriptionsByClassName;
}

+ (RemoteEntityDescription *)entityDescription {
    
    NSString *classString = NSStringFromClass([self class]);
    
    RemoteEntityDescription *entityDescription = self.entityDescriptionsByClassName[classString];
    
    if (!entityDescription) {
        entityDescription = [[self entityDescriptionClass] new];
        [self setUpEntityDescription:entityDescription];
        self.entityDescriptionsByClassName[classString] = entityDescription;
    }
    
    return entityDescription;
}

- (RemoteEntityDescription *)entityDescription {
    return [[self class] entityDescription];
}

+ (void)setUpEntityDescription:(RemoteEntityDescription *)entityDescription {
    entityDescription.defaultModelClass = [self class];
}


- (void)awakeFromMapping {
    
}

+ (Class)entityDescriptionClass {
    return [RemoteEntityDescription class];
}

- (NSString *)debugDescription {
    return self.localDictionaryRepresentation.description;
}

@end
