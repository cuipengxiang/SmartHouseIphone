//
//  SHAirView.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-15.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHAirConditioningModel.h"
#import "AppDelegate.h"

@interface SHAirView : UIView
{
    UILabel *titleLabel;
    UIButton *on_off;
    UIView *modeView;
    UIView *speedView;
    UIView *tempView;
    UIButton *tempSubButton;
    UIButton *tempAddButton;
    UIButton *settingButton;
    UILabel *label_indoor;
    UILabel *temp_mini;
    UILabel *temp_big;
    UILabel *tempsysbol;
}

@property (nonatomic, strong)SHAirConditioningModel *model;
@property (nonatomic)int currentMode;
@property (nonatomic)int currentSpeed;
@property (nonatomic)int currentTemp;
@property (nonatomic)BOOL skip;
@property (strong, nonatomic) AppDelegate *appDelegate;

- (id)initWithFrame:(CGRect)frame andModel:(SHAirConditioningModel *)model;
- (void)setCurrentStatus:(NSMutableString *)status;

@end
