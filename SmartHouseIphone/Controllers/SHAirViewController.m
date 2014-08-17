//
//  SHAirViewController.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHAirViewController.h"
#import "SHSettingsViewController.h"
#import "SHAirView.h"

@interface SHAirViewController ()

@end

@implementation SHAirViewController

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
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_setup"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(onSettingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    NSArray *rightButtons = @[self.networkStateButton, settingBarButton];
    [self.navigationItem setRightBarButtonItems:rightButtons];
    
    airScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 390.0)];
    [airScrollView setContentSize:CGSizeMake(320.0*self.airs.count, 390.0)];
    [airScrollView setBackgroundColor:[UIColor clearColor]];
    [airScrollView setPagingEnabled:YES];
    [airScrollView setDelegate:self];
    [airScrollView setShowsHorizontalScrollIndicator:NO];
    [self.contentView addSubview:airScrollView];
    
    selectedBlocks = [[NSMutableArray alloc] init];
    selectedView = [[UIView alloc] initWithFrame:CGRectMake((320.0 - (15.0*self.airs.count-5))/2, 390 + (self.contentView.frame.size.height - 390 - 10)/2, 15.0*self.airs.count-5, 10.0)];
    [selectedView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:selectedView];
    
    for (int i = 0; i < self.airs.count; i++) {
        SHAirView *airView = [[SHAirView alloc] initWithFrame:CGRectMake(320*i, 0.0, 320.0, 390.0) andModel:[self.airs objectAtIndex:i]];
        [airScrollView addSubview:airView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*15.0, 0.0, 10.0, 10.0)];
        if (i == 0) {
            [imageView setImage:[UIImage imageNamed:@"selected"]];
        } else {
            [imageView setImage:[UIImage imageNamed:@"unselected"]];
        }
        [selectedBlocks addObject:imageView];
        [selectedView addSubview:imageView];
    }
}

- (void)onSettingButtonClicked
{
    SHSettingsViewController *settingController = [[SHSettingsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPage = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    for (int i = 0; i < self.airs.count; i++) {
        if (i == currentPage) {
            [[selectedBlocks objectAtIndex:i] setImage:[UIImage imageNamed:@"selected"]];
        } else {
            [[selectedBlocks objectAtIndex:i] setImage:[UIImage imageNamed:@"unselected"]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
