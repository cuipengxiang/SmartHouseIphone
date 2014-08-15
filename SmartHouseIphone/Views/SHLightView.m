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
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64.5, 20.0, 191.0, 37.0)];
    [titleLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]]];
    [titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:self.model.name];
    [self addSubview:titleLabel];
    
    lightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(65.0, 70.0, 190.0, 199.0)];
    NSString *localDegree = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"light_state%@%@", self.model.area, self.model.channel]];
    if ((localDegree)&&([localDegree integerValue] > 0)) {
        [lightImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"lightball_lv%@", localDegree]]];
    }
    [lightImageView setImage:[UIImage imageNamed:@"lightball_off"]];
    [self addSubview:lightImageView];
    
    on_off = [[UIButton alloc] initWithFrame:CGRectMake(119.0, 290.0, 82.0, 28.0)];
    [on_off setImage:[UIImage imageNamed:@"switch_btn_off"] forState:UIControlStateNormal];
    [on_off setImage:[UIImage imageNamed:@"switch_btn_on"] forState:UIControlStateSelected];
    [on_off addTarget:self action:@selector(switchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:on_off];
    
    degreeView = [[UIView alloc] initWithFrame:CGRectMake(56.5, 340.0, 207.0, 28.0)];
    [degreeView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"light_degree_bg"]]];
    [self addSubview:degreeView];
    
    lower = [[UIButton alloc] initWithFrame:CGRectMake(1.0, 2.0, 30.0, 24.0)];
    [lower setBackgroundImage:[UIImage imageNamed:@"light_low"] forState:UIControlStateNormal];
    [lower setBackgroundImage:[UIImage imageNamed:@"light_low_pressed"] forState:UIControlStateHighlighted];
    [degreeView addSubview:lower];
    
    higher = [[UIButton alloc] initWithFrame:CGRectMake(176.0, 2.0, 30.0, 24.0)];
    [higher setBackgroundImage:[UIImage imageNamed:@"light_high"] forState:UIControlStateNormal];
    [higher setBackgroundImage:[UIImage imageNamed:@"light_high_pressed"] forState:UIControlStateHighlighted];
    [degreeView addSubview:higher];
}

- (void)switchButtonClicked:(UIButton *)sender
{
    
}

@end
