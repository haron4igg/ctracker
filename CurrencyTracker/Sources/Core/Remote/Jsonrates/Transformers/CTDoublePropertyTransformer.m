//
//  CTNumberPropertyTransformer.m
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "CTDoublePropertyTransformer.h"
#import "DateUtilities.h"

@implementation CTDoublePropertyTransformer

- (NSNumber *)localFromRemoteValue:(NSString *)value {
    return [NSNumber numberWithDouble:value.doubleValue];
}

- (NSString *)remoteFromLocalValue:(NSNumber *)value {
    return [value description];
}

@end


id CTDoubleTransformerCreate(NSString *remoteKey) {
    return [CTDoublePropertyTransformer propertyTransformerWithRemoteKey:remoteKey];
}