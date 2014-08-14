//
//  SHLightViewController.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHLightViewController.h"
#import "SHLightView.h"

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
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 400.0)];
    [scrollView setContentSize:CGSizeMake(320.0*self.lights.count, 400.0)];
    [scrollView setBackgroundColor:[UIColor clearColor]];
    [scrollView setPagingEnabled:YES];
    [scrollView setDelegate:self];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [self.contentView addSubview:scrollView];
    
    for (int i = 0; i < self.lights.count; i++) {
        SHLightView *lightView = [[SHLightView alloc] initWithFrame:CGRectMake(320*i, 0.0, 320.0, 400.0) andModel:[self.lights objectAtIndex:i]];
        [scrollView addSubview:lightView];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
