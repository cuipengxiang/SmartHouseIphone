//
//  SHModeViewController.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHModeViewController.h"
#import "SHSettingsViewController.h"
#import "SHCurtainModel.h"
#import "SHAirConditioningModel.h"
#import "SHLightModel.h"
#import "SHMusicModel.h"
#import "SHRoomModel.h"

#define Button_Base_Tag 1000

@interface SHModeViewController ()

@end

@implementation SHModeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.socketQueue = dispatch_queue_create("socketQueueMode", NULL);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    
    Lights = [[self.appDelegate.models objectAtIndex:0] lights];
    Curtains = [[self.appDelegate.models objectAtIndex:0] curtains];
    AirConditionings = [[self.appDelegate.models objectAtIndex:0] airconditionings];
    Musics = [[self.appDelegate.models objectAtIndex:0] musics];
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_setup"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(onSettingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    NSArray *rightButtons = @[self.networkStateButton, settingBarButton];
    [self.navigationItem setRightBarButtonItems:rightButtons];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 10.0, 320.0, self.contentView.frame.size.height - 20.0)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setContentSize:CGSizeMake(320.0, 10 + self.modes.count * 90)];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.contentView addSubview:scrollView];
    
    for (int i = 0; i < self.modes.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(18.0, 10 + 90*i, 284.0, 77.0)];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_mode_%d", i + 1]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_mode_%d_pressed", i + 1]] forState:UIControlStateHighlighted];
        [button setTag:Button_Base_Tag + i];
        [button addTarget:self action:@selector(onModeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
    }
}

- (void)onSettingButtonClicked
{
    SHSettingsViewController *settingController = [[SHSettingsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (void)onModeButtonClicked:(UIButton *)button
{
    int index = button.tag - Button_Base_Tag;
    SHModeModel *model = [self.modes objectAtIndex:index];
    NSArray *cmds = [model.modecmd componentsSeparatedByString:@"|"];
    
    NSMutableArray *commands = [self contentToCommamd:cmds];
    for (int i = 0; i < commands.count; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
            NSError *error;
            GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
            socket.command = [NSString stringWithFormat:@"%@\r\n", [commands objectAtIndex:i]];
            [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
    [self setNetworkState:self.appDelegate.currentNetworkState];
    
    if (self.modeQueryThread) {
        self.modeQueryThread = nil;
    }
    self.modeQueryThread = [[NSThread alloc] initWithTarget:self selector:@selector(queryMode:) object:nil];
    if (![self.modeQueryThread isExecuting]) {
        [self.modeQueryThread start];
    }
}

- (void)queryMode:(NSThread *)thread
{
    while ([[NSThread currentThread] isCancelled] == NO) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
            NSError *error;
            GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
            [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:1.0 error:&error];
        });
        [NSThread sleepForTimeInterval:3];
    }
    [NSThread exit];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.modeQueryThread cancel];
}

#pragma mark Socket

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    if (sock.command) {
        [sock writeData:[sock.command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3.0 tag:0];
    } else {
        [sock disconnect];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if (sock.command) {
        [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:1 tag:0];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err) {
        [self setNetworkState:NO];
    } else {
        [self setNetworkState:YES];
    }
    sock = nil;
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    [sock disconnect];
    return 0.0;
}

- (NSMutableArray *)contentToCommamd:(NSArray *)contents
{
    NSMutableArray *commands = [[NSMutableArray alloc] init];
    for (int i = 0; i < contents.count; i++) {
        NSString *content = [contents objectAtIndex:i];
        NSString *modelID = [[content componentsSeparatedByString:@","] objectAtIndex:0];
        if ([[content substringToIndex:1] isEqualToString:@"L"]) {
            for (int j = 0; j < Lights.count; j++) {
                SHLightModel *light = [Lights objectAtIndex:j];
                if ([[light deviceid] isEqualToString:modelID]) {
                    int brightness = [[[content componentsSeparatedByString:@","] objectAtIndex:1] integerValue];
                    NSString *command = [NSString stringWithFormat:@"*channellevel %@,%d,%@,%@", light.channel, brightness, light.area, light.fade];
                    [commands addObject:command];
                }
            }
        } else if ([[content substringToIndex:1] isEqualToString:@"C"]) {
            for (int j = 0; j < Curtains.count; j++) {
                SHCurtainModel *curtain = [Curtains objectAtIndex:j];
                if ([[curtain deviceid] isEqualToString:modelID]) {
                    int open = [[[content componentsSeparatedByString:@","] objectAtIndex:1] integerValue];
                    NSString *command = [[NSString alloc] init];
                    if (open == 0) {
                        command = curtain.closecmd;
                    } else if (open == 1) {
                        command = curtain.opencmd;
                    }
                    [commands addObject:command];
                }
            }
        } else if ([[content substringToIndex:1] isEqualToString:@"A"]) {
            for (int j = 0; j < AirConditionings.count; j++) {
                SHAirConditioningModel *airconditioning = [AirConditionings objectAtIndex:j];
                if ([[airconditioning deviceid] isEqualToString:modelID]) {
                    int isOnNow = [[[content componentsSeparatedByString:@","] objectAtIndex:1] integerValue];
                    int speed = [[[content componentsSeparatedByString:@","] objectAtIndex:2] integerValue];
                    int mode = [[[content componentsSeparatedByString:@","] objectAtIndex:3] integerValue];
                    int temp = [[[content componentsSeparatedByString:@","] objectAtIndex:4] integerValue];
                    NSString *command = [NSString stringWithFormat:@"*aircset %@,%@,%d,%d,%d,%d,%d", airconditioning.mainaddr, airconditioning.secondaryaddr, isOnNow, 0, speed, mode, temp];
                    [commands addObject:command];
                }
            }
        }
    }
    return commands;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
