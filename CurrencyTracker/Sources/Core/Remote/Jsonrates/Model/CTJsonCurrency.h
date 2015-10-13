//
//  CTJsonCurrency.h
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "JsonEntity.h"
#import "CTCurrency.h"

@interface CTJsonCurrency : JsonEntity <CTCurrency>

@property (nonatomic, strong) NSDictionary *quotes;

@end
