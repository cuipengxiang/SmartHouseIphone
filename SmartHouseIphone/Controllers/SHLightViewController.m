//
//  SHLightViewController.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHLightViewController.h"
#import "SHLightView.h"
#import "SHSettingsViewController.h"

@interface SHLightViewController ()

@end

@implementation SHLightViewController

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
    
    lightScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 380.0)];
    [lightScrollView setContentSize:CGSizeMake(320.0*self.lights.count, 380.0)];
    [lightScrollView setBackgroundColor:[UIColor clearColor]];
    [lightScrollView setPagingEnabled:YES];
    [lightScrollView setDelegate:self];
    [lightScrollView setShowsHorizontalScrollIndicator:NO];
    [self.contentView addSubview:lightScrollView];
    
    selectedBlocks = [[NSMutableArray alloc] init];
    selectedView = [[UIView alloc] initWithFrame:CGRectMake((320.0 - (15.0*self.lights.count-5))/2, 380 + (self.contentView.frame.size.height - 380 - 10)/2, 15.0*self.lights.count-5, 10.0)];
    [selectedView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:selectedView];
    
    for (int i = 0; i < self.lights.count; i++) {
        SHLightView *lightView = [[SHLightView alloc] initWithFrame:CGRectMake(320*i, 0.0, 320.0, 380.0) andModel:[self.lights objectAtIndex:i]];
        [lightScrollView addSubview:lightView];
        
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int currentPage = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    for (int i = 0; i < self.lights.count; i++) {
        if (i == currentPage) {
            [[selectedBlocks objectAtIndex:i] setImage:[UIImage imageNamed:@"selected"]];
        } else {
            [[selectedBlocks objectAtIndex:i] setImage:[UIImage imageNamed:@"unselected"]];
        }
    }
}

- (void)onSettingButtonClicked
{
    SHSettingsViewController *settingController = [[SHSettingsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
