//
//  CTGetCurrencyRequest.h
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "JsonEntity.h"

@interface CTGetCurrencyRequest : JsonEntity

@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;

@end
