//
//  AppDelegate.h
//  SmartHouse_iphone
//
//  Created by Roc on 14-7-30.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, GCDAsyncSocketDelegate>

@property (strong, nonatomic) NSString *host;
@property (strong, nonatomic) NSString *host1;
@property (strong, nonatomic) NSString *host2;
@property (nonatomic)int16_t port;
@property (strong, nonatomic) NSMutableArray *models;
@property (nonatomic) NSInteger connectSuccessTime; // 失败一次加个数成功一次清0

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigation;
@property (nonatomic)dispatch_queue_t socketQueue;

@property (nonatomic)BOOL currentNetworkState;



- (void)connectFail;
- (void)connectSucc;
@property (nonatomic) BOOL connect;

@end
