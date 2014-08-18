//
//  SHAirView.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-15.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHAirView.h"

#define Mode_Button_Base_Tag 2000
#define Speed_Button_Base_Tag 2000
#define WIND_DIRECT 0

@implementation SHAirView

- (id)initWithFrame:(CGRect)frame andModel:(SHAirConditioningModel *)model;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        self.skip = NO;
        self.currentMode = -1;
        self.currentSpeed = -1;
        self.currentTemp = -1;
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
    
    on_off = [[UIButton alloc] initWithFrame:CGRectMake(15.0, 70.0, 82.0, 29.0)];
    [on_off setImage:[UIImage imageNamed:@"btn_switch_off_air"] forState:UIControlStateNormal];
    [on_off setTag:0];
    [on_off addTarget:self action:@selector(switchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:on_off];
    
    modeView = [[UIView alloc] initWithFrame:CGRectMake(15.0, 115.0, 290.0, 66.0)];
    [modeView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"panel_air_bg"]]];
    [self addSubview:modeView];
    UIImageView *modeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 8.5, 26.0, 49.0)];
    [modeImageView setImage:[UIImage imageNamed:@"panel_title_mode"]];
    [modeView addSubview:modeImageView];
    for (int i = 0; i < self.model.modes.count; i++) {
        int mode = [self checkMode:[self.model.modes objectAtIndex:i]];
        UIButton *modebutton = [[UIButton alloc] initWithFrame:CGRectMake(42.0 + 49.0 * i, 8.0, 41.0, 50.0)];
        NSString *imageNameNormal = [NSString stringWithFormat:@"btn_air_mode_%d_normal", mode];
        NSString *imageNameSelected = [NSString stringWithFormat:@"btn_air_mode_%d_selected", mode];
        [modebutton setTag:Mode_Button_Base_Tag + mode];
        [modebutton setBackgroundImage:[UIImage imageNamed:imageNameNormal] forState:UIControlStateNormal];
        [modebutton setBackgroundImage:[UIImage imageNamed:imageNameSelected] forState:UIControlStateSelected];
        [modebutton addTarget:self action:@selector(onModeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [modeView addSubview:modebutton];
    }
    
    speedView = [[UIView alloc] initWithFrame:CGRectMake(15.0, 196.0, 290.0, 66.0)];
    [speedView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"panel_air_bg"]]];
    [self addSubview:speedView];
    UIImageView *speedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8.0, 8.5, 26.0, 49.0)];
    [speedImageView setImage:[UIImage imageNamed:@"panel_title_speed"]];
    [speedView addSubview:speedImageView];
    for (int i = 0; i < 3; i++) {
        UIButton *speedbutton = [[UIButton alloc] initWithFrame:CGRectMake(42.0 + 90.0 * i, 8.0, 50.0, 50.0)];
        NSString *imageNameNormal = [NSString stringWithFormat:@"btn_speed_%d_normal", i];
        NSString *imageNameSelected = [NSString stringWithFormat:@"btn_speed_%d_selected", i];
        [speedbutton setTag:Speed_Button_Base_Tag + i];
        [speedbutton setBackgroundImage:[UIImage imageNamed:imageNameNormal] forState:UIControlStateNormal];
        [speedbutton setBackgroundImage:[UIImage imageNamed:imageNameSelected] forState:UIControlStateSelected];
        [speedbutton addTarget:self action:@selector(onSpeedButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [speedView addSubview:speedbutton];
    }
    
    tempView = [[UIView alloc] initWithFrame:CGRectMake(15.0, 277.0, 290.0, 66.0)];
    [tempView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"panel_temp_bg"]]];
    [self addSubview:tempView];
    tempSubButton = [[UIButton alloc] initWithFrame:CGRectMake(2.0, 1.5, 66.0, 63.0)];
    [tempSubButton setBackgroundImage:[UIImage imageNamed:@"btn_sub_normal"] forState:UIControlStateNormal];
    [tempSubButton setBackgroundImage:[UIImage imageNamed:@"btn_sub_pressed"] forState:UIControlStateHighlighted];
    [tempSubButton addTarget:self action:@selector(onSubButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:tempSubButton];
    tempAddButton = [[UIButton alloc] initWithFrame:CGRectMake(222.0, 1.5, 66.0, 63.0)];
    [tempAddButton setBackgroundImage:[UIImage imageNamed:@"btn_add_normal"] forState:UIControlStateNormal];
    [tempAddButton setBackgroundImage:[UIImage imageNamed:@"btn_add_pressed"] forState:UIControlStateHighlighted];
    [tempAddButton addTarget:self action:@selector(onAddButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [tempView addSubview:tempAddButton];
    label_indoor = [[UILabel alloc] initWithFrame:CGRectMake(68.0, 5.0, 35.0, 15.0)];
    [label_indoor setText:@"室温"];
    [label_indoor setBackgroundColor:[UIColor clearColor]];
    [label_indoor setFont:[UIFont boldSystemFontOfSize:12.0]];
    [label_indoor setTextAlignment:NSTextAlignmentRight];
    [label_indoor setTextColor:[UIColor colorWithRed:0.808 green:0.804 blue:0.792 alpha:1.0]];
    [tempView addSubview:label_indoor];
    temp_mini = [[UILabel alloc] initWithFrame:CGRectMake(68.0, 20.0, 35.0, 15.0)];
    [temp_mini setText:@"--℃"];
    [temp_mini setBackgroundColor:[UIColor clearColor]];
    [temp_mini setFont:[UIFont systemFontOfSize:12.0]];
    [temp_mini setTextColor:[UIColor colorWithRed:0.808 green:0.804 blue:0.792 alpha:1.0]];
    [temp_mini setTextAlignment:NSTextAlignmentRight];
    [tempView addSubview:temp_mini];
    temp_big = [[UILabel alloc] initWithFrame:CGRectMake(100.0, 15.0, 56.0, 44.0)];
    [temp_big setBackgroundColor:[UIColor clearColor]];
    [temp_big setTextColor:[UIColor whiteColor]];
    [temp_big setFont:[UIFont systemFontOfSize:28.0]];
    [temp_big setText:@"--"];
    [temp_big setTextAlignment:NSTextAlignmentRight];
    [tempView addSubview:temp_big];
    tempsysbol = [[UILabel alloc] initWithFrame:CGRectMake(160.0, 26.0, 28.0, 28.0)];
    [tempsysbol setBackgroundColor:[UIColor clearColor]];
    [tempsysbol setText:@"℃"];
    [tempsysbol setTextColor:[UIColor colorWithRed:0.808 green:0.804 blue:0.792 alpha:1.0]];
    [tempsysbol setFont:[UIFont systemFontOfSize:20.0]];
    [tempView addSubview:tempsysbol];
    
    settingButton = [[UIButton alloc] initWithFrame:CGRectMake(219.0, 355.0, 86.0, 34.0)];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_air_set_normal"] forState:UIControlStateNormal];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_air_set_pressed"] forState:UIControlStateHighlighted];
    [settingButton addTarget:self action:@selector(onSetButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:settingButton];
    
    NSString *airState = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"air_state%@%@", self.model.mainaddr, self.model.secondaryaddr]];
    if (airState) {
        NSArray *stateArray = [airState componentsSeparatedByString:@"|"];
        if ([[stateArray objectAtIndex:0] integerValue] == 1) {
            [on_off setTag:1];
            [on_off setImage:[UIImage imageNamed:@"btn_switch_on_air"] forState:UIControlStateNormal];
        }
        
        self.currentMode = [[stateArray objectAtIndex:1] integerValue];
        [(UIButton *)[modeView viewWithTag:self.currentMode + Mode_Button_Base_Tag] setSelected:YES];
        for (int i = 0; i < self.model.modes.count; i++) {
            int tag = [self checkMode:[self.model.modes objectAtIndex:i]] + Mode_Button_Base_Tag;
            if (tag != self.currentMode + Mode_Button_Base_Tag) {
                [(UIButton *)[modeView viewWithTag:tag] setSelected:NO];
            }
        }
        self.currentSpeed = [[stateArray objectAtIndex:2] integerValue];
        [(UIButton *)[speedView viewWithTag:self.currentSpeed + Speed_Button_Base_Tag] setSelected:YES];
        for (int i = 0; i < 3; i++) {
            if (self.currentSpeed != i) {
                [(UIButton *)[speedView viewWithTag:i + Speed_Button_Base_Tag] setSelected:NO];
            }
        }
        self.currentTemp = [[stateArray objectAtIndex:3] integerValue];
        [temp_big setText:[NSString stringWithFormat:@"%d", self.currentTemp]];
    }
}

