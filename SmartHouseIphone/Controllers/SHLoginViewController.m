//
//  SHLoginViewController.m
//  SmartHouse_iphone
//
//  Created by Roc on 14-7-30.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHLoginViewController.h"
#import "SHRoomsListViewController.h"

@interface SHLoginViewController ()

@end

@implementation SHLoginViewController

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
    keyBoardShowing = NO;
    [super viewDidLoad];
    [self hideNavigationBar];
    [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.contentView setUserInteractionEnabled:YES];
    [self.contentView addGestureRecognizer:tap1];
    
    self.loginbox = [[UIView alloc] initWithFrame:CGRectMake(42.0, 40.0, 236.0, 169.0)];
    [self.loginbox setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login_box_iphone"]]];
    [self.contentView addSubview:self.loginbox];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.loginbox setUserInteractionEnabled:YES];
    [self.loginbox addGestureRecognizer:tap];
    
    self.loginTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 10.0, 236.0, 30.0)];
    [self.loginTitle setBackgroundColor:[UIColor clearColor]];
    [self.loginTitle setTextAlignment:NSTextAlignmentCenter];
    [self.loginTitle setFont:[UIFont boldSystemFontOfSize:16.0]];
    [self.loginTitle setTextColor:[UIColor colorWithRed:0.714 green:0.267 blue:0.086 alpha:1]];
    [self.loginTitle setText:@"智能家居控制系统"];
    [self.loginbox addSubview:self.loginTitle];
    
    self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(24.0, 69.0, 188.0, 31.0)];
    [self.passwordField setBackground:[UIImage imageNamed:@"login_input_box"]];
    [self.passwordField setTextAlignment:NSTextAlignmentCenter];
    [self.passwordField setSecureTextEntry:YES];
    [self.passwordField setPlaceholder:@"请输入密码"];
    [self.passwordField setFont:[UIFont systemFontOfSize:12.0]];
    [self.passwordField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.passwordField setDelegate:self];
    [self.loginbox addSubview:self.passwordField];
    
    self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(20.75, 110.0, 193.0, 37.0)];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_login_iphone_press"] forState:UIControlStateHighlighted];
    [self.loginButton setBackgroundImage:[UIImage imageNamed:@"btn_login_iphone_normal"] forState:UIControlStateNormal];
    [self.loginButton addTarget:self action:@selector(loginCheck) forControlEvents:UIControlEventTouchUpInside];
    [self.loginbox addSubview:self.loginButton];
}

- (void)loginCheck
{
    [self.passwordField resignFirstResponder];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (password) {
        if ([password isEqualToString:[self.passwordField text]]) {
            SHRoomsListViewController *controller = [[SHRoomsListViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            [self.passwordField setText:nil];
            [self.passwordField setBackground:[UIImage imageNamed:@"login_input_box"]];
            [self.passwordField setPlaceholder:@"请输入密码"];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
        }
    } else {
        if ([[self.passwordField text] isEqualToString:@"0000"]) {
            SHRoomsListViewController *controller = [[SHRoomsListViewController alloc] initWithNibName:nil bundle:nil];
            [self.navigationController pushViewController:controller animated:YES];
            [self.passwordField setText:nil];
            [self.passwordField setBackground:[UIImage imageNamed:@"login_input_box"]];
            [self.passwordField setPlaceholder:@"请输入密码"];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"密码错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [av show];
        }
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.passwordField setPlaceholder:@""];
    [self.passwordField setBackground:[UIImage imageNamed:@"login_input_box_focused"]];
}

- (void)hideNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.contentView setFrame:CGRectMake(0.0, 0.0, 320.0, App_Height)];
}

- (void)hideKeyboard
{
    [self.passwordField resignFirstResponder];
    [self.passwordField setPlaceholder:@"请输入密码"];
    [self.passwordField setBackground:[UIImage imageNamed:@"login_input_box"]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.passwordField resignFirstResponder];
    [self.passwordField setText:nil];
    [self.passwordField setPlaceholder:@"请输入密码"];
    [self.passwordField setBackground:[UIImage imageNamed:@"login_input_box"]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
