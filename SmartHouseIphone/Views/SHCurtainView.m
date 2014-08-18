//
//  SHCurtainView.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-15.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHCurtainView.h"

@implementation SHCurtainView

- (id)initWithFrame:(CGRect)frame andModel:(SHCurtainModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

-(void)layoutSubviews
{
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64.5, 20.0, 191.0, 37.0)];
    [titleLabel setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"title_bg"]]];
    [titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:self.model.name];
    [self addSubview:titleLabel];
    
    curtainImageView = [[UIImageView alloc] initWithFrame:CGRectMake(26.0, 120.0, 268.0, 140.0)];
    [curtainImageView setImage:[UIImage imageNamed:@"curtain_open"]];
    [self addSubview:curtainImageView];
    
    openButton = [[UIButton alloc] initWithFrame:CGRectMake(51.5, 300.0, 59.0, 39.0)];
    [openButton setBackgroundImage:[UIImage imageNamed:@"btn_curtain_bg"] forState:UIControlStateNormal];
    [openButton setBackgroundImage:[UIImage imageNamed:@"btn_curtain_bg_pressed"] forState:UIControlStateHighlighted];
    [openButton setTitle:@"开" forState:UIControlStateNormal];
    [openButton setTitleColor:[UIColor colorWithRed:0.208 green:0.165 blue:0.000 alpha:1] forState:UIControlStateNormal];
    [openButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [openButton.titleLabel setFont:[UIFont systemFontOfSize:22.0]];
    [openButton addTarget:self action:@selector(openButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:openButton];
    
    closeButton = [[UIButton alloc] initWithFrame:CGRectMake(131.5, 300.0, 59.0, 39.0)];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_curtain_bg"] forState:UIControlStateNormal];
    [closeButton setBackgroundImage:[UIImage imageNamed:@"btn_curtain_bg_pressed"] forState:UIControlStateHighlighted];
    [closeButton setTitle:@"关" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor colorWithRed:0.208 green:0.165 blue:0.000 alpha:1] forState:UIControlStateNormal];
    [closeButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [closeButton.titleLabel setFont:[UIFont systemFontOfSize:22.0]];
    [closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    stopButton = [[UIButton alloc] initWithFrame:CGRectMake(210.5, 300.0, 59.0, 39.0)];
    [stopButton setBackgroundImage:[UIImage imageNamed:@"btn_curtain_bg"] forState:UIControlStateNormal];
    [stopButton setBackgroundImage:[UIImage imageNamed:@"btn_curtain_bg_pressed"] forState:UIControlStateHighlighted];
    [stopButton setTitle:@"停" forState:UIControlStateNormal];
    [stopButton setTitleColor:[UIColor colorWithRed:0.208 green:0.165 blue:0.000 alpha:1] forState:UIControlStateNormal];
    [stopButton.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [stopButton.titleLabel setFont:[UIFont systemFontOfSize:22.0]];
    [stopButton addTarget:self action:@selector(stopButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:stopButton];
    
    NSString *curtainState = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"curtain_state%@%@", self.model.area, self.model.channel]];
    if ([curtainState integerValue] == 0) {
        [curtainImageView setImage:[UIImage imageNamed:@"curtain_closed"]];
    }
}

- (void)openButtonClicked
{
    [curtainImageView setImage:[UIImage imageNamed:@"curtain_open"]];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:[NSString stringWithFormat:@"curtain_state%@%@", self.model.area, self.model.channel]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self.appDelegate delegateQueue:self.appDelegate.socketQueue];
        socket.command = [NSString stringWithFormat:@"%@\r\n", self.model.opencmd];
        [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
    });
}

- (void)closeButtonClicked
{
    [curtainImageView setImage:[UIImage imageNamed:@"curtain_closed"]];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:[NSString stringWithFormat:@"curtain_state%@%@", self.model.area, self.model.channel]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self.appDelegate delegateQueue:self.appDelegate.socketQueue];
        socket.command = [NSString stringWithFormat:@"%@\r\n", self.model.closecmd];
        [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
    });
}

- (void)stopButtonClicked
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self.appDelegate delegateQueue:self.appDelegate.socketQueue];
        socket.command = [NSString stringWithFormat:@"%@\r\n", self.model.stopcmd];
        [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
    });
}

@end
