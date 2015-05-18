//
//  CTNumberPropertyTransformer.h
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "PropertyTransformer.h"

@interface CTDoublePropertyTransformer : PropertyTransformer

@end

id CTDoubleTransformerCreate(NSString *remoteKey);