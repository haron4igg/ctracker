//
//  CTCurrency.h
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "Entity.h"
#import "CTConvertDirection.h"

@protocol CTCurrency <CTConvertDirection>

@property (nonatomic, strong) NSNumber *rate;
@property (nonatomic, strong) NSDate *date;

@end
