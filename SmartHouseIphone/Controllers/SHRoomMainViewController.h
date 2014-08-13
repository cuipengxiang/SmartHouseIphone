//
//  SHRoomMainViewController.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"
#import "SHRoomModel.h"

@interface SHRoomMainViewController : SHParentViewController

@property (nonatomic, strong)SHRoomModel *model;
@property (nonatomic, strong)UIButton *networkButton;

@end
