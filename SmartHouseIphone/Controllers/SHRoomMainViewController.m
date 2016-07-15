//
//  SHRoomMainViewController.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHRoomMainViewController.h"
#import "SHModeViewController.h"
#import "SHLightViewController.h"
#import "SHCurtainViewController.h"
#import "SHAirViewController.h"
#import "SHMusicViewController.h"
#import "SHSettingsViewController.h"

@interface SHRoomMainViewController ()

@end

@implementation SHRoomMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.socketQueue = dispatch_queue_create("socketQueueRoomMain", NULL);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_setup"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(onSettingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    NSArray *rightButtons = @[self.networkStateButton, settingBarButton];
    [self.navigationItem setRightBarButtonItems:rightButtons];
    
    self.networkButton = [[UIButton alloc] initWithFrame:CGRectMake(75.0, 25.0, 170.0, 42.0)];
    [self.networkButton addTarget:self action:@selector(onNetworkClick) forControlEvents:UIControlEventTouchUpInside];
    if ([self.appDelegate.host isEqualToString:self.appDelegate.host1]) {
        [self.networkButton setImage:[UIImage imageNamed:@"btn_switch_big1"] forState:UIControlStateNormal];
    } else if ([self.appDelegate.host isEqualToString:self.appDelegate.host2]){
        [self.networkButton setImage:[UIImage imageNamed:@"btn_switch_big2"] forState:UIControlStateNormal];
    }
    //[self.contentView addSubview:self.networkButton];
    
    NSMutableArray *buttons = [[NSMutableArray alloc] init];
    if ((self.model.modes)&&(self.model.modes.count > 0)) {
        UIButton *modeButton = [[UIButton alloc] init];
        [modeButton setBackgroundImage:[UIImage imageNamed:@"btn_mode"] forState:UIControlStateNormal];
        [modeButton addTarget:self action:@selector(onModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:modeButton];
    }
    if ((self.model.lights)&&(self.model.lights.count > 0)) {
        UIButton *lightButton = [[UIButton alloc] init];
        [lightButton setBackgroundImage:[UIImage imageNamed:@"btn_light"] forState:UIControlStateNormal];
        [lightButton addTarget:self action:@selector(onLightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:lightButton];
    }
    if ((self.model.curtains)&&(self.model.curtains.count > 0)) {
        UIButton *curtainButton = [[UIButton alloc] init];
        [curtainButton setBackgroundImage:[UIImage imageNamed:@"btn_curtain"] forState:UIControlStateNormal];
        [curtainButton addTarget:self action:@selector(onCurtainButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:curtainButton];
    }
    if ((self.model.airconditionings)&&(self.model.airconditionings.count > 0)) {
        UIButton *airButton = [[UIButton alloc] init];
        [airButton setBackgroundImage:[UIImage imageNamed:@"btn_air"] forState:UIControlStateNormal];
        [airButton addTarget:self action:@selector(onAirButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:airButton];
    }
    if ((self.model.musics)&&(self.model.musics.count > 0)) {
        UIButton *musicButton = [[UIButton alloc] init];
        [musicButton setBackgroundImage:[UIImage imageNamed:@"btn_music"] forState:UIControlStateNormal];
        [musicButton addTarget:self action:@selector(onMusicButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:musicButton];
    }

    for (int i = 0; i < buttons.count; i++) {
        UIButton *button = [buttons objectAtIndex:i];
        [button setFrame:CGRectMake(60.0 + i%2*114.0, 90.0 + i/2*110.0, 86.0, 89.0)];
        [self.contentView addSubview:button];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
    [self setNetworkState:self.appDelegate.currentNetworkState];
    
    if ([self.appDelegate.host isEqualToString:self.appDelegate.host1]) {
        [self.networkButton setImage:[UIImage imageNamed:@"btn_switch_big1"] forState:UIControlStateNormal];
        [self.networkButton setTitle:@"btn_switch_big1" forState:UIControlStateNormal];
    } else if ([self.appDelegate.host isEqualToString:self.appDelegate.host2]){
        [self.networkButton setImage:[UIImage imageNamed:@"btn_switch_big2"] forState:UIControlStateNormal];
        [self.networkButton setTitle:@"btn_switch_big2" forState:UIControlStateNormal];
    }
    
    if (self.roomMainQueryThread) {
        self.roomMainQueryThread = nil;
    }
    self.roomMainQueryThread = [[NSThread alloc] initWithTarget:self selector:@selector(queryMode:) object:nil];
    if (![self.roomMainQueryThread isExecuting]) {
        [self.roomMainQueryThread start];
    }
}

- (void)onNetworkClick
{
    if ([self.appDelegate.host isEqualToString:self.appDelegate.host1]) {
        self.appDelegate.host = self.appDelegate.host2;
        [self.networkButton setImage:[UIImage imageNamed:@"btn_switch_big2"] forState:UIControlStateNormal];
    } else if ([self.appDelegate.host isEqualToString:self.appDelegate.host2]){
        self.appDelegate.host = self.appDelegate.host1;
        [self.networkButton setImage:[UIImage imageNamed:@"btn_switch_big1"] forState:UIControlStateNormal];
    }
    [[NSUserDefaults standardUserDefaults] setObject:self.appDelegate.host forKey:@"host"];
}

- (void)onModeButtonClicked
{
    SHModeViewController *modeController = [[SHModeViewController alloc] initWithNibName:nil bundle:nil];
    modeController.modes = self.model.modes;
    modeController.roomModel = self.model;
    [modeController setNavigationTitle:@"场景"];
    [self.navigationController pushViewController:modeController animated:YES];
}

- (void)onLightButtonClicked
{
    SHLightViewController *lightController = [[SHLightViewController alloc] initWithNibName:nil bundle:nil];
    lightController.lights = self.model.lights;
    [lightController setNavigationTitle:@"灯光"];
    [self.navigationController pushViewController:lightController animated:YES];
}

- (void)onCurtainButtonClicked
{
    SHCurtainViewController *curtainController = [[SHCurtainViewController alloc] initWithNibName:nil bundle:nil];
    curtainController.curtains = self.model.curtains;
    [curtainController setNavigationTitle:@"窗帘"];
    [self.navigationController pushViewController:curtainController animated:YES];
}

- (void)onAirButtonClicked
{
    SHAirViewController *airController = [[SHAirViewController alloc] initWithNibName:nil bundle:nil];
    airController.airs = self.model.airconditionings;
    [airController setNavigationTitle:@"空调"];
    [self.navigationController pushViewController:airController animated:YES];
}

- (void)onMusicButtonClicked
{
    SHMusicViewController *musicController = [[SHMusicViewController alloc] initWithNibName:nil bundle:nil];
    musicController.musics = self.model.musics;
    [musicController setNavigationTitle:@"音乐"];
    [self.navigationController pushViewController:musicController animated:YES];
}

- (void)onSettingButtonClicked
{
    SHSettingsViewController *settingController = [[SHSettingsViewController alloc] initWithNibName:nil bundle:nil];
    [settingController setNavigationTitle:@"设置"];
    [self.navigationController pushViewController:settingController animated:YES];
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
    [self.roomMainQueryThread cancel];
}

#pragma mark Socket

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    //[sock writeData:[sock.command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3.0 tag:0];
    [sock disconnect];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //[sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err) {
        [self setNetworkState:NO];
        [self.appDelegate connectFail];
    } else {
        [self setNetworkState:YES];
        [self.appDelegate connectSucc];
    }
    sock = nil;
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    [sock disconnect];
    return 0.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
