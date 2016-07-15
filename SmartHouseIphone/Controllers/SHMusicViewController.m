//
//  SHMusicViewController.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-13.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHMusicViewController.h"
#import "SHSettingsViewController.h"
#import "SHMusicView.h"
#import "SHMusicViewNew.h"

@interface SHMusicViewController ()

@end

@implementation SHMusicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.socketQueue = dispatch_queue_create("socketQueueMusic", NULL);
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
    
    musicScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 480.0)];
    [musicScrollView setContentSize:CGSizeMake(320.0*self.musics.count, 480.0)];
    [musicScrollView setBackgroundColor:[UIColor clearColor]];
    [musicScrollView setPagingEnabled:YES];
    [musicScrollView setDelegate:self];
    [musicScrollView setShowsHorizontalScrollIndicator:NO];
    [self.contentView addSubview:musicScrollView];
    
    selectedBlocks = [[NSMutableArray alloc] init];
    selectedView = [[UIView alloc] initWithFrame:CGRectMake((320.0 - (15.0*self.musics.count-5))/2, 480 + (self.contentView.frame.size.height - 480 - 10)/2, 15.0*self.musics.count-5, 10.0)];
    [selectedView setBackgroundColor:[UIColor clearColor]];
    [self.contentView addSubview:selectedView];
    
    for (int i = 0; i < self.musics.count; i++) {
        /*
        SHMusicView *musicView = [[SHMusicView alloc] initWithFrame:CGRectMake(320*i, 0.0, 320.0, 380.0) andModel:[self.musics objectAtIndex:i]];
        [musicScrollView addSubview:musicView];
        */
        SHMusicViewNew *musicView = [[SHMusicViewNew alloc] initWithFrame:CGRectMake(320*i+(musicScrollView.frame.size.width - 295.0)/2, (musicScrollView.frame.size.height - 419.0)/2 - 5.0, 295.0f, 419.0f) andModel:[self.musics objectAtIndex:i]];
        [musicScrollView addSubview:musicView];
        
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
    for (int i = 0; i < self.musics.count; i++) {
        if (i == currentPage) {
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
    
    if (self.musicQueryThread) {
        self.musicQueryThread = nil;
    }
    self.musicQueryThread = [[NSThread alloc] initWithTarget:self selector:@selector(queryMode:) object:nil];
    if (![self.musicQueryThread isExecuting]) {
        [self.musicQueryThread start];
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
    [self.musicQueryThread cancel];
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
    
    // 刚发完清零
    [self.appDelegate connectSucc];
    //
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
