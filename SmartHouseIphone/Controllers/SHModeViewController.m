//
//  SHModeViewController.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHModeViewController.h"
#define Button_Base_Tag 1000

@interface SHModeViewController ()

@end

@implementation SHModeViewController

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
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 10.0, 320.0, self.contentView.frame.size.height - 20.0)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setContentSize:CGSizeMake(320.0, 10 + self.modes.count * 90)];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.contentView addSubview:scrollView];
    
    for (int i = 0; i < self.modes.count; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(18.0, 10 + 90*i, 284.0, 77.0)];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_mode_%d", i + 1]] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_mode_%d_pressed", i + 1]] forState:UIControlStateHighlighted];
        [button setTag:Button_Base_Tag + i];
        [scrollView addSubview:button];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
