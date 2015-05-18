//
//  CTGetCurrencyHistoryRequest.h
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "CTGetCurrencyRequest.h"

@interface CTGetCurrencyHistoryRequest : CTGetCurrencyRequest

@property (nonatomic, strong) NSDate *date;

@end
