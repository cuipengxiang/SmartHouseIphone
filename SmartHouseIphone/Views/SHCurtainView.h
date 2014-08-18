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

@property (nonatomic, strong)SHCurtainModel *model;

- (id)initWithFrame:(CGRect)frame andModel:(SHCurtainModel *)model;
@property (strong, nonatomic) AppDelegate *appDelegate;

@end
