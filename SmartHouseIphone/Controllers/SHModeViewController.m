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
    
    [self setNavigationTitle:@"场景模式"];
    
    [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    
    Lights = [self.roomModel lights];
    Curtains = [self.roomModel curtains];
    AirConditionings = [self.roomModel airconditionings];
    Musics = [self.roomModel musics];
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_setup"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(onSettingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    NSArray *rightButtons = @[self.networkStateButton, settingBarButton];
    [self.navigationItem setRightBarButtonItems:rightButtons];
    
    [self setupModeButtons];
    /*
    for (int i = 0; i < self.modes.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(18.0, 10 + 90*i, 284.0, 77.0)];
        //[button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_mode_%d", i + 1]] forState:UIControlStateNormal];
        //[button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_mode_%d_pressed", i + 1]] forState:UIControlStateHighlighted];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_mode_bg"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"btn_mode_bg_pressed"] forState:UIControlStateHighlighted];
        [button setTag:Button_Base_Tag + i];
        [button setTitle:[[self.modes objectAtIndex:i] name] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithRed:0.396 green:0.373 blue:0.251 alpha:1] forState:UIControlStateNormal];
        [button setTitle:[[self.modes objectAtIndex:i] name] forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:30.0]];
        [button addTarget:self action:@selector(onModeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:button];
    }
    */
    userDefined = [[UIButton alloc] initWithFrame:CGRectMake(18.0, 10 + 90*self.modes.count, 284.0, 77.0)];
    [userDefined setBackgroundImage:[UIImage imageNamed:@"btn_mode_bg"] forState:UIControlStateNormal];
    [userDefined setBackgroundImage:[UIImage imageNamed:@"btn_mode_bg_pressed"] forState:UIControlStateHighlighted];
    [userDefined setTag:Button_Base_Tag + self.modes.count];
    [userDefined setTitle:@"自定义模式" forState:UIControlStateNormal];
    [userDefined setTitleColor:[UIColor colorWithRed:0.396 green:0.373 blue:0.251 alpha:1] forState:UIControlStateNormal];
    [userDefined setTitle:@"自定义模式" forState:UIControlStateHighlighted];
    [userDefined setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [userDefined.titleLabel setFont:[UIFont boldSystemFontOfSize:30.0]];
    [userDefined addTarget:self action:@selector(onUserDefinedModeClicked) forControlEvents:UIControlEventTouchUpInside];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onUserDefinedModeLongPressed:)];
    longPress.minimumPressDuration = 1.5; //定义按的时间
    [userDefined addGestureRecognizer:longPress];
    //[scrollView addSubview:userDefined];
}

- (void)setupModeButtons
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 10.0, self.contentView.frame.size.width, self.contentView.frame.size.height - 20.0)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setContentSize:CGSizeMake(320.0, 10 + self.modes.count * 90)];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.contentView addSubview:scrollView];
    
    for (int i = 0; i < self.modes.count; i++) {
        NSString *modeName = [[self.modes objectAtIndex:i] name];
        UIButton *modeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        modeButton.frame = CGRectMake((self.contentView.frame.size.width - 250.0)/2 + i%2*151.0, 40.0 + i/2*100.0, 99.0, 105.0);
        [modeButton setTitle:modeName forState:UIControlStateNormal];
        [modeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [modeButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"mode_btn_%d", i%6]] forState:UIControlStateNormal];
        [modeButton setTag:i + Button_Base_Tag];
        [modeButton addTarget:self action:@selector(onModeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView addSubview:modeButton];
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
    
//    NSMutableArray *commands = [self contentToCommamd:cmds];
//    for (int i = 0; i < commands.count; i++) {
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
//            NSError *error;
//            GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
//            socket.command = [NSString stringWithFormat:@"%@\r\n", [commands objectAtIndex:i]];
//            [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
//        });
//    }
    
    for (int i = 0; i < [cmds count]; i++) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            NSError *error;
            GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
            socket.command = [NSString stringWithFormat:@"%@\r\n", [cmds objectAtIndex:i]];
            [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
        });
    }
}

