//
//  SHParentViewController.h
//  SmartHouse_iphone
//
//  Created by Roc on 14-7-30.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface SHParentViewController : UIViewController

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *contentView;

@property (strong, nonatomic) AppDelegate *appDelegate;
@property (strong, nonatomic) UIBarButtonItem *networkStateButton;

- (void)setNavigationLeftButtonWithTarget:(id)target Action:(SEL)selector;
- (void)setNavigationTitle:(NSString *)title;
- (void)setNavigationTitleView:(UIView *)view;
- (void)setNetworkState:(BOOL)state;

@end
