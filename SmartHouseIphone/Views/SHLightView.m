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
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
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
    [lightImageView setImage:[UIImage imageNamed:@"lightball_off"]];
    [self addSubview:lightImageView];
    
    on_off = [[UIButton alloc] initWithFrame:CGRectMake(119.0, 290.0, 82.0, 28.0)];
    [on_off setImage:[UIImage imageNamed:@"switch_btn_off"] forState:UIControlStateNormal];
    [on_off setTag:0];
    [on_off addTarget:self action:@selector(switchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:on_off];
    
    degreeView = [[UIView alloc] initWithFrame:CGRectMake(56.5, 340.0, 207.0, 28.0)];
    [degreeView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"light_degree_bg"]]];
    [self addSubview:degreeView];
    
    lower = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 2.0, 30.0, 24.0)];
    [lower setBackgroundImage:[UIImage imageNamed:@"light_low"] forState:UIControlStateNormal];
    [lower setBackgroundImage:[UIImage imageNamed:@"light_low_pressed"] forState:UIControlStateHighlighted];
    [lower addTarget:self action:@selector(lowerButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [degreeView addSubview:lower];
    
    higher = [[UIButton alloc] initWithFrame:CGRectMake(177.0, 2.0, 30.0, 24.0)];
    [higher setBackgroundImage:[UIImage imageNamed:@"light_high"] forState:UIControlStateNormal];
    [higher setBackgroundImage:[UIImage imageNamed:@"light_high_pressed"] forState:UIControlStateHighlighted];
    [higher addTarget:self action:@selector(higherButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [degreeView addSubview:higher];
    
    degreeBlocks = [[NSMutableArray alloc] init];
    for (int i = 0; i < 10; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(30.9 + i*14.8, 2.0, 12.0, 24.0)];
        [imageView setImage:[UIImage imageNamed:@"light_degree_empty"]];
        [degreeBlocks addObject:imageView];
        [degreeView addSubview:imageView];
    }
    currentDegree = 0;
    
    NSString *localDegree = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"light_state%@%@", self.model.area, self.model.channel]];
    if ((localDegree)&&([localDegree integerValue] > 0)) {
        currentDegree = [localDegree integerValue];
        [on_off setImage:[UIImage imageNamed:@"switch_btn_on"] forState:UIControlStateNormal];
        [on_off setTag:1];
        if (currentDegree < 10) {
            [lightImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"lightball_lv0%@", localDegree]]];
        } else {
            [lightImageView setImage:[UIImage imageNamed:@"lightball_lv10"]];
        }
        
        for (int i = 0; i < 10; i++) {
            if (i < [localDegree integerValue]) {
                [[degreeBlocks objectAtIndex:i] setImage:[UIImage imageNamed:@"light_degree_normal"]];
            } else {
                [[degreeBlocks objectAtIndex:i] setImage:[UIImage imageNamed:@"light_degree_empty"]];
            }
        }
    }
}

- (void)switchButtonClicked:(UIButton *)sender
{
    if (sender.tag == 1) {
        [self setLightDegree:0];
    } else {
        [self setLightDegree:10];
    }
}

- (void)higherButtonClicked
{
    if (currentDegree < 10) {
        [self setLightDegree:currentDegree + 1];
    }
}

- (void)lowerButtonClicked
{
    if (currentDegree > 0) {
        [self setLightDegree:currentDegree - 1];
    }
}

- (void)setLightDegree:(int)degree
{
    currentDegree = degree;
    if (degree > 0) {
        if (degree < 10) {
            [lightImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"lightball_lv0%d", degree]]];
        } else {
            [lightImageView setImage:[UIImage imageNamed:@"lightball_lv10"]];
        }
        [on_off setTag:1];
        [on_off setImage:[UIImage imageNamed:@"switch_btn_on"] forState:UIControlStateNormal];
    } else {
        [lightImageView setImage:[UIImage imageNamed:@"lightball_off"]];
        [on_off setTag:0];
        [on_off setImage:[UIImage imageNamed:@"switch_btn_off"] forState:UIControlStateNormal];
    }
    for (int i = 0; i < 10; i++) {
        if (i < degree) {
            [[degreeBlocks objectAtIndex:i] setImage:[UIImage imageNamed:@"light_degree_normal"]];
        } else {
            [[degreeBlocks objectAtIndex:i] setImage:[UIImage imageNamed:@"light_degree_empty"]];
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d", degree] forKey:[NSString stringWithFormat:@"light_state%@%@", self.model.area, self.model.channel]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self.appDelegate delegateQueue:self.appDelegate.socketQueue];
        NSString *command = [NSString stringWithFormat:@"*channellevel %@,%d,%@,%@", self.model.channel, currentDegree*10, self.model.area, self.model.fade];
        socket.command = [NSString stringWithFormat:@"%@\r\n", command];
        [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
    });
}

@end
