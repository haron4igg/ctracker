//
//  CTGetCurrencyResponse.h
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "CTJsonCurrency.h"
#import "ResponseContainer.h"
#import "CTJsonError.h"


@interface CTGetCurrencyResponse : CTJsonCurrency <Result, CTJsonError>

@end
