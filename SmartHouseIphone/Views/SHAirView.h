//
//  SHAirView.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-15.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHAirConditioningModel.h"

@interface SHAirView : UIView
{
    Boolean skip;
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

- (id)initWithFrame:(CGRect)frame andModel:(SHAirConditioningModel *)model;

@end
