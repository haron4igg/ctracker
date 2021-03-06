//
//  CTDatePropertyTransformer.m
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "CTUtcDatePropertyTransformer.h"
#import "DateUtilities.h"


NSString * const CTJsonratesDateFormat = @"yyyy-MM-dd";

@implementation CTUtcDatePropertyTransformer

- (NSDate *)localFromRemoteValue:(NSString *)value {
    return [DateUtilities dateFromStringGMT:value format:CTJsonratesDateFormat locale:nil];
}

- (NSString *)remoteFromLocalValue:(NSDate *)value {
    return [DateUtilities stringGMTFromDate:value format:CTJsonratesDateFormat locale:nil];
}

@end



id CTUtcDateTransformerCreate(NSString *remoteKey) {
    return [CTUtcDatePropertyTransformer propertyTransformerWithRemoteKey:remoteKey];
}




@implementation CTDateOnlyPropertyTransformer

- (NSDate *)localFromRemoteValue:(NSString *)value {
    return [DateUtilities dateFromSqlDateString:value];
}

- (NSString *)remoteFromLocalValue:(NSDate *)value {
    return [DateUtilities stringSqlDateFromDate:value];
}

@end



id CTDateOnlyTransformerCreate(NSString *remoteKey) {
    return [CTDateOnlyPropertyTransformer propertyTransformerWithRemoteKey:remoteKey];
}



@implementation CTUnixTSPropertyTransformer

- (NSDate *)localFromRemoteValue:(NSNumber *)value {
    return [NSDate dateWithTimeIntervalSince1970:value.integerValue];
}

- (NSNumber *)remoteFromLocalValue:(NSDate *)value {
    return @(value.timeIntervalSince1970);
}

@end



id CTUnixTSTransformerCreate(NSString *remoteKey) {
    return [CTUnixTSPropertyTransformer propertyTransformerWithRemoteKey:remoteKey];
}




