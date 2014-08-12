//
//  SHPassWordSettingViewController.h
//  SmartHouseIphone
//
//  Created by Roc on 14-8-12.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHParentViewController.h"

@interface SHPassWordSettingViewController : SHParentViewController<UITextFieldDelegate>

@property(nonatomic, strong)UIButton *commit;
@property(nonatomic, strong)UIButton *cancel;
@property(nonatomic, strong)UIView *settingbox;
@property(nonatomic, strong)UILabel *titleLabel;
@property(nonatomic, strong)UITextField *oldpassword;
@property(nonatomic, strong)UITextField *newpassword;
@property(nonatomic, strong)UITextField *newpassword_again;

@end
