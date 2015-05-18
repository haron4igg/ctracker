//
//  ViewController.m
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/15/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "CTMainViewController.h"
#import "CTCoreService.h"
#import "DateUtilities.h"
#import "CTGUIUtils.h"
#import "CTItemPickerViewController.h"
#import <math.h>



#define CONTAINER_BOTTOM_OFFSET 21


@interface CTMainViewController () <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currencyDirectionLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentsLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLabel;

@property (weak, nonatomic) IBOutlet UIView *pickerContainerView;
@property (weak, nonatomic) IBOutlet UIView *currencyContainerView;

@property (strong, nonatomic) CTItemPickerViewController *pickerController;
@property (strong, nonatomic) UITapGestureRecognizer *closePickerGestureRecognizer;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerBottomSpacing;


@end

@implementation CTMainViewController



#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupCurrencyDirectionLabel:CoreService.defaultDirection];
    [self setupCurrencyValueLabel:nil];
    [self setupCommentText:@"" positiveNews:NO];
    [self setupStatusLabel:@"kMVUpdating".localizedString];
    [self togglePickerController:NO animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}


#pragma mark -


- (void)setupCurrencyDirectionLabel:(NSObject<CTConvertDirection> *)direction {
    
    NSString *text = [NSString stringWithFormat:@"kMVDirectionFormat".localizedString, direction.from.uppercaseString, direction.to.uppercaseString];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];

    
    NSDictionary *attributes = @{
                                    NSFontAttributeName : [CTGUIUtils defaultBoldFontWithSize:17],
                                    NSForegroundColorAttributeName : [CTGUIUtils defaultColorWithAlpha:0.7],
                                    NSKernAttributeName : @1
                                 };
    
    [attributedString setAttributes:attributes range:NSMakeRange(0, attributedString.length)];
    
    self.currencyDirectionLabel.attributedText = attributedString;
}

- (void)setupCurrencyValueLabel:(NSObject<CTCurrency> *)currency {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###0.000"];

    
    NSString *text = [numberFormatter stringFromNumber:currency.rate?: @0];
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [CTGUIUtils defaultRegularFontWithSize:80],
                                 NSForegroundColorAttributeName : [CTGUIUtils defaultColorWithAlpha:1],
                                 NSKernAttributeName : @(-4)
                                 };
    
    [attributedString setAttributes:attributes range:NSMakeRange(0, attributedString.length)];
    
    self.currencyValueLabel.attributedText = attributedString;
}

- (void)setupCommentText:(NSString *)text positiveNews:(BOOL)positiveNews {
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = 1.21f;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIColor *color = positiveNews ? [UIColor colorWithRed:126.0f/255 green:211.0f/255 blue:33.0f/255 alpha:1] : [UIColor colorWithRed:193.0f/255 green:0 blue:0 alpha:1];
    
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName  : paragraphStyle,
                                 NSFontAttributeName            : [CTGUIUtils defaultMediumItalicFontWithSize:17],
                                 NSForegroundColorAttributeName : color,
                                 };
    
    [attributedString setAttributes:attributes range:NSMakeRange(0, attributedString.length)];
    
    self.commentsLabel.attributedText = attributedString;
}

- (void)setupStatusLabel:(NSString *)text {
    if (!text) {
        self.lastUpdateLabel.attributedText = nil;
        return;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text.uppercaseString];
    

    NSDictionary *attributes = @{
                                 NSKernAttributeName            : @(2),
                                 NSFontAttributeName            : [CTGUIUtils defaultBlackFontWithSize:11],
                                 NSForegroundColorAttributeName : [CTGUIUtils defaultColorWithAlpha:0.4],
                                 };
    
    [attributedString setAttributes:attributes range:NSMakeRange(0, attributedString.length)];
    
    self.lastUpdateLabel.attributedText = attributedString;
}




#pragma mark - Helpers

- (void)refresh {
    [CoreService fetchCurrencyRate:CoreService.defaultDirection completion:^(id<CTCurrency> today, id<CTCurrency> yesterday, NSError *error) {
        if (!error) {
            
            [self setupCurrencyDirectionLabel:today];
            [self setupCurrencyValueLabel:today];
            NSString *dateString = [DateUtilities stringWithTimeFromDate:today.date];
            NSString *localized = @"kMVUpdated".localizedString;
            [self setupStatusLabel:[NSString stringWithFormat:localized, dateString]];
            
            
            double todaysRate = today.rate.doubleValue;
            double yesterdaysRate = yesterday.rate.doubleValue;
            double difference = todaysRate/yesterdaysRate;
            
            
            
            NSString *currency = today.from.uppercaseString.localizedString;
            NSString *action = nil;
            BOOL positive;
            if (difference < 1) {
                positive = NO;
                difference = 1 - difference;
                action = @"kMVFell".localizedString;
            } else {
                positive = YES;
                action = @"kMVGrew".localizedString;
                difference -= 1.0;
            }
            
            [self setupCommentText:[NSString stringWithFormat:@"kMVCurrencyDifferenceMessageFormat".localizedString, currency, action, @((int)ceil(difference*100)).localizedPercentage]
                      positiveNews:positive];
        } else {
            //[self setupCommentText:@"kMVServiceError".localizedString
            //          positiveNews:NO];
        }
    }];
    
}




