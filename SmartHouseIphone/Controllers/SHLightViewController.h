//
//  SHLightViewController.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"
#import "SHLightModel.h"

@interface SHLightViewController : SHParentViewController<UIScrollViewDelegate>
{
    UIScrollView *scrollView;
}

@property (nonatomic, strong)NSArray *lights;
@property (nonatomic, strong)NSMutableArray *lightViews;

@end
