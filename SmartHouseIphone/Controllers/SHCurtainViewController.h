//
//  SHCurtainViewController.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"
#import "SHCurtainModel.h"

@interface SHCurtainViewController : SHParentViewController
{
    UIScrollView *scrollView;
}

@property (nonatomic, strong)NSArray *curtains;
@property (nonatomic, strong)NSMutableArray *curtainViews;

@end
