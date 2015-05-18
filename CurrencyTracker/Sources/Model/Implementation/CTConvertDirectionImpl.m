//
//  CTConvertDirectionImpl.m
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/18/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "CTConvertDirectionImpl.h"

@implementation CTConvertDirectionImpl

@synthesize from;
@synthesize to;

- (BOOL)isEqual:(id<CTConvertDirection>)object {
    return [object conformsToProtocol:@protocol(CTConvertDirection)] && [object.from isEqualToString:self.from] && [object.to isEqualToString:self.to];
}

@end


id CTConvertDirectionCreate(NSString *from, NSString *to) {    
    CTConvertDirectionImpl *dir = [CTConvertDirectionImpl new];
    dir.from = from;
    dir.to = to;
    return dir;
}