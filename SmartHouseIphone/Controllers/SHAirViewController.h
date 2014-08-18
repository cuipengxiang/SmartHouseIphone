//
//  SHAirViewController.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"
#import "SHAirConditioningModel.h"

@interface SHAirViewController : SHParentViewController<UIScrollViewDelegate>
{
    UIScrollView *airScrollView;
    UIView *selectedView;
    NSMutableArray *selectedBlocks;
    BOOL skip;
}

@property (nonatomic, strong)NSArray *airs;
@property (nonatomic, strong)NSMutableArray *airViews;
@property (nonatomic)dispatch_queue_t socketQueue;
@property (nonatomic, strong)NSThread *airQueryThread;
@property (nonatomic)int currentPage;

@end
