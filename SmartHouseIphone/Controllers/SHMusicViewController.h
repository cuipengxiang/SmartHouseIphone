//
//  SHMusicViewController.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"


@interface SHMusicViewController : SHParentViewController<UIScrollViewDelegate, GCDAsyncSocketDelegate>
{
    UIScrollView *musicScrollView;
    UIView *selectedView;
    NSMutableArray *selectedBlocks;
}

@property (nonatomic, strong)NSArray *musics;
@property (nonatomic, strong)NSMutableArray *musicViews;
@property (nonatomic)dispatch_queue_t socketQueue;
@property(nonatomic, strong)NSThread *musicQueryThread;

@end
