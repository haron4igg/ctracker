//
//  NSString+Extensions.h
//  RemoteTools
//
//  Created by Igor Reshetnikov on 3/7/14.
//  Copyright (c) 2014 RemoteTools. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (Extensions)

- (NSString *)normalizedString;
- (NSMutableAttributedString *)attributedString;

- (NSUInteger)integerValueFromHex;

+ (NSString *)uniqueString;
+ (NSString *)randomString;
+ (NSString *)randomStringWithLength:(NSUInteger)length;

- (NSString *)localizedString;

@end


@interface NSString (URLEncoding)

- (NSString *)stringByAppendingQueryParameters:(NSDictionary *)queryParameters;

- (NSDictionary *)queryParameters;

- (NSString *)stringByAddingURLEncoding;

- (NSString *)stringByReplacingURLEncoding;

- (NSString *)stringByDecodingHTMLEntitiesInString;

- (NSString *)stringByDecodingURLFormat;

- (NSString *)stringByStrippingHTML;

@end
