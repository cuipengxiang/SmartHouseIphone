//
//  SHSettingsViewController.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-12.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHSettingsViewController.h"

@interface SHSettingsViewController ()

@end

@implementation SHSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    
    self.settingbox = [[UIView alloc] init];
    [self.settingbox setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sys_setup_box"]]];
    [self.settingbox setFrame:CGRectMake(42.0, 60.0, 236.0, 169.0)];
    
    UILabel *boxTitle = [[UILabel alloc] init];
    [boxTitle setText:@"系统设置"];
    [boxTitle setTextColor:[UIColor colorWithRed:0.694 green:0.278 blue:0.020 alpha:1.0]];
    [boxTitle setFont:[UIFont boldSystemFontOfSize:16.0]];
    [boxTitle setTextAlignment:NSTextAlignmentCenter];
    [boxTitle sizeToFit];
    [boxTitle setFrame:CGRectMake((236.0-boxTitle.frame.size.width)/2, 13.0, boxTitle.frame.size.width, boxTitle.frame.size.height)];
    [boxTitle setBackgroundColor:[UIColor clearColor]];
    [self.settingbox addSubview:boxTitle];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(201.0, 13.0, 20.0, 20.0)];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"btn_close_normal"] forState:UIControlStateNormal];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"btn_close_pressed"] forState:UIControlStateHighlighted];
    [self.backButton addTarget:self action:@selector(onBackButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.settingbox addSubview:self.backButton];
    
    self.password = [[UIButton alloc] initWithFrame:CGRectMake(18.0, 70.0, 200.0, 29.0)];
    [self.password setBackgroundImage:[UIImage imageNamed:@"bg_setup_line"] forState:UIControlStateNormal];
    [self.password setImage:[UIImage imageNamed:@"bg_arrow"] forState:UIControlStateNormal];
    [self.password setImageEdgeInsets:UIEdgeInsetsMake(0.0, 175.0, 0.0, 0.0)];
    [self.password addTarget:self action:@selector(onPasswordClick) forControlEvents:UIControlEventTouchUpInside];
    [self.password setTitle:@"密码设置" forState:UIControlStateNormal];
    [self.password setTitleColor:[UIColor colorWithRed:0.804 green:0.748 blue:0.714 alpha:1.0] forState:UIControlStateNormal];
    [self.password.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [self.password setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -120.0, 0.0, 0.0)];
    [self.settingbox addSubview:self.password];
    
    self.network = [[UIButton alloc] initWithFrame:CGRectMake(18.0, 110.0, 200.0, 29.0)];
    [self.network setBackgroundImage:[UIImage imageNamed:@"bg_setup_line"] forState:UIControlStateNormal];
    NSString *imagename;
    if ([self.appDelegate.host isEqualToString:self.appDelegate.host1]) {
        imagename = @"btn_switch_2";
    } else {
        imagename = @"btn_switch_1";
    }
    [self.network setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [self.network setImageEdgeInsets:UIEdgeInsetsMake(0.0, 110.0, 0.0, 0.0)];
    [self.network addTarget:self action:@selector(onNetworkClick) forControlEvents:UIControlEventTouchUpInside];
    [self.network setTitle:@"联网设置" forState:UIControlStateNormal];
    [self.network setTitleColor:[UIColor colorWithRed:0.804 green:0.748 blue:0.714 alpha:1.0] forState:UIControlStateNormal];
    [self.network.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [self.network setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -186.0, 0.0, 0.0)];
    [self.settingbox addSubview:self.network];
    
    [self.contentView addSubview:self.settingbox];
}

- (void)onBackButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onPasswordClick
{
    SHPassWordSettingViewController *controller = [[SHPassWordSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onNetworkClick
{
    NSString *imagename;
    if ([self.appDelegate.host isEqualToString:self.appDelegate.host1]) {
        self.appDelegate.host = self.appDelegate.host2;
        imagename = @"btn_switch_1";
    } else {
        self.appDelegate.host = self.appDelegate.host1;
        imagename = @"btn_switch_2";
    }
    [self.network setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:self.appDelegate.host forKey:@"host"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self hideNavigationBar];
}

- (void)hideNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.contentView setFrame:CGRectMake(0.0, 0.0, 320.0, App_Height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
