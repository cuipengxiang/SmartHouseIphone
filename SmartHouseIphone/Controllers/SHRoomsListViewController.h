//
//  SHRoomsListViewController.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-3.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"

@interface SHRoomsListViewController : SHParentViewController<UITableViewDelegate, UITableViewDataSource, GCDAsyncSocketDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSThread *roomListQueryThread;
@property (nonatomic)dispatch_queue_t socketQueue;

@end
