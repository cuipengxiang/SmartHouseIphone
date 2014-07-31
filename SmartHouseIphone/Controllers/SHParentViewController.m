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
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:IS_iOS7 ? @"topbar_bg" : @"topbar_bg"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(118.5, 10.0, 83.0, 25.0)];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setTextColor:[UIColor colorWithRed:0.427 green:0.361 blue:0.333 alpha:1.0]];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:22.0]];
    
    [self.navigationItem setTitleView:self.titleLabel];
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, App_Height - Nav_Height)];
    [self.view addSubview:self.contentView];
}

- (void)setNavigationRightButtonWithImage:(UIImage *)image Target:(id)target Action:(SEL)selector
{
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 12.0, 20.0, 20.0)];
    [rightButton setImage:image forState:UIControlStateNormal];
    [rightButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:rightButton]];
}

- (void)setNavigationLeftButtonWithImage:(UIImage *)image Target:(id)target Action:(SEL)selector
{
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 12.0, 20.0, 20.0)];
    [leftButton setImage:image forState:UIControlStateNormal];
    [leftButton addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftButton]];
}

- (void)setNavigationTitle:(NSString *)title
{
    [self.titleLabel setText:title];
}

- (void)setNavigationTitleView:(UIView *)view
{
    [self.navigationItem setTitleView:view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