- (void)onUserDefinedModeClicked
{
    NSMutableArray *modeDefine = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"mode_user_define%@", self.roomModel.roomid]];
    if (modeDefine) {
        if (self.myModeSetThread) {
            self.myModeSetThread = nil;
        }
        self.myModeSetThread = [[NSThread alloc] initWithTarget:self selector:@selector(setUserDefinedMode:) object:nil];
        if (![self.myModeSetThread isExecuting]) {
            [self.myModeSetThread start];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"自定模式提醒" message:@"您尚未录入自定模式，是否保存家电当前状态为自定模式？(长按此按钮将再次录入自定义模式)" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self saveUserDefinedMode];
    }
}

- (void)onUserDefinedModeLongPressed:(UILongPressGestureRecognizer *)gesture
{
    switch (gesture.state)
    {
        case UIGestureRecognizerStateEnded:
            
            break;
        case UIGestureRecognizerStateCancelled:
            
            break;
        case UIGestureRecognizerStateFailed:
            
            break;
        case UIGestureRecognizerStateBegan:
            [self saveUserDefinedMode];
            break;
        case UIGestureRecognizerStateChanged:
            
            break;
        default:
            break;
    }
}

- (void)saveUserDefinedMode
{
    NSLog(@"save");
    self.defineModeCmd = [[NSMutableArray alloc] init];
    self.queryCmds = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.roomModel.lights.count; i++) {
        SHLightModel *lightmodel = [self.roomModel.lights objectAtIndex:i];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:lightmodel forKey:@"data"];
        [dictionary setObject:[NSString stringWithFormat:@"%d", 1] forKey:@"type"];
        [dictionary setObject:[NSString stringWithFormat:@"*requestchannellevel %@,%@\r\n", [lightmodel channel], [lightmodel area]] forKey:@"command"];
        [self.queryCmds addObject:dictionary];
    }
    for (int i = 0; i < self.roomModel.curtains.count; i++) {
        SHCurtainModel *curtainmodel = [self.roomModel.curtains objectAtIndex:i];
        NSString *stateString = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"curtain_state%@%@", curtainmodel.area, curtainmodel.channel]];
        if (stateString) {
            int state = [stateString integerValue];
            if (state == 0) {
                [self.defineModeCmd addObject:curtainmodel.closecmd];
            } else {
                [self.defineModeCmd addObject:curtainmodel.opencmd];
            }
        } else {
            [self.defineModeCmd addObject:curtainmodel.closecmd];
        }
    }
    for (int i = 0; i < self.roomModel.airconditionings.count; i++) {
        SHAirConditioningModel *airmodel = [self.roomModel.airconditionings objectAtIndex:i];
        NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
        [dictionary setObject:airmodel forKey:@"data"];
        [dictionary setObject:[NSString stringWithFormat:@"%d", 2] forKey:@"type"];
        [dictionary setObject:[NSString stringWithFormat:@"*aircreply %@,%@\r\n", [airmodel mainaddr], [airmodel secondaryaddr]] forKey:@"command"];
        [self.queryCmds addObject:dictionary];
    }
    NSLog(@"queryCmds:%@", self.queryCmds);
    if (self.myModeQueryThread) {
        self.myModeQueryThread = nil;
    }
    self.myModeQueryThread = [[NSThread alloc] initWithTarget:self selector:@selector(queryUserDefinedMode:) object:nil];
    if (![self.myModeQueryThread isExecuting]) {
        [self.myModeQueryThread start];
    }
}

- (void)queryUserDefinedMode:(NSThread *)thread
{
    int i = 0;
    NSLog(@"i = 0");
    while ([self.myModeQueryThread isCancelled] == NO) {
        NSMutableDictionary *dictionary = [self.queryCmds objectAtIndex:i];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
            NSError *error;
            GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
            socket.command = [dictionary objectForKey:@"command"];
            socket.type = [[dictionary objectForKey:@"type"] integerValue];
            socket.data = [dictionary objectForKey:@"data"];
            [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
        });
        [NSThread sleepForTimeInterval:0.5];
        i = i + 1;
        if (i == self.queryCmds.count) {
            [self.myModeQueryThread cancel];
        }
    }
    [NSThread exit];
}

