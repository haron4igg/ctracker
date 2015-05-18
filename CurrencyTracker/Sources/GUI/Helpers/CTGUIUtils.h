//
//  CTGUIUtils.h
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/18/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CTGUIUtils : NSObject

+ (UIFont *)defaultBlackFontWithSize:(CGFloat)size;
+ (UIFont *)defaultBoldFontWithSize:(CGFloat)size;
+ (UIFont *)defaultRegularFontWithSize:(CGFloat)size;
+ (UIFont *)defaultMediumItalicFontWithSize:(CGFloat)size;

+ (UIColor *)defaultColorWithAlpha:(CGFloat)alpha;

+ (UIColor *)pickerBackgroudColor;

@end
