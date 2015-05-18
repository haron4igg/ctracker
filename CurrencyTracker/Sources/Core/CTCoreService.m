//
//  CTCoreService.m
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//



#import "CTCoreService.h"
#import "CTRemoteDataManager.h"
#import "CTJsonratesRemoteManager.h"
#import "OperationQueue.h"
#import "BlockOperation.h"
#import "ResponseContainer.h"
#import "CTConvertDirectionImpl.h"
#import "Utilities.h"



NSString * const kCTConvertDirection = @"CTConvertDirection";



@interface CTCoreService ()

@property NSObject<CTRemoteDataManager> *remoteManager;

@property OperationQueue *operationQueue;

@end


@implementation CTCoreService

@synthesize availableDirections = _availableDirections;
@synthesize defaultDirection = _defaultDirection;

static CTCoreService *_service;

+ (CTCoreService *)service {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [self new];
    });
    return _sharedObject;
}

+ (id)alloc {
	@synchronized([CTCoreService class]) {
		NSAssert(_service == nil, @"Attempted to allocate a second instance of a singleton.");
		_service = [super alloc];
		return _service;
	}
    
	return nil;
}

- (id)init {
    self = [super init];
    if (self) {
        self.remoteManager = [CTJsonratesRemoteManager new];
        
        self.operationQueue = [OperationQueue new];
        self.operationQueue.maxConcurrentOperationCount = 1;
    }
    return self;
}

#pragma mark - Sync Operations



- (NSArray *)availableDirections {
    if (!_availableDirections) {
        _availableDirections = @[
                                 CTConvertDirectionCreate(@"USD", @"RUB"),
                                 CTConvertDirectionCreate(@"USD", @"EUR"),
                                 CTConvertDirectionCreate(@"EUR", @"RUB"),
                                 CTConvertDirectionCreate(@"EUR", @"USD"),
                                 CTConvertDirectionCreate(@"RUB", @"USD"),
                                 CTConvertDirectionCreate(@"RUB", @"EUR")
                                 ];
    }
    return _availableDirections;
}


- (id<CTConvertDirection>)defaultDirection {
    if (!_defaultDirection) {
        NSData *serrializedData = [Utilities readFromUserDefaultsForKey:kCTConvertDirection];
        if (serrializedData) {
            _defaultDirection = [NSKeyedUnarchiver unarchiveObjectWithData:serrializedData];
        } else {
            self.defaultDirection = CTConvertDirectionCreate(@"RUB", @"USD");
        }
    }
    return _defaultDirection;
}

- (void)setDefaultDirection:(id<CTConvertDirection>)defaultDirection {
    _defaultDirection = defaultDirection;
    [Utilities writeToUserDefaultsObject:[NSKeyedArchiver archivedDataWithRootObject:defaultDirection] key:kCTConvertDirection];
}


#pragma mark - Async Operations

- (void)fetchCurrencyRate:(id<CTConvertDirection>)direction completion:(void (^)(id<CTCurrency> today, id<CTCurrency> yesterday, NSError *error))completion {
    
    NSOperation *operation = [[BlockOperation alloc] initWithMainBlock:^id(NSError *__autoreleasing *anError) {
        
        id<CTCurrency> todaysRate = nil;
        id<CTCurrency> yesterdaysRate = nil;
        
        NSError *error = nil;
        
        NSObject<Result> *result = [self.remoteManager getCurrencyRatesFrom:direction.from to:direction.to error:&error];
        CheckErrorAndReturn(error, anError, nil);
        
        todaysRate = result.model;
        
        result = [self.remoteManager getCurrencyHistoricalRatesFrom:direction.from to:direction.to date:[NSDate dateWithTimeIntervalSinceNow:-ONE_DAY_IN_SECONDS] error:&error];
        CheckErrorAndReturn(error, anError, nil);

        
        yesterdaysRate = result.model;
        
        if (!todaysRate || !yesterdaysRate) {
            *anError = [NSError errorWithCode:ServiceError message:@"Unbale to get 'today' or 'yesterday' rate value" userInfo:nil];
            return nil;
        }
        
        return @{
                    @"today"        : todaysRate,
                    @"yesterday"    : yesterdaysRate
                };
    }
                                                            completion:^(id result, BOOL canceled, NSError *error) {
                                                                completion([result objectForKey:@"today"], [result objectForKey:@"yesterday"], error);
                                                            }];
    
    [self.operationQueue addOperation:operation forKey:@"fetch_rates" owerrideIfExist:NO];
}


@end
