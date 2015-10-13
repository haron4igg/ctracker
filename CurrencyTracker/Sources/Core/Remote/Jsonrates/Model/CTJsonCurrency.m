//
//  CTJsonCurrency.h
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "CTJsonCurrency.h"
#import "CTDoublePropertyTransformer.h"
#import "CTUtcDatePropertyTransformer.h"





@implementation CTJsonCurrency

@synthesize quotes;
@synthesize from;
@synthesize to;
@synthesize rate;
@synthesize date;

+ (void)setUpEntityDescription:(RemoteEntityDescription *)entityDescription {
    [super setUpEntityDescription:entityDescription];
    
    [entityDescription addPropertyTransformersByLocalKey:@{
                                                                @"date" : CTUnixTSTransformerCreate(@"timestamp"),
                                                                @"rate" : CTDoubleTransformerCreate(nil)
                                                           }];
}


- (void)awakeFromMapping {
    id entityDesc = [self entityDescription];
    self.rate = [[entityDesc propertyTransformerForLocalKey:@"rate"] localFromRemoteValue:[[self.quotes allValues] firstObject]];
}


@end
