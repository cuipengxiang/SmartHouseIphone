//
//  SHMusicViewNew.h
//  SmartHouseIphone
//
//  Created by Roc on 15/3/3.
//  Copyright (c) 2015年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMusicModel.h"
#import "AppDelegate.h"
#import "KVNProgress.h"

@interface SHMusicViewNew : UIView
{
    UILabel *titleLabel;
    UIButton *on_off;
    UIButton *startButton;
    UIButton *pauseButton;
    UIButton *volHigherButton;
    UIButton *volLowerButton;
    UIButton *preButton;
    UIButton *nextButton;
    
    NSMutableArray *sourceButtons;
}

@property (nonatomic, strong)SHMusicModel *model;

- (id)initWithFrame:(CGRect)frame andModel:(SHMusicModel *)model;
@property (strong, nonatomic) AppDelegate *appDelegate;

@end
