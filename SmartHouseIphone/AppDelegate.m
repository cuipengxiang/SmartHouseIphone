//
//  AppDelegate.m
//  SmartHouse_iphone
//
//  Created by Roc on 14-7-30.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "AppDelegate.h"
#import "SHActiveViewController.h"
#import "SHConfigFile.h"
#import "SHLoginViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.socketQueue = dispatch_queue_create("socketQueueAppDelegate", NULL);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    SHConfigFile *file = [[SHConfigFile alloc] init];
    [file readFile];
    NSString *localHost = [[NSUserDefaults standardUserDefaults] objectForKey:@"host"];
    if (localHost) {
        if ([localHost isEqualToString:self.host1]) {
            self.host = self.host1;
        } else if ([localHost isEqualToString:self.host2]){
            self.host = self.host2;
        }
    }
    
    self.currentNetworkState = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.socketQueue];
        [socket connectToHost:self.host onPort:self.port withTimeout:0.5 error:&error];
    });
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first"]) {
        SHActiveViewController *mainController = [[SHActiveViewController alloc] init];
        self.navigation = [[UINavigationController alloc] initWithRootViewController:mainController];
        self.window.rootViewController = self.navigation;
    } else {
        SHLoginViewController *mainController = [[SHLoginViewController alloc] init];
        self.navigation = [[UINavigationController alloc] initWithRootViewController:mainController];
        self.window.rootViewController = self.navigation;
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark Socket Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    if (sock.command&&sock.command.length > 0) {
        [sock writeData:[sock.command dataUsingEncoding:NSUTF8StringEncoding] withTimeout:2 tag:0];
    } else {
        [sock disconnect];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    [sock readDataToData:[GCDAsyncSocket CRLFData] withTimeout:1 tag:0];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    [sock disconnect];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err) {
        self.currentNetworkState = NO;
    } else {
        self.currentNetworkState = YES;
    }
}

@end
