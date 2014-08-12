//
//  SHPassWordSettingViewController.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-12.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHPassWordSettingViewController.h"

@interface SHPassWordSettingViewController ()

@end

@implementation SHPassWordSettingViewController

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
    [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    
    self.settingbox = [[UIView alloc] initWithFrame:CGRectMake(42.0, 40.0, 236.0, 254.0)];
    [self.settingbox setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"setup_box"]]];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouch)];
    [self.contentView addGestureRecognizer:gesture];
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTouch)];
    [self.settingbox addGestureRecognizer:gesture1];
    
    self.titleLabel = [[UILabel alloc] init];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:16.0]];
    [self.titleLabel setTextColor:[UIColor colorWithRed:0.694 green:0.278 blue:0.020 alpha:1.0]];
    [self.titleLabel setText:@"密码设置"];
    [self.titleLabel sizeToFit];
    [self.titleLabel setFrame:CGRectMake((236.0 - self.titleLabel.frame.size.width)/2.0, 15.0, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height)];
    
    self.oldpassword = [[UITextField alloc] initWithFrame:CGRectMake(24.0, 60.0, 188.0, 31.5)];
    [self.oldpassword setSecureTextEntry:YES];
    [self.oldpassword setPlaceholder:@"输入旧密码"];
    [self.oldpassword setFont:[UIFont systemFontOfSize:14.0]];
    [self.oldpassword setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.oldpassword setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.oldpassword setTextAlignment:NSTextAlignmentCenter];
    [self.oldpassword setDelegate:self];
    [self.oldpassword setBackground:[UIImage imageNamed:@"input_box_iphone"]];
    
    self.newpassword = [[UITextField alloc] initWithFrame:CGRectMake(24.0, 103.5, 188.0, 31.5)];
    [self.newpassword setSecureTextEntry:YES];
    [self.newpassword setPlaceholder:@"输入新密码"];
    [self.newpassword setFont:[UIFont systemFontOfSize:14.0]];
    [self.newpassword setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.newpassword setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.newpassword setTextAlignment:NSTextAlignmentCenter];
    [self.newpassword setDelegate:self];
    [self.newpassword setBackground:[UIImage imageNamed:@"input_box_iphone"]];
    
    self.newpassword_again = [[UITextField alloc] initWithFrame:CGRectMake(24.0, 147.0, 188.0, 31.5)];
    [self.newpassword_again setSecureTextEntry:YES];
    [self.newpassword_again setPlaceholder:@"再次输入新密码"];
    [self.newpassword_again setFont:[UIFont systemFontOfSize:14.0]];
    [self.newpassword_again setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.newpassword_again setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [self.newpassword_again setTextAlignment:NSTextAlignmentCenter];
    [self.newpassword_again setDelegate:self];
    [self.newpassword_again setBackground:[UIImage imageNamed:@"input_box_iphone"]];
    
    self.commit = [[UIButton alloc] init];
    [self.commit setBackgroundImage:[UIImage imageNamed:@"btn_commit_normal"] forState:UIControlStateNormal];
    [self.commit setBackgroundImage:[UIImage imageNamed:@"btn_commit_pressed"] forState:UIControlStateHighlighted];
    [self.commit addTarget:self action:@selector(onCommitClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.cancel = [[UIButton alloc] init];
    [self.cancel setBackgroundImage:[UIImage imageNamed:@"btn_cancel_normal"] forState:UIControlStateNormal];
    [self.cancel setBackgroundImage:[UIImage imageNamed:@"btn_cancel_pressed"] forState:UIControlStateHighlighted];
    [self.cancel addTarget:self action:@selector(onBackButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.commit setFrame:CGRectMake(121.0f, 195.0f, 95.0f, 37.0f)];
    [self.cancel setFrame:CGRectMake(20.0f, 195.0f, 95.0f, 37.0f)];
    [self.settingbox addSubview:self.titleLabel];
    [self.settingbox addSubview:self.oldpassword];
    [self.settingbox addSubview:self.newpassword];
    [self.settingbox addSubview:self.newpassword_again];
    [self.settingbox addSubview:self.cancel];
    [self.settingbox addSubview:self.commit];
    
    [self.contentView addSubview:self.settingbox];
}

- (void)onBackButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onCommitClick:(id)sender
{
    if (![self.newpassword.text isEqualToString:self.newpassword_again.text]) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"两次输入的新密码不一致" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [av show];
        [self.oldpassword setText:nil];
        [self.newpassword setText:nil];
        [self.newpassword_again setText:nil];
        [self.oldpassword resignFirstResponder];
        [self.newpassword resignFirstResponder];
        [self.newpassword_again resignFirstResponder];
        [self.oldpassword setBackground:[UIImage imageNamed:@"input_box"]];
        [self.oldpassword setPlaceholder:@"输入旧密码"];
        [self.newpassword setBackground:[UIImage imageNamed:@"input_box"]];
        [self.newpassword setPlaceholder:@"输入新密码"];
        [self.newpassword_again setBackground:[UIImage imageNamed:@"input_box"]];
        [self.newpassword_again setPlaceholder:@"再次输入新密码"];
        
        return;
    }
    if (self.newpassword.text.length < 4) {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"密码长度不能小于4位" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [av show];
        [self.oldpassword setText:nil];
        [self.newpassword setText:nil];
        [self.newpassword_again setText:nil];
        [self.oldpassword resignFirstResponder];
        [self.newpassword resignFirstResponder];
        [self.newpassword_again resignFirstResponder];
        [self.oldpassword setBackground:[UIImage imageNamed:@"input_box"]];
        [self.oldpassword setPlaceholder:@"输入旧密码"];
        [self.newpassword setBackground:[UIImage imageNamed:@"input_box"]];
        [self.newpassword setPlaceholder:@"输入新密码"];
        [self.newpassword_again setBackground:[UIImage imageNamed:@"input_box"]];
        [self.newpassword_again setPlaceholder:@"再次输入新密码"];
        
        return;
    }
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if (password) {
        if ([password isEqualToString:[self.oldpassword text]]) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"修改密码成功" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [av show];
            [self.oldpassword setText:nil];
            [self.newpassword setText:nil];
            [self.newpassword_again setText:nil];
            [self.oldpassword resignFirstResponder];
            [self.newpassword resignFirstResponder];
            [self.newpassword_again resignFirstResponder];
            [self.oldpassword setBackground:[UIImage imageNamed:@"input_box"]];
            [self.oldpassword setPlaceholder:@"输入旧密码"];
            [self.newpassword setBackground:[UIImage imageNamed:@"input_box"]];
            [self.newpassword setPlaceholder:@"输入新密码"];
            [self.newpassword_again setBackground:[UIImage imageNamed:@"input_box"]];
            [self.newpassword_again setPlaceholder:@"再次输入新密码"];

            [[NSUserDefaults standardUserDefaults] setObject:self.newpassword.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"旧密码错误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [av show];
            [self.oldpassword setText:nil];
            [self.newpassword setText:nil];
            [self.newpassword_again setText:nil];
            [self.oldpassword resignFirstResponder];
            [self.newpassword resignFirstResponder];
            [self.newpassword_again resignFirstResponder];
            [self.oldpassword setBackground:[UIImage imageNamed:@"input_box"]];
            [self.oldpassword setPlaceholder:@"输入旧密码"];
            [self.newpassword setBackground:[UIImage imageNamed:@"input_box"]];
            [self.newpassword setPlaceholder:@"输入新密码"];
            [self.newpassword_again setBackground:[UIImage imageNamed:@"input_box"]];
            [self.newpassword_again setPlaceholder:@"再次输入新密码"];
            
            return;
        }
    } else {
        if ([[self.oldpassword text] isEqualToString:@"0000"]) {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"修改密码成功" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [av show];
            [self.oldpassword setText:nil];
            [self.newpassword setText:nil];
            [self.newpassword_again setText:nil];
            [self.oldpassword resignFirstResponder];
            [self.newpassword resignFirstResponder];
            [self.newpassword_again resignFirstResponder];
            [self.oldpassword setBackground:[UIImage imageNamed:@"input_box"]];
            [self.oldpassword setPlaceholder:@"输入旧密码"];
            [self.newpassword setBackground:[UIImage imageNamed:@"input_box"]];
            [self.newpassword setPlaceholder:@"输入新密码"];
            [self.newpassword_again setBackground:[UIImage imageNamed:@"input_box"]];
            [self.newpassword_again setPlaceholder:@"再次输入新密码"];

            [[NSUserDefaults standardUserDefaults] setObject:self.newpassword.text forKey:@"password"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"旧密码错误" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [av show];
            [self.oldpassword setText:nil];
            [self.newpassword setText:nil];
            [self.newpassword_again setText:nil];
            [self.oldpassword resignFirstResponder];
            [self.newpassword resignFirstResponder];
            [self.newpassword_again resignFirstResponder];
            [self.oldpassword setBackground:[UIImage imageNamed:@"input_box"]];
            [self.oldpassword setPlaceholder:@"输入旧密码"];
            [self.newpassword setBackground:[UIImage imageNamed:@"input_box"]];
            [self.newpassword setPlaceholder:@"输入新密码"];
            [self.newpassword_again setBackground:[UIImage imageNamed:@"input_box"]];
            [self.newpassword_again setPlaceholder:@"再次输入新密码"];
            
            return;
        }
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIButton class]]) {
        return NO;
    }
    return YES;
}

- (void)onTouch
{
    [self.oldpassword resignFirstResponder];
    [self.newpassword resignFirstResponder];
    [self.newpassword_again resignFirstResponder];
    if (self.oldpassword.text.length == 0) {
        [self.oldpassword setBackground:[UIImage imageNamed:@"input_box"]];
        [self.oldpassword setPlaceholder:@"输入旧密码"];
    }
    if (self.newpassword.text.length == 0) {
        [self.newpassword setBackground:[UIImage imageNamed:@"input_box"]];
        [self.newpassword setPlaceholder:@"输入新密码"];
    }
    if (self.newpassword_again.text.length == 0) {
        [self.newpassword_again setBackground:[UIImage imageNamed:@"input_box"]];
        [self.newpassword_again setPlaceholder:@"再次输入新密码"];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.oldpassword.text.length == 0) {
        [self.oldpassword setBackground:[UIImage imageNamed:@"input_box"]];
        [self.oldpassword setPlaceholder:@"输入旧密码"];
    }
    if (self.newpassword.text.length == 0) {
        [self.newpassword setBackground:[UIImage imageNamed:@"input_box"]];
        [self.newpassword setPlaceholder:@"输入新密码"];
    }
    if (self.newpassword_again.text.length == 0) {
        [self.newpassword_again setBackground:[UIImage imageNamed:@"input_box"]];
        [self.newpassword_again setPlaceholder:@"再次输入新密码"];
    }
    [textField setBackground:[UIImage imageNamed:@"input_box_focused"]];
    [textField setPlaceholder:@""];
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

}

@end