- (void)setUserDefinedMode:(NSThread *)thread
{
    int i = 0;
    NSMutableArray *modeDefine = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"mode_user_define%@", self.roomModel.roomid]];
    while ([self.myModeSetThread isCancelled] == NO) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
            NSError *error;
            GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
            socket.command = [NSString stringWithFormat:@"%@\r\n", [modeDefine objectAtIndex:i]];
            [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
        });
        [NSThread sleepForTimeInterval:0.5];
        i = i + 1;
        if (i == modeDefine.count) {
            [self.myModeSetThread cancel];
        }
    }
    [NSThread exit];
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
            socket.command = nil;
            [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:1.0 error:&error];
        });
        [NSThread sleepForTimeInterval:3];
    }
    [NSThread exit];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.modeQueryThread cancel];
    if (self.myModeQueryThread) {
        [self.myModeQueryThread cancel];
    }
    if (self.myModeSetThread) {
        [self.myModeSetThread cancel];
    }
}

#pragma mark Socket

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    if (sock.command&&sock.command.length > 0) {
        [sock writeData:[sock.command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3.0 tag:0];
    } else {
        [sock disconnect];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if (sock.command&&sock.command.length > 0) {
        
        // 刚发完清零
        [self.appDelegate connectSucc];
        //
        
        
        [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:1 tag:0];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (sock.skip == -1) {
        sock.skip = 0;
        [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:1 tag:0];
        return;
    }
    NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];
    NSString *msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    
    if (sock.type == 1) {
        NSArray *arrayTemp = [msg arrayOfCaptureComponentsMatchedByRegex:@"T\\[(.+?)\\]"];
        if ((arrayTemp)&&(arrayTemp.count > 0)) {
            int brightness = [[[arrayTemp objectAtIndex:0] objectAtIndex:1] integerValue];
            SHLightModel *lightmodel = (SHLightModel *)sock.data;
            [self.defineModeCmd addObject:[NSString stringWithFormat:@"*channellevel %@,%d,%@,%@", lightmodel.channel, brightness, lightmodel.area, lightmodel.fade]];
        }
    } else if (sock.type == 2) {
        NSArray *arrayState = [msg arrayOfCaptureComponentsMatchedByRegex:@"State\\[(.+?)\\]"];
        NSArray *arrayMode = [msg arrayOfCaptureComponentsMatchedByRegex:@"Mode\\[(.+?)\\]"];
        NSArray *arraySpeed = [msg arrayOfCaptureComponentsMatchedByRegex:@"Size\\[(.+?)\\]"];
        NSArray *arrayTemp = [msg arrayOfCaptureComponentsMatchedByRegex:@"Temp\\[(.+?)\\]"];
        int isOnNow = 0;
        int speed = 0;
        int mode = 0;
        int temp = 20;
        if ((arrayState)&&(arrayState.count > 0)) {
            isOnNow = [[[arrayState objectAtIndex:0] objectAtIndex:1] integerValue];
        }
        if ((arraySpeed)&&(arraySpeed.count > 0)) {
            speed = [[[arraySpeed objectAtIndex:0] objectAtIndex:1] integerValue];
        }
        if ((arrayMode)&&(arrayMode.count > 0)) {
            mode = [[[arrayMode objectAtIndex:0] objectAtIndex:1] integerValue];
        }
        if ((arrayTemp)&&(arrayTemp.count > 0)) {
            temp = [[[arrayTemp objectAtIndex:0] objectAtIndex:1] integerValue];
        }
        SHAirConditioningModel *airmodel = (SHAirConditioningModel *)sock.data;
        [self.defineModeCmd addObject:[NSString stringWithFormat:@"*aircset %@,%@,%d,%d,%d,%d,%d", airmodel.mainaddr, airmodel.secondaryaddr, isOnNow, 0, speed, mode, temp]];
    }
    //NSLog(@"%@", self.defineModeCmd);
    [[NSUserDefaults standardUserDefaults] setObject:self.defineModeCmd forKey:[NSString stringWithFormat:@"mode_user_define%@", self.roomModel.roomid]];
    [sock disconnect];

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
