//
//  CTDirectionPickerViewController.h
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/18/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString*(^CTTitleGetterBlock)(id object);
typedef void(^CTItemPickCompletionBlock)(id object);

@interface CTItemPickerViewController : UITableViewController

@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) id selectedItem;
@property (nonatomic, copy) CTTitleGetterBlock titleGetter;
@property (nonatomic, copy) CTItemPickCompletionBlock completion;

- (void)setTitleGetter:(CTTitleGetterBlock)titleGetter;
- (void)setCompletion:(CTItemPickCompletionBlock)completion;

@end
