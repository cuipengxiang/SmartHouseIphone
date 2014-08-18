//
//  SHParentViewController.m
//  SmartHouse_iphone
//
//  Created by Roc on 14-7-30.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"

@interface SHParentViewController ()

@end

@implementation SHParentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *networkButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
        [networkButton setBackgroundImage:[UIImage imageNamed:@"network_connected"] forState:UIControlStateNormal];
        [networkButton setBackgroundImage:[UIImage imageNamed:@"network_disconnected"] forState:UIControlStateSelected];
        [networkButton setUserInteractionEnabled:NO];
        self.networkStateButton = [[UIBarButtonItem alloc] initWithCustomView:networkButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topbar_bg"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self setNetworkState:self.appDelegate.currentNetworkState];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, IS_iOS7? 64.0:0.0, 320.0, App_Height - Nav_Height)];
    [self.view addSubview:self.contentView];
    
    [self setNavigationLeftButtonWithTarget:self Action:@selector(onBackButtonClicked)];
}

- (void)setNavigationLeftButtonWithTarget:(id)target Action:(SEL)selector
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [leftButton setImage:[UIImage imageNamed:@"btn_return"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"btn_return_pressed"] forState:UIControlStateHighlighted];
    [leftButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftButton]];
}

- (void)setNavigationTitle:(NSString *)title
{
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(118.5, 10.0, 83.0, 25.0)];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setTextColor:[UIColor colorWithRed:0.427 green:0.361 blue:0.333 alpha:1.0]];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:22.0]];
    
    [self.navigationItem setTitleView:self.titleLabel];
    [self.titleLabel setText:title];
}

- (void)setNavigationTitleView:(UIView *)view
{
    [self.navigationItem setTitleView:view];
}

- (BOOL)automaticallyAdjustsScrollViewInsets
{
    return NO;
}

- (void)onBackButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setNetworkState:(BOOL)state
{
    self.appDelegate.currentNetworkState = state;
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (state) {
            [(UIButton *)self.networkStateButton.customView setSelected:NO];
        } else {
            [(UIButton *)self.networkStateButton.customView setSelected:YES];
        }
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
