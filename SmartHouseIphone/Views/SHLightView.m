//
//  SHLightView.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-14.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHLightView.h"

@implementation SHLightView

- (id)initWithFrame:(CGRect)frame andModel:(SHLightModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
    }
    return self;
}

- (void)layoutSubviews
{
    
}

@end
