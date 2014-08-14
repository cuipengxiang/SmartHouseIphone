//
//  SHLightView.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-14.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHLightModel.h"

@interface SHLightView : UIView

@property (nonatomic, strong)SHLightModel *model;

- (id)initWithFrame:(CGRect)frame andModel:(SHLightModel *)model;

@end
