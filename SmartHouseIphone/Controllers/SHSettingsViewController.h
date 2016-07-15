//
//  SHSettingsViewController.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-12.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"
#import "SHPassWordSettingViewController.h"

@interface SHSettingsViewController : SHParentViewController
{
    NSString *netImageName;
}

@property(nonatomic, strong)UIView *settingbox;
@property(nonatomic, strong)UIButton *password;
@property(nonatomic, strong)UIButton *network;
@property(nonatomic, strong)UIButton *backButton;

@end
