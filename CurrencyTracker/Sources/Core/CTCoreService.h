//
//  CTCoreService.h
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CTCurrency.h"
#import "CTConvertDirection.h"


#define CoreService [CTCoreService service]


@interface CTCoreService : NSObject

@property (nonatomic, readonly) NSArray *availableDirections;
@property (nonatomic, readwrite) id<CTConvertDirection> defaultDirection;

+ (CTCoreService *)service;


#pragma mark - Asyc Data Source

- (void)fetchCurrencyRate:(id<CTConvertDirection>)direction completion:(void (^)(id<CTCurrency> today, id<CTCurrency> yesterday, NSError *error))completion;


@end
