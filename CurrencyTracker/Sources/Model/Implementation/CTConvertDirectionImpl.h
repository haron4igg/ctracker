//
//  CTConvertDirectionImpl.h
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/18/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "EntityImp.h"
#import "CTConvertDirection.h"

@interface CTConvertDirectionImpl : EntityImp <CTConvertDirection>

@end


id CTConvertDirectionCreate(NSString *from, NSString *to);