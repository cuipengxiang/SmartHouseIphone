//
//  SHLoginViewController.h
//  SmartHouse_iphone
//
//  Created by Roc on 14-7-30.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"

@interface SHLoginViewController : SHParentViewController<UITextFieldDelegate, UIAlertViewDelegate>
{
    BOOL keyBoardShowing;
}

@property (nonatomic, strong)UITextField *passwordField;
@property (nonatomic, strong)UIButton *loginButton;
@property (nonatomic, strong)UIView *loginbox;
@property (nonatomic, strong)UILabel *loginTitle;

- (void)loginCheck;

@end
