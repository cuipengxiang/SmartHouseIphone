//
//  SHCurtainView.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-15.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHCurtainModel.h"
#import "AppDelegate.h"

@interface SHCurtainView : UIView
{
    UILabel *titleLabel;
    UIImageView *curtainImageView;
    UIButton *openButton;
    UIButton *closeButton;
    UIButton *stopButton;
}

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (nonatomic, strong)SHCurtainModel *model;

- (id)initWithFrame:(CGRect)frame andModel:(SHCurtainModel *)model;
- (void)setAllButtonStateNormal;

@end
