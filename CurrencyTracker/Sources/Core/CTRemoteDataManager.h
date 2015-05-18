//
//  CTRemoteDataManager.h
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Result;

@protocol CTRemoteDataManager <NSObject>

- (NSObject <Result> *)getCurrencyRatesFrom:(NSString *)from to:(NSString *)to error:(NSError **)error;

- (NSObject <Result> *)getCurrencyHistoricalRatesFrom:(NSString *)from to:(NSString *)to date:(NSDate *)date error:(NSError **)error;

@end
