//
//  CTGUIUtils.m
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/18/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "CTGUIUtils.h"


@implementation CTGUIUtils


+ (UIFont *)defaultBlackFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Lato-Black" size:size];
}

+ (UIFont *)defaultBoldFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Lato-Bold" size:size];
}

+ (UIFont *)defaultRegularFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Lato-Regular" size:size];
}

+ (UIFont *)defaultMediumItalicFontWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Lato-MediumItalic" size:size];
}

+ (UIColor *)defaultColorWithAlpha:(CGFloat)alpha {
    return [UIColor colorWithRed:63.0f/255 green:71.0f/255 blue:83.0f/255 alpha:alpha];
}

+ (UIColor *)pickerBackgroudColor {
    return [UIColor colorWithRed:48.0f/255 green:54.0f/255 blue:65.0f/255 alpha:1];
}

@end
