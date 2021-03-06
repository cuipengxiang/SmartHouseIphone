//
//  SHRoomsListViewController.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-3.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHRoomsListViewController.h"
#import "SHRoomCell.h"
#import "SHRoomMainViewController.h"
#import "SHSettingsViewController.h"

#define ROOM_BUTTON_BASE_TAG 10000

@interface SHRoomsListViewController ()

@end

@implementation SHRoomsListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.socketQueue = dispatch_queue_create("socketQueueRoomList", NULL);
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNavigationTitle:@"房间选择"];
    
    UIButton *settingButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [settingButton setBackgroundImage:[UIImage imageNamed:@"btn_setup"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(onSettingButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingBarButton = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    NSArray *rightButtons = @[self.networkStateButton, settingBarButton];
    [self.navigationItem setRightBarButtonItems:rightButtons];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 30.0, 30.0)];
    [leftButton setImage:nil forState:UIControlStateNormal];
    [leftButton setImage:nil forState:UIControlStateHighlighted];
    [leftButton addTarget:self action:@selector(onBackClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationItem setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:leftButton]];
    
    [self.contentView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]]];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10.0, 10.0, 300.0, self.contentView.frame.size.height - 20.0)];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setBackgroundView:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_bg_iphone"]]];
    [self.tableView setBounces:NO];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView reloadData];
    //[self.contentView addSubview:self.tableView];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0f, 10.0f, self.view.frame.size.width, self.contentView.frame.size.height - 20.0f)];
    [self.scrollView setBackgroundColor:[UIColor clearColor]];
    [self setupRoomButtons];
    
}

- (void)onBackClick
{
    
}

- (void)setupRoomButtons
{
    [self.scrollView setContentSize:CGSizeMake(self.scrollView.frame.size.width, (self.appDelegate.models.count + 1)/2*100 + 60.0)];
    for (int i = 0; i < self.appDelegate.models.count; i++) {
        NSString *roomName = [[self.appDelegate.models objectAtIndex:i] name];
        UIButton *roomButton = [[UIButton alloc] init];
        if ((i/2)%2 == 0) {
            roomButton.frame = CGRectMake(20.0 + i%2*130.0, 40.0 + i/2*100.0, 119.0, 81.0);
        } else {
            roomButton.frame = CGRectMake(self.contentView.frame.size.width - 260.0 + i%2*130.0, 40.0 + i/2*100.0, 119.0, 81.0);
        }
        [roomButton setTitle:roomName forState:UIControlStateNormal];
        [roomButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [roomButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"room_btn_%d", i%6]] forState:UIControlStateNormal];
        [roomButton setTag:i + ROOM_BUTTON_BASE_TAG];
        [roomButton addTarget:self action:@selector(onRoomBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        
        NSLog(@"roomButton === %@", roomButton);
        
        [self.scrollView addSubview:roomButton];
    }
    
    [self.contentView addSubview:self.scrollView];
}

- (void)onRoomBtnClicked:(UIButton *)button
{
    int index = button.tag - ROOM_BUTTON_BASE_TAG;
    SHRoomMainViewController *controller = [[SHRoomMainViewController alloc] initWithNibName:nil bundle:nil];
    controller.model = [self.appDelegate.models objectAtIndex:index];
    [controller setNetworkState:self.appDelegate.currentNetworkState];
    [controller setNavigationTitle:[[self.appDelegate.models objectAtIndex:index] name]];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
    [self setNetworkState:self.appDelegate.currentNetworkState];
    
    if (self.roomListQueryThread) {
        self.roomListQueryThread = nil;
    }
    self.roomListQueryThread = [[NSThread alloc] initWithTarget:self selector:@selector(queryMode:) object:nil];
    if (![self.roomListQueryThread isExecuting]) {
        [self.roomListQueryThread start];
    }
}

- (void)queryMode:(NSThread *)thread
{
    while ([[NSThread currentThread] isCancelled] == NO) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
            NSError *error;
            GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
            [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:1.0 error:&error];
        });
        [NSThread sleepForTimeInterval:3];
    }
    [NSThread exit];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [self.roomListQueryThread cancel];
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
    [controller setNetworkState:self.appDelegate.currentNetworkState];
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

#pragma mark Socket

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    //[sock writeData:[sock.command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3.0 tag:0];
    [sock disconnect];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    //[sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err) {
        [self setNetworkState:NO];
        [self.appDelegate connectFail];
    } else {
        [self setNetworkState:YES];
        [self.appDelegate connectSucc];
    }
    sock = nil;
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    [sock disconnect];
    return 0.0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
