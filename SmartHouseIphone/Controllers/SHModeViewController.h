//
//  SHModeViewController.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"
#import "SHModeModel.h"

@interface SHModeViewController : SHParentViewController<GCDAsyncSocketDelegate>
{
    NSArray *Lights;
    NSArray *Curtains;
    NSArray *AirConditionings;
    NSArray *Musics;
}

@property (nonatomic, strong)NSArray *modes;
@property (nonatomic)dispatch_queue_t socketQueue;
@property(nonatomic, strong)NSThread *modeQueryThread;

@end
