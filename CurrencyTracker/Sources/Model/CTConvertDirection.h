//
//  CTConvertDirection.h
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/18/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

@protocol CTConvertDirection <Entity>

@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *to;

@end
