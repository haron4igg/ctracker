//
//  CTDirectionPickerViewController.m
//  CurrencyTracker
//
//  Created by Igor Reshetnikov on 5/18/15.
//  Copyright (c) 2015 CT. All rights reserved.
//

#import "CTItemPickerViewController.h"
#import "CTGUIUtils.h"


@interface CTItemPickerViewController ()

@end

@implementation CTItemPickerViewController

@synthesize items = _items;

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [CTGUIUtils pickerBackgroudColor];
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.layoutMargins = UIEdgeInsetsZero;
    self.tableView.sectionFooterHeight = 0;
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.separatorColor = [UIColor blackColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark -

- (NSString *)titleForItem:(id)item {
    if (self.titleGetter) {
        return self.titleGetter(item);
    }
    return [item description];
}

- (void)setItems:(NSArray *)items {
    _items = items;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.backgroundColor = [CTGUIUtils pickerBackgroudColor];
        cell.selectedBackgroundView = [UIView new];
        cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
        cell.separatorInset = UIEdgeInsetsZero;
        cell.indentationLevel = 0;
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    id item = self.items[indexPath.row];
    
    if ([self.selectedItem isEqual:item]) {
        cell.textLabel.textColor = [UIColor colorWithWhite:1 alpha:1];
        cell.textLabel.font = [CTGUIUtils defaultBlackFontWithSize:15];
    } else {
        cell.textLabel.textColor = [UIColor colorWithWhite:1 alpha:0.7];
        cell.textLabel.font = [CTGUIUtils defaultRegularFontWithSize:15];
    }
    
    cell.textLabel.text = [self titleForItem:item];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedItem = [self.items objectAtIndex:indexPath.row];
    [self.tableView reloadData];
    if (self.completion) {
        self.completion(self.selectedItem);
    }
}


@end
