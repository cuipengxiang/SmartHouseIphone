//
//  SHRoomsListViewController.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-3.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"

@interface SHRoomsListViewController : SHParentViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end
