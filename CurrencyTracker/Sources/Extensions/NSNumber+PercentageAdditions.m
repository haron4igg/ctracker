//
//  NSNumber+PercentageAdditions.m
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "NSNumber+PercentageAdditions.h"

@implementation NSNumber (PercentageAdditions)

/*
 
 "kPersent0" = "процентов";
 "kPersent1" = "процент";
 "kPersent2" = "процента";
 
 */

- (NSString *)localizedPercentage {
    NSString *percentKey = @"kPersent";
    if ([[[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleLanguageCode] isEqualToString:@"ru"]) {
        int ending = self.intValue % 10;
        if ( (ending == 0) || (self.intValue >= 10 && self.intValue <= 19) ) {
            percentKey = @"kPersent0";
        } else if ( ending == 1) {
            percentKey = @"kPersent";
        } else if ( ending >= 2 && ending <= 4) {
            percentKey = @"kPersent2";
        } else {
            percentKey = @"kPersent0";
        }
    }
    
    return [NSString stringWithFormat:@"%d %@",self.intValue, percentKey.localizedString];
}

@end