- (void)switchButtonClicked:(UIButton *)sender
{
    self.skip = YES;
    if (sender.tag == 1) {
        [on_off setTag:0];
        [on_off setImage:[UIImage imageNamed:@"btn_switch_off_air"] forState:UIControlStateNormal];
    } else {
        [on_off setTag:1];
        [on_off setImage:[UIImage imageNamed:@"btn_switch_on_air"] forState:UIControlStateNormal];
    }
}

- (int)checkMode:(NSString *)mode
{
    if ([mode isEqualToString:@"Wind"]) {
        return 0;
    } else if ([mode isEqualToString:@"Hot"]) {
        return 1;
    } else if ([mode isEqualToString:@"Cool"]) {
        return 2;
    } else if ([mode isEqualToString:@"Auto"]) {
        return 3;
    } else if ([mode isEqualToString:@"Wet"]) {
        return 4;
    } else {
        return -1;
    }
}

- (void)onModeButtonClick:(UIButton *)button
{
    self.skip = YES;
    self.currentMode = button.tag - Mode_Button_Base_Tag;
    [button setSelected:YES];
    for (int i = 0; i < self.model.modes.count; i++) {
        int tag = [self checkMode:[self.model.modes objectAtIndex:i]] + Mode_Button_Base_Tag;
        if (tag != button.tag) {
            [(UIButton *)[modeView viewWithTag:tag] setSelected:NO];
        }
    }
}

