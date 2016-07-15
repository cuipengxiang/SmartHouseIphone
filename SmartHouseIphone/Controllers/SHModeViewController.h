//
//  SHModeViewController.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"
#import "SHModeModel.h"
#import "SHRoomModel.h"

@interface SHModeViewController : SHParentViewController<GCDAsyncSocketDelegate, UIAlertViewDelegate>
{
    NSArray *Lights;
    NSArray *Curtains;
    NSArray *AirConditionings;
    NSArray *Musics;
    
    UIButton *userDefined;
}

@property (nonatomic, strong)SHRoomModel *roomModel;
@property (nonatomic, strong)NSArray *modes;
@property (nonatomic)dispatch_queue_t socketQueue;
@property (nonatomic, strong)NSThread *modeQueryThread;
@property (nonatomic, strong)NSThread *myModeQueryThread;
@property (nonatomic, strong)NSThread *myModeSetThread;
@property (nonatomic, strong)NSMutableArray *defineModeCmd;
@property (nonatomic, strong)NSMutableArray *queryCmds;

@end
