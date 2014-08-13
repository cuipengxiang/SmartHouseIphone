//
//  SHRoomMainViewController.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHRoomMainViewController.h"
#import "SHSettingsViewController.h"

@interface SHRoomMainViewController ()

@end

@implementation SHRoomMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
    [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_setup"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(onSettingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    NSArray *rightButtons = @[self.networkStateButton, settingBarButton];
    [self.navigationItem setRightBarButtonItems:rightButtons];
    
    NSString *imagename;
    if ([self.appDelegate.host isEqualToString:self.appDelegate.host1]) {
        imagename = @"btn_switch_big2";
    } else {
        imagename = @"btn_switch_big1";
    }
    self.networkButton = [[UIButton alloc] initWithFrame:CGRectMake(75.0, 30.0, 170.0, 42.0)];
    [self.networkButton setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [self.networkButton addTarget:self action:@selector(onNetworkClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.networkButton];
    
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
        [lightButton addTarget:self action:@selector(onModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:lightButton];
    }
    if ((self.model.curtains)&&(self.model.curtains.count > 0)) {
        UIButton *curtainButton = [[UIButton alloc] init];
        [curtainButton setBackgroundImage:[UIImage imageNamed:@"btn_curtain"] forState:UIControlStateNormal];
        [curtainButton addTarget:self action:@selector(onModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:curtainButton];
    }
    if ((self.model.airconditionings)&&(self.model.airconditionings.count > 0)) {
        UIButton *airButton = [[UIButton alloc] init];
        [airButton setBackgroundImage:[UIImage imageNamed:@"btn_air"] forState:UIControlStateNormal];
        [airButton addTarget:self action:@selector(onModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:airButton];
    }
    /*
    if ((self.model.modes)&&(self.model.modes.count > 0)) {
        UIButton *modeButton = [[UIButton alloc] init];
        [modeButton setBackgroundImage:[UIImage imageNamed:@"btn_mode"] forState:UIControlStateNormal];
        [modeButton addTarget:self action:@selector(onModeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [buttons addObject:modeButton];
    }
     */
    for (int i = 0; i < buttons.count; i++) {
        UIButton *button = [buttons objectAtIndex:i];
        [button setFrame:CGRectMake(57.0 + i%2*120.0, 100.0 + i/2*125.0, 86.0, 89.0)];
        [self.contentView addSubview:button];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)onNetworkClick
{
    NSString *imagename;
    if ([self.appDelegate.host isEqualToString:self.appDelegate.host1]) {
        self.appDelegate.host = self.appDelegate.host2;
        imagename = @"btn_switch_big1";
    } else {
        self.appDelegate.host = self.appDelegate.host1;
        imagename = @"btn_switch_big2";
    }
    [self.networkButton setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:self.appDelegate.host forKey:@"host"];
}

- (void)onModeButtonClicked
{
    
}

- (void)onLightButtonClicked
{
    
}

- (void)onCurtainButtonClicked
{
    
}

- (void)onAirButtonClicked
{
    
}

- (void)onMusicButtonClicked
{
    
}

- (void)onSettingButtonClicked
{
    SHSettingsViewController *settingController = [[SHSettingsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
