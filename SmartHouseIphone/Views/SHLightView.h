//
//  SHLightView.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-14.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHLightModel.h"
#import "AppDelegate.h"

@interface SHLightView : UIView
{
    UILabel *titleLabel;
    UIImageView *lightImageView;
    UIButton *on_off;
    UIButton *higher;
    UIButton *lower;
    UIView *degreeView;
    NSMutableArray *degreeBlocks;
    int currentDegree;
}

@property (nonatomic, strong)SHLightModel *model;
@property (strong, nonatomic) AppDelegate *appDelegate;

- (id)initWithFrame:(CGRect)frame andModel:(SHLightModel *)model;
- (void)setLightDegree:(int)degree;
- (void)setLightDegreeWithoutSendingCommond:(int)degree;

@end
