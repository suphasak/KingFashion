//
//  KFSmartCartTableViewController.m
//  KingFashion
//
//  Created by Anh Vu Mai on 10/19/16.
//  Copyright © 2016 Mai Anh Vu. All rights reserved.
//

#import "KFSmartCartTableViewController.h"
#import "KFSmartCartTableViewCell.h"
#import "KFSmartCartManager.h"

@interface KFSmartCartTableViewController ()

@property (nonatomic, strong) NSArray<KFSmartCartItem *> *items;

@end

@implementation KFSmartCartTableViewController

//-------------------------------------------------------------------------------------------------
#pragma mark - Constants
//-------------------------------------------------------------------------------------------------
static NSString *const CELL_ID_ITEM  = @"Smart Cart Table View Cell";

//-------------------------------------------------------------------------------------------------
#pragma mark - Initialization
//-------------------------------------------------------------------------------------------------
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.items = [[KFSmartCartManager sharedManager].smartCartItems array];
}

//-------------------------------------------------------------------------------------------------
#pragma mark - UITableViewDataSource
//-------------------------------------------------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KFSmartCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ID_ITEM
                                                                     forIndexPath:indexPath];

    cell.item = self.items[indexPath.row];
    return cell;
}

@end
