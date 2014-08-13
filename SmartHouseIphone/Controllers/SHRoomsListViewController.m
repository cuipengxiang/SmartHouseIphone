//
//  SHRoomsListViewController.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-3.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHRoomsListViewController.h"
#import "SHRoomCell.h"
#import "SHSettingsViewController.h"
#import "SHRoomMainViewController.h"

@interface SHRoomsListViewController ()

@end

@implementation SHRoomsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [super viewDidLoad];
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_setup"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(onSettingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    NSArray *rightButtons = @[self.networkStateButton, settingBarButton];
    [self.navigationItem setRightBarButtonItems:rightButtons];
    
    [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10.0, 10.0, 300.0, self.contentView.frame.size.height - 20.0)];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_bg_iphone"]]];
    [self.tableView setBounces:NO];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView reloadData];
    [self.contentView addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)onSettingButtonClicked
{
    SHSettingsViewController *settingController = [[SHSettingsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:settingController animated:YES];
}

#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SHRoomMainViewController *controller = [[SHRoomMainViewController alloc] initWithNibName:nil bundle:nil];
    controller.model = [self.appDelegate.models objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:controller animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 0.0;
}


#pragma mark UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"RoomsTableCell";
    SHRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[SHRoomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *roomName = [[self.appDelegate.models objectAtIndex:indexPath.row] name];
    [cell.textLabel setText:roomName];
    cell.data = [self.appDelegate.models objectAtIndex:indexPath.row];
    [cell.textLabel setFont:[UIFont boldSystemFontOfSize:18.0]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    
    if (indexPath.row == 0) {
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.appDelegate.models.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
