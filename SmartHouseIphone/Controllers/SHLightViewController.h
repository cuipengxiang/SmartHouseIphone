//
//  SHLightViewController.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"
#import "SHLightModel.h"
#import "SHLightView.h"

@interface SHLightViewController : SHParentViewController<UIScrollViewDelegate, GCDAsyncSocketDelegate>
{
    UIScrollView *lightScrollView;
    UIView *selectedView;
    NSMutableArray *selectedBlocks;
}

@property (nonatomic, strong)NSArray *lights;
@property (nonatomic, strong)NSMutableArray *lightViews;
@property (nonatomic)dispatch_queue_t socketQueue;
@property (nonatomic, strong)NSThread *lightQueryThread;
@property (nonatomic)int currentPage;

@end
