//
//  SHLightViewController.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHLightViewController.h"
#import "SHSettingsViewController.h"

@interface SHLightViewController ()

@end

@implementation SHLightViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.socketQueue = dispatch_queue_create("socketQueueLight", NULL);
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
    
    self.lightViews = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.lights.count; i++) {
        SHLightView *lightView = [[SHLightView alloc] initWithFrame:CGRectMake(320*i, 0.0, 320.0, 380.0) andModel:[self.lights objectAtIndex:i]];
        [lightScrollView addSubview:lightView];
        [self.lightViews addObject:lightView];
        
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.currentPage = floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    for (int i = 0; i < self.lights.count; i++) {
        if (i == self.currentPage) {
            [[selectedBlocks objectAtIndex:i] setImage:[UIImage imageNamed:@"selected"]];
        } else {
            [[selectedBlocks objectAtIndex:i] setImage:[UIImage imageNamed:@"unselected"]];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self queryMode:nil];
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
    
    if (self.lightQueryThread) {
        self.lightQueryThread = nil;
    }
    [self queryMode:nil];
    /*
    self.lightQueryThread = [[NSThread alloc] initWithTarget:self selector:@selector(queryMode:) object:nil];
    if (![self.lightQueryThread isExecuting]) {
        [self.lightQueryThread start];
    }
     */
}

- (void)queryMode:(NSThread *)thread
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
        socket.command = [NSString stringWithFormat:@"*requestchannellevel %@,%@\r\n", [[self.lights objectAtIndex:self.currentPage] channel], [[self.lights objectAtIndex:self.currentPage] area]];
        socket.type = self.currentPage;
        [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
    });
    /*
    while ([[NSThread currentThread] isCancelled] == NO) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
            NSError *error;
            GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
            socket.command = [NSString stringWithFormat:@"*requestchannellevel %@,%@\r\n", [[self.lights objectAtIndex:self.currentPage] channel], [[self.lights objectAtIndex:self.currentPage] area]];
            socket.type = self.currentPage;
            [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
        });
        sleep(4);
    }
    [NSThread exit];
     */
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.lightQueryThread cancel];
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
        
        // 刚发完清零
        [self.appDelegate connectSucc];
        //
        
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
    
    NSArray *arrayTemp = [msg arrayOfCaptureComponentsMatchedByRegex:@"T\\[(.+?)\\]"];
    if ((arrayTemp)&&(arrayTemp.count > 0)) {
        int brightness = [[[arrayTemp objectAtIndex:0] objectAtIndex:1] integerValue]/10;
        if ([[[arrayTemp objectAtIndex:0] objectAtIndex:1] integerValue]%10 != 0 && brightness < 10) {
            brightness++;
        }
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            if (sock.type >= 0) {
                [[self.lightViews objectAtIndex:sock.type] setLightDegreeWithoutSendingCommond:brightness];
            }
        });
    }
    [sock disconnect];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"灯的错误 %@", err);
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

}

@end
