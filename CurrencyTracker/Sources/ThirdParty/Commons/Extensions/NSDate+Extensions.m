//
//  NSDate+Extensions.m
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import "NSDate+Extensions.h"


@implementation NSDate (Extensions)

- (NSDate *)dateByTrimmingTime {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:self];
    return [calendar dateFromComponents:components];
}

@end
