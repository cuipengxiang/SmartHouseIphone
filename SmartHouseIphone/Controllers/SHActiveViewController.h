//
//  SHActiveViewController.h
//  SmartHouse_iphone
//
//  Created by Roc on 14-7-30.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"

@interface SHActiveViewController : SHParentViewController<UITextFieldDelegate>
{
    BOOL keyBoardShowing;
}

@property (strong, nonatomic) UIView *activeBox;
@property (strong, nonatomic) UILabel *activeTitle;
@property (strong, nonatomic) UILabel *activeNum;
@property (strong, nonatomic) UILabel *activeSummary;
@property (strong, nonatomic) UITextField *activeField;
@property (strong, nonatomic) UIButton *activeSubmit;

@end
