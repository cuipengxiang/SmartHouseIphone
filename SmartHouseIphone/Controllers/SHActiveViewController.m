//
//  SHActiveViewController.m
//  SmartHouse_iphone
//
//  Created by Roc on 14-7-30.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHActiveViewController.h"
#import "SHLoginViewController.h"

@interface SHActiveViewController ()

@end

@implementation SHActiveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    keyBoardShowing = NO;
    [super viewDidLoad];
    [self hideNavigationBar];
    [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    self.activeBox = [[UIView alloc] initWithFrame:CGRectMake(15.0, 40.0, 290.0, 302.0)];
    [self.activeBox setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"box_bg"]]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
    [self.activeBox addGestureRecognizer:tap];
    [self.activeBox setUserInteractionEnabled:YES];
    [self.contentView addSubview:self.activeBox];
    
    self.activeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 15.0, 290.0, 30.0)];
    [self.activeTitle setTextAlignment:NSTextAlignmentCenter];
    [self.activeTitle setBackgroundColor:[UIColor clearColor]];
    [self.activeTitle setFont:[UIFont boldSystemFontOfSize:18.0]];
    [self.activeTitle setTextColor:[UIColor colorWithRed:0.714 green:0.267 blue:0.086 alpha:1]];
    [self.activeTitle setText:@"获取激活码"];
    [self.activeBox addSubview:self.activeTitle];
    
    self.activeNum = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 70.0, 290.0, 30.0)];
    [self.activeNum setTextAlignment:NSTextAlignmentCenter];
    [self.activeNum setBackgroundColor:[UIColor clearColor]];
    [self.activeNum setFont:[UIFont boldSystemFontOfSize:20.0]];
    [self.activeNum setTextColor:[UIColor colorWithRed:0.714 green:0.267 blue:0.086 alpha:1]];
    [self.activeNum setText:@"1 2 3 4 5 6"];
    [self.activeBox addSubview:self.activeNum];
    
    self.activeSummary = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, 0.0)];
    [self.activeSummary setNumberOfLines:0];
    NSString *summary = @"发送上面的数字到13912345678获取验证码并填入下方输入框中";
    UIFont *font = [UIFont systemFontOfSize:14.0];
    CGSize size = CGSizeMake(240.0, 50.0);
    CGSize labelsize = [summary sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    [self.activeSummary setFrame:CGRectMake(25.0, 115.0, labelsize.width, labelsize.height)] ;
    [self.activeSummary setTextAlignment:NSTextAlignmentCenter];
    [self.activeSummary setBackgroundColor:[UIColor clearColor]];
    [self.activeSummary setFont:font];
    [self.activeSummary setTextColor:[UIColor colorWithRed:0.714 green:0.267 blue:0.086 alpha:1]];
    [self.activeSummary setText:summary];
    [self.activeBox addSubview:self.activeSummary];
    
    self.activeField = [[UITextField alloc] initWithFrame:CGRectMake(25.0, 175.0, 240.0, 40.0)];
    [self.activeField setBackground:[UIImage imageNamed:@"input_box"]];
    [self.activeField setFont:[UIFont systemFontOfSize:20.0]];
    [self.activeField setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.activeField setTextColor:[UIColor colorWithRed:0.714 green:0.267 blue:0.086 alpha:1]];
    [self.activeField setTextAlignment:NSTextAlignmentCenter];
    [self.activeField setDelegate:self];
    [self.activeBox addSubview:self.activeField];
    
    self.activeSubmit = [[UIButton alloc] initWithFrame:CGRectMake(22.5, 230.0, 245.0, 47.0)];
    [self.activeSubmit setBackgroundImage:[UIImage imageNamed:@"btn_commit_normal"] forState:UIControlStateNormal];
    [self.activeSubmit setBackgroundImage:[UIImage imageNamed:@"btn_commit_pressed"] forState:UIControlStateHighlighted];
    [self.activeSubmit addTarget:self action:@selector(onSubmitClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.activeBox addSubview:self.activeSubmit];
}

- (void)onSubmitClicked
{
    SHLoginViewController *loginController = [[SHLoginViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:loginController animated:YES];
}

- (void)hideNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.contentView setFrame:CGRectMake(0.0, 0.0, 320.0, App_Height)];
}

- (void)hideKeyboard
{
    [self.activeField resignFirstResponder];
    if ((keyBoardShowing)&&(App_Height <= 480.0)) {
        CGRect frame = self.contentView.frame;
        int offset = frame.origin.y + 80.0;//键盘高度216
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width = self.contentView.frame.size.width;
        float height = self.contentView.frame.size.height;

        CGRect rect = CGRectMake(self.contentView.frame.origin.x, offset, width, height);
        self.contentView.frame = rect;

        [UIView commitAnimations];
        keyBoardShowing = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    if ((!keyBoardShowing)||(App_Height >= 480.0)) {
        return YES;
    }
    CGRect frame = self.contentView.frame;
    int offset = frame.origin.y + 80.0;//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.contentView.frame.size.width;
    float height = self.contentView.frame.size.height;

    CGRect rect = CGRectMake(self.contentView.frame.origin.x, offset, width, height);
    self.contentView.frame = rect;

    [UIView commitAnimations];
    keyBoardShowing = NO;
    [textField resignFirstResponder];
    return YES;
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    NSLog(@"%f", App_Height);
    if ((keyBoardShowing)||(App_Height >= 480.0)) {
        return;
    }
    CGRect frame = self.contentView.frame;
    int offset = frame.origin.y - 80.0;//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.contentView.frame.size.width;
    float height = self.contentView.frame.size.height;

    CGRect rect = CGRectMake(self.contentView.frame.origin.x, offset, width, height);
    self.contentView.frame = rect;
    
    [UIView commitAnimations];
    keyBoardShowing = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
