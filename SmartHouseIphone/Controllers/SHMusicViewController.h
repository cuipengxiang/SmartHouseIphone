//
//  SHMusicViewController.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"


@interface SHMusicViewController : SHParentViewController
{
    UIScrollView *musicScrollView;
    UIView *selectedView;
    NSMutableArray *selectedBlocks;
}

@property (nonatomic, strong)NSArray *musics;
@property (nonatomic, strong)NSMutableArray *musicViews;

@end
