//
//  SHMusicView.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-15.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHMusicView.h"
#import "SHMusicButtonModel.h"

@implementation SHMusicView

- (id)initWithFrame:(CGRect)frame andModel:(SHMusicModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        customButtons = [[NSMutableArray alloc] init];
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
    
    startButton = [[UIButton alloc] initWithFrame:CGRectMake(40.0, 100.0, 45.0, 45.0)];
    [startButton setImage:[UIImage imageNamed:@"mbtn_play"] forState:UIControlStateNormal];
    [startButton setImage:[UIImage imageNamed:@"mbtn_play_pressed"] forState:UIControlStateHighlighted];
    [startButton addTarget:self action:@selector(onStartButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:startButton];
    
    pauseButton = [[UIButton alloc] initWithFrame:CGRectMake(105.0, 100.0, 45.0, 45.0)];
    [pauseButton setImage:[UIImage imageNamed:@"mbtn_pause"] forState:UIControlStateNormal];
    [pauseButton setImage:[UIImage imageNamed:@"mbtn_pause_pressed"] forState:UIControlStateHighlighted];
    [pauseButton addTarget:self action:@selector(onPauseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:pauseButton];
    
    volHigherButton = [[UIButton alloc] initWithFrame:CGRectMake(170.0, 100.0, 45.0, 45.0)];
    [volHigherButton setImage:[UIImage imageNamed:@"mbtn_vol_high"] forState:UIControlStateNormal];
    [volHigherButton setImage:[UIImage imageNamed:@"mbtn_vol_high_pressed"] forState:UIControlStateHighlighted];
    [volHigherButton addTarget:self action:@selector(onVolHighButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:volHigherButton];
    
    volLowerButton = [[UIButton alloc] initWithFrame:CGRectMake(235.0, 100.0, 45.0, 45.0)];
    [volLowerButton setImage:[UIImage imageNamed:@"mbtn_vol_low"] forState:UIControlStateNormal];
    [volLowerButton setImage:[UIImage imageNamed:@"mbtn_vol_low_pressed"] forState:UIControlStateHighlighted];
    [volLowerButton addTarget:self action:@selector(onVolLowButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:volLowerButton];
    
    for (int i = 0; i < self.model.buttons.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(35.0 + i%3*92, 170.0 + i/3*45, 67, 25.0)];
        [button setBackgroundImage:[UIImage imageNamed:@"mbtn_bg"] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.278 green:0.271 blue:0.271 alpha:1] forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
        [button setTitle:[[self.model.buttons objectAtIndex:i] name] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onCustomButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [customButtons addObject:button];
        [self addSubview:button];
    }
}

- (void)onStartButtonClicked
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self.appDelegate delegateQueue:self.appDelegate.socketQueue];
        socket.command = [NSString stringWithFormat:@"%@\r\n", @"start"];
        [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
    });
}

- (void)onPauseButtonClicked
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self.appDelegate delegateQueue:self.appDelegate.socketQueue];
        socket.command = [NSString stringWithFormat:@"%@\r\n", @"pause"];
        [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
    });
}

- (void)onVolHighButtonClicked
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self.appDelegate delegateQueue:self.appDelegate.socketQueue];
        socket.command = [NSString stringWithFormat:@"%@\r\n", @"volhigh"];
        [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
    });
}

- (void)onVolLowButtonClicked
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self.appDelegate delegateQueue:self.appDelegate.socketQueue];
        socket.command = [NSString stringWithFormat:@"%@\r\n", @"vollow"];
        [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
    });
}

- (void)onCustomButtonClicked:(UIButton *)button
{
    int index = [customButtons indexOfObject:button];
    NSString *cmd = [[self.model.buttons objectAtIndex:index] command];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self.appDelegate delegateQueue:self.appDelegate.socketQueue];
        socket.command = [NSString stringWithFormat:@"%@\r\n", cmd];
        [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
    });
}

@end
