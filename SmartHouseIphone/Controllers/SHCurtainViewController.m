//
//  SHCurtainViewController.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHCurtainViewController.h"
#import "SHSettingsViewController.h"
#import "SHCurtainView.h"

@interface SHCurtainViewController ()

@end

@implementation SHCurtainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.socketQueue = dispatch_queue_create("socketQueueCurtain", NULL);
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
    
    curtainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 380.0)];
    [curtainScrollView setContentSize:CGSizeMake(320.0*self.curtains.count, 380.0)];
    [curtainScrollView setBackgroundColor:[UIColor clearColor]];
    [curtainScrollView setPagingEnabled:YES];
    [curtainScrollView setDelegate:self];
    [curtainScrollView setShowsHorizontalScrollIndicator:NO];
    [self.contentView addSubview:curtainScrollView];
    
    selectedBlocks = [[NSMutableArray alloc] init];
    selectedView = [[UIView alloc] initWithFrame:CGRectMake((320.0 - (15.0*self.curtains.count-5))/2, 380 + (self.contentView.frame.size.height - 380 - 10)/2, 15.0*self.curtains.count-5, 10.0)];
    [selectedView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:selectedView];
    
    for (int i = 0; i < self.curtains.count; i++) {
        SHCurtainView *curtainView = [[SHCurtainView alloc] initWithFrame:CGRectMake(320*i, 0.0, 320.0, 380.0) andModel:[self.curtains objectAtIndex:i]];
        [curtainScrollView addSubview:curtainView];
        
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
    for (int i = 0; i < self.curtains.count; i++) {
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

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:NO];
    
    [self setNetworkState:self.appDelegate.currentNetworkState];
    
    if (self.curtainQueryThread) {
        self.curtainQueryThread = nil;
    }
    self.curtainQueryThread = [[NSThread alloc] initWithTarget:self selector:@selector(queryMode:) object:nil];
    if (![self.curtainQueryThread isExecuting]) {
        [self.curtainQueryThread start];
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
    [self.curtainQueryThread cancel];
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
