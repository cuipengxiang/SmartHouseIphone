//
//  SHLoginViewController.h
//  SmartHouse_iphone
//
//  Created by Roc on 14-7-30.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"

@interface SHLoginViewController : SHParentViewController<UIGestureRecognizerDelegate, UITextFieldDelegate>
{
    UILabel *loginLabel;
}

@property (nonatomic, strong)UITextField *passwordField;
@property (nonatomic, strong)UIButton *loginButton;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIImageView *loginbox;

- (void)loginCheck;
- (void)onTouch;

@end