- (void)onSpeedButtonClick:(UIButton *)button
{
    self.skip = YES;
    self.currentSpeed = button.tag - Speed_Button_Base_Tag;
    [button setSelected:YES];
    for (int i = 0; i < 3; i++) {
        if (button.tag != i + Speed_Button_Base_Tag) {
            [(UIButton *)[speedView viewWithTag:i + Speed_Button_Base_Tag] setSelected:NO];
        }
    }
}

- (void)onSubButtonClicked
{
    self.skip = YES;
    if (self.currentTemp == -1) {
        self.currentTemp = 25;
    } else {
        self.currentTemp--;
    }
    [temp_big setText:[NSString stringWithFormat:@"%d", self.currentTemp]];
}

- (void)onAddButtonClicked
{
    self.skip = YES;
    if (self.currentTemp == -1) {
        self.currentTemp = 25;
    } else {
        self.currentTemp++;
    }
    [temp_big setText:[NSString stringWithFormat:@"%d", self.currentTemp]];
}

- (void)onSetButtonClicked
{
    if (self.currentMode < 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"未设置模式" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (self.currentSpeed < 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"未设置风速" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    if (self.currentTemp < 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"未设置温度" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d|%d|%d|%d", on_off.tag, self.currentMode, self.currentSpeed, self.currentTemp] forKey:[NSString stringWithFormat:@"air_state%@%@", self.model.mainaddr, self.model.secondaryaddr]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self.appDelegate delegateQueue:self.appDelegate.socketQueue];
        NSString *command = [NSString stringWithFormat:@"*aircset %@,%@,%d,%d,%d,%d,%d", self.model.mainaddr, self.model.secondaryaddr, on_off.tag, WIND_DIRECT, self.currentSpeed, self.currentMode, self.currentTemp];
        socket.command = [NSString stringWithFormat:@"%@\r\n", command];
        [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
    });
}

- (void)setCurrentStatus:(NSMutableString *)status
{
    if (self.skip) {
        self.skip = NO;
        return;
    }
    NSArray *stateArray = [status componentsSeparatedByString:@"|"];
    if (stateArray.count != 4) {
        return;
    }
    if ([[stateArray objectAtIndex:0] integerValue] == 1) {
        [on_off setTag:1];
        [on_off setImage:[UIImage imageNamed:@"btn_switch_on_air"] forState:UIControlStateNormal];
    } else {
        [on_off setTag:0];
        [on_off setImage:[UIImage imageNamed:@"btn_switch_off_air"] forState:UIControlStateNormal];
    }
    
    self.currentMode = [[stateArray objectAtIndex:1] integerValue];
    [(UIButton *)[modeView viewWithTag:self.currentMode + Mode_Button_Base_Tag] setSelected:YES];
    for (int i = 0; i < self.model.modes.count; i++) {
        int tag = [self checkMode:[self.model.modes objectAtIndex:i]] + Mode_Button_Base_Tag;
        if (tag != self.currentMode + Mode_Button_Base_Tag) {
            [(UIButton *)[modeView viewWithTag:tag] setSelected:NO];
        }
    }
    self.currentSpeed = [[stateArray objectAtIndex:2] integerValue];
    [(UIButton *)[speedView viewWithTag:self.currentSpeed + Speed_Button_Base_Tag] setSelected:YES];
    for (int i = 0; i < 3; i++) {
        if (self.currentSpeed != i) {
            [(UIButton *)[speedView viewWithTag:i + Speed_Button_Base_Tag] setSelected:NO];
        }
    }
    self.currentTemp = [[stateArray objectAtIndex:3] integerValue];
    [temp_big setText:[NSString stringWithFormat:@"%d", self.currentTemp]];
    
    [[NSUserDefaults standardUserDefaults] setObject:status forKey:[NSString stringWithFormat:@"air_state%@%@", self.model.mainaddr, self.model.secondaryaddr]];
}

@end
