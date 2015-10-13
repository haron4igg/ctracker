//
//  CTDatePropertyTransformer.h
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "PropertyTransformer.h"

FOUNDATION_EXPORT NSString * const CTJsonratesDateFormat;

@interface CTUtcDatePropertyTransformer : PropertyTransformer

@end

id CTUtcDateTransformerCreate(NSString *remoteKey);


@interface CTDateOnlyPropertyTransformer : PropertyTransformer

@end

id CTDateOnlyTransformerCreate(NSString *remoteKey);



@interface CTUnixTSPropertyTransformer : PropertyTransformer

@end


id CTUnixTSTransformerCreate(NSString *remoteKey);