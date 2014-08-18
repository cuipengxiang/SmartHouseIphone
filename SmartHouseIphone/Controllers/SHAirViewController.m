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
        self.socketQueue = dispatch_queue_create("socketQueueAir", NULL);
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
    
    self.airViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.airs.count; i++) {
        SHAirView *airView = [[SHAirView alloc] initWithFrame:CGRectMake(320*i, 0.0, 320.0, 390.0) andModel:[self.airs objectAtIndex:i]];
        [airScrollView addSubview:airView];
        [self.airViews addObject:airView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*15.0, 0.0, 10.0, 10.0)];
        if (i == 0) {
            [imageView setImage:[UIImage imageNamed:@"selected"]];
        } else {
            [imageView setImage:[UIImage imageNamed:@"unselected"]];
        }
        [selectedBlocks addObject:imageView];
        [selectedView addSubview:imageView];
    }
    self.currentPage = 0;
}

- (void)onSettingButtonClicked
{
    SHSettingsViewController *settingController = [[SHSettingsViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:settingController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.currentPage = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    for (int i = 0; i < self.airs.count; i++) {
        if (i == self.currentPage) {
            [[selectedBlocks objectAtIndex:i] setImage:[UIImage imageNamed:@"selected"]];
        } else {
            [[selectedBlocks objectAtIndex:i] setImage:[UIImage imageNamed:@"unselected"]];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
    [self setNetworkState:self.appDelegate.currentNetworkState];
    
    if (self.airQueryThread) {
        self.airQueryThread = nil;
    }
    self.airQueryThread = [[NSThread alloc] initWithTarget:self selector:@selector(queryMode:) object:nil];
    if (![self.airQueryThread isExecuting]) {
        [self.airQueryThread start];
    }
}

- (void)queryMode:(NSThread *)thread
{
    while ([[NSThread currentThread] isCancelled] == NO) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
            NSError *error;
            GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
            socket.command = [NSString stringWithFormat:@"*aircreply %@,%@\r\n", [[self.airs objectAtIndex:self.currentPage] mainaddr], [[self.airs objectAtIndex:self.currentPage] secondaryaddr]];
            socket.type = self.currentPage;
                [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
        });
    sleep(5);
    }
    [NSThread exit];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.airQueryThread cancel];
}

#pragma mark Socket

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    if (sock.command) {
        [sock writeData:[sock.command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:3.0 tag:0];
    } else {
        [sock disconnect];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    if (sock.command) {
        [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:1 tag:0];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    if (sock.skip == -1) {
        sock.skip = 0;
        [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:1 tag:0];
        return;
    }
    NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];
    NSString *msg = [[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding];
    NSArray *arrayState = [msg arrayOfCaptureComponentsMatchedByRegex:@"State\\[(.+?)\\]"];
    NSArray *arrayMode = [msg arrayOfCaptureComponentsMatchedByRegex:@"Mode\\[(.+?)\\]"];
    NSArray *arraySpeed = [msg arrayOfCaptureComponentsMatchedByRegex:@"Size\\[(.+?)\\]"];
    NSArray *arrayTemp = [msg arrayOfCaptureComponentsMatchedByRegex:@"Temp\\[(.+?)\\]"];
    NSMutableString *status = [[NSMutableString alloc] initWithString:@""];
    NSString *isOnNow;
    NSString *currentSpeed;
    NSString *currentMode;
    NSString *currentTemp;
    if ((arrayState)&&(arrayState.count > 0)) {
        isOnNow = [[arrayState objectAtIndex:0] objectAtIndex:1];
        [status appendString:isOnNow];
    }
    if ((arrayMode)&&(arrayMode.count > 0)) {
        currentMode = [[arrayMode objectAtIndex:0] objectAtIndex:1];
        [status appendFormat:@"|%@", currentMode];
    }
    if ((arraySpeed)&&(arraySpeed.count > 0)) {
        currentSpeed = [[arraySpeed objectAtIndex:0] objectAtIndex:1];
        [status appendFormat:@"|%@", currentSpeed];
    }
    if ((arrayTemp)&&(arrayTemp.count > 0)) {
        currentTemp = [[arrayTemp objectAtIndex:0] objectAtIndex:1];
        [status appendFormat:@"|%@", currentTemp];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (status.length > 0) {
            [[self.airViews objectAtIndex:sock.type] setCurrentStatus:status];
        }
    });
    
    [sock disconnect];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err) {
        [self setNetworkState:NO];
    } else {
        [self setNetworkState:YES];
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
