//
//  SHMusicView.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-15.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHMusicModel.h"

@interface SHMusicView : UIView
{
    UILabel *titleLabel;
}

@property (nonatomic, strong)SHMusicModel *model;

- (id)initWithFrame:(CGRect)frame andModel:(SHMusicModel *)model;

@end