#pragma mark - Actions

- (void)togglePickerController:(BOOL)visible animated:(BOOL)animated {
    
    dispatch_block_t completion_block = nil;
    dispatch_block_t animation_block = nil;

    //
    if (visible) {
        self.pickerController = [CTItemPickerViewController new];
        
        self.pickerController.items = CoreService.availableDirections;
        self.pickerController.selectedItem = CoreService.defaultDirection;
        
        [self.pickerController setTitleGetter:^NSString *(NSObject<CTConvertDirection>* direction) {
            return [NSString stringWithFormat:@"kMVDirectionFormat".localizedString, direction.from.uppercaseString, direction.to.uppercaseString];
        }];
        
        __weak CTMainViewController * selfWeak = self;
        [self.pickerController setCompletion:^(id object) {
            CoreService.defaultDirection = object;
            [selfWeak refresh];
            [selfWeak togglePickerController:NO animated:YES];
        }];
        
        CGRect frame = self.pickerContainerView.bounds;
        frame.size.height -= CONTAINER_BOTTOM_OFFSET;
        [self.pickerController.view setFrame:self.pickerContainerView.bounds];
        [self.pickerContainerView addSubview:self.pickerController.view];
        [self addChildViewController:self.pickerController];        
        
        //self.pickerContainerView.hidden = NO;
        self.closePickerGestureRecognizer = [UITapGestureRecognizer new];
        self.closePickerGestureRecognizer.cancelsTouchesInView = NO;
        self.closePickerGestureRecognizer.delegate = self;
        [self.closePickerGestureRecognizer addTarget:self action:@selector(showCurrencySelector:)];
        [self.view addGestureRecognizer:self.closePickerGestureRecognizer];
        
        animation_block = ^{
            self.pickerBottomSpacing.constant = -CONTAINER_BOTTOM_OFFSET;
        };
    } else {
        if (self.closePickerGestureRecognizer) {
        [self.view removeGestureRecognizer:self.closePickerGestureRecognizer];
        self.closePickerGestureRecognizer = nil;
        }
        
        animation_block = ^{
            self.pickerBottomSpacing.constant = -self.pickerContainerView.frame.size.height;
        };
        
        completion_block = ^{
            if (self.pickerController) {
                [self.pickerController removeFromParentViewController];
                [self.pickerController.view removeFromSuperview];
                self.pickerController = nil;
            }
            //self.pickerContainerView.hidden = YES;
            
        };
    }
    
    [self.pickerController.view layoutIfNeeded];
    [self.view setNeedsUpdateConstraints];
    if (animated) {
        [UIView animateWithDuration:0.5
                              delay:0
             usingSpringWithDamping:0.7
              initialSpringVelocity:0.5
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             if (animation_block) {
                                 animation_block();
                             }
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             if(completion_block) {
                                 completion_block();
                             }
                         }];
        /*
        [UIView animateWithDuration:0.3
                              delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             if (animation_block) {
                                 animation_block();
                             }
                             [self.view layoutIfNeeded];
                         } completion:^(BOOL finished) {
                             if(completion_block) {
                                 completion_block();
                             }
                         }];*/
    } else if(completion_block) {
        animation_block();
        completion_block();
    }
}

- (IBAction)showCurrencySelector:(id)sender {
    [self togglePickerController:!self.pickerController
                        animated:YES];
//    
//    CTDataPickerController *directionPicker = [[CTDataPickerController alloc] init];
//    
//    directionPicker.items = CoreService.availableDirections;
//    directionPicker.selectedItem = CoreService.defaultDirection;
//    
//    [directionPicker setTitleGetter:^NSString *(NSObject<CTConvertDirection>* direction) {
//        return [NSString stringWithFormat:@"kMVDirectionFormat".localizedString, direction.from.uppercaseString, direction.to.uppercaseString];
//    }];
//
//    directionPicker.modalPresentationStyle = UIModalPresentationCurrentContext;
//    [self presentViewController:directionPicker animated:YES completion:nil];
}

#pragma mark - Delegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:self.pickerContainerView]) {
        return NO;
    }
    
    return YES;
}


@end
