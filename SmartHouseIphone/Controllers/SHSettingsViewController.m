//
//  SHSettingsViewController.m
//  SmartHouseIphone
//
//  Created by Roc on 14-8-12.
//  Copyright (c) 2014年 Roc. All rights reserved.
//

#import "SHSettingsViewController.h"
#import "AFNetworking.h"
#import "SHActiveViewController.h"

@interface SHSettingsViewController () <UITextFieldDelegate, NSURLConnectionDelegate, NSURLConnectionDownloadDelegate, NSURLConnectionDataDelegate>
{
    NSMutableData *_responseData;
}

@property (strong, nonatomic) UIButton *backButtonMask;

@property (strong, nonatomic) UITextField *serverTextField; // 配置文件服务器ip地址
@property (strong, nonatomic) UIButton *activeButton; // 激活按钮

@end

@implementation SHSettingsViewController

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
    
    self.settingbox = [[UIView alloc] init];
    [self.settingbox setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sys_setup_box"]]];
    [self.settingbox setFrame:CGRectMake(42.0, 20.0, 236.0, 128.0)];
    
    UILabel *boxTitle = [[UILabel alloc] init];
    [boxTitle setText:@"系统设置"];
    [boxTitle setTextColor:[UIColor colorWithRed:0.694 green:0.278 blue:0.020 alpha:1.0]];
    [boxTitle setFont:[UIFont boldSystemFontOfSize:16.0]];
    [boxTitle setTextAlignment:NSTextAlignmentCenter];
    [boxTitle sizeToFit];
    [boxTitle setFrame:CGRectMake((236.0-boxTitle.frame.size.width)/2, 13.0, boxTitle.frame.size.width, boxTitle.frame.size.height)];
    [boxTitle setBackgroundColor:[UIColor clearColor]];
    [self.settingbox addSubview:boxTitle];
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(201.0, 13.0, 20.0, 20.0)];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"btn_close_normal"] forState:UIControlStateNormal];
    [self.backButton setBackgroundImage:[UIImage imageNamed:@"btn_close_pressed"] forState:UIControlStateHighlighted];
    [self.backButton addTarget:self action:@selector(onBackButtonClick) forControlEvents:UIControlEventTouchDown];
    [self.settingbox addSubview:self.backButton];
    
    self.backButtonMask = [[UIButton alloc] initWithFrame:CGRectMake(191, 3, 40, 40)];
    [self.backButtonMask addTarget:self action:@selector(onBackButtonClick) forControlEvents:UIControlEventTouchDown];
    [self.settingbox addSubview:self.backButtonMask];
    
    
    self.password = [[UIButton alloc] initWithFrame:CGRectMake(18.0, 70.0, 200.0, 29.0)];
    [self.password setBackgroundImage:[UIImage imageNamed:@"bg_setup_line"] forState:UIControlStateNormal];
    [self.password setImage:[UIImage imageNamed:@"bg_arrow"] forState:UIControlStateNormal];
    [self.password setImageEdgeInsets:UIEdgeInsetsMake(0.0, 175.0, 0.0, 0.0)];
    [self.password addTarget:self action:@selector(onPasswordClick) forControlEvents:UIControlEventTouchUpInside];
    [self.password setTitle:@"密码设置" forState:UIControlStateNormal];
    [self.password setTitleColor:[UIColor colorWithRed:0.804 green:0.748 blue:0.714 alpha:1.0] forState:UIControlStateNormal];
    [self.password.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [self.password setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -120.0, 0.0, 0.0)];
    //[self.settingbox addSubview:self.password];
    //self.network = [[UIButton alloc] initWithFrame:CGRectMake(18.0, 110.0, 200.0, 29.0)];
    self.network = [[UIButton alloc] initWithFrame:CGRectMake(18.0, 73.0, 200.0, 29.0)];
    [self.network setBackgroundImage:[UIImage imageNamed:@"bg_setup_line"] forState:UIControlStateNormal];
    if ([self.appDelegate.host isEqualToString:self.appDelegate.host1]) {
        netImageName = @"btn_switch_2";
    } else if ([self.appDelegate.host isEqualToString:self.appDelegate.host2]){
        netImageName = @"btn_switch_1";
    }
    [self.network setImage:[UIImage imageNamed:netImageName] forState:UIControlStateNormal];
    [self.network setImageEdgeInsets:UIEdgeInsetsMake(0.0, 110.0, 0.0, 0.0)];
    [self.network addTarget:self action:@selector(onNetworkClick) forControlEvents:UIControlEventTouchUpInside];
    [self.network setTitle:@"联网设置" forState:UIControlStateNormal];
    [self.network setTitleColor:[UIColor colorWithRed:0.804 green:0.748 blue:0.714 alpha:1.0] forState:UIControlStateNormal];
    [self.network.titleLabel setFont:[UIFont boldSystemFontOfSize:14.0]];
    [self.network setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -186.0, 0.0, 0.0)];
    [self.settingbox addSubview:self.network];
    
    [self.contentView addSubview:self.settingbox];
    
    
//    
//    self.settingbox = [[UIView alloc] init];
//    [self.settingbox setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"sys_setup_box"]]];
//    [self.settingbox setFrame:CGRectMake(42.0, 60.0, 236.0, 128.0)];
    

    self.serverTextField = [[UITextField alloc] init];
    self.serverTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.serverTextField.layer.borderWidth = 0.2;
    self.serverTextField.returnKeyType = UIReturnKeyDone;
    self.serverTextField.delegate = self;
    self.serverTextField.frame = CGRectMake(42, 155, 236, 40);
    self.serverTextField.placeholder = @"服务器地址";
    [self.contentView addSubview:self.serverTextField];
    
    self.activeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.activeButton setTitle:@"激活" forState:UIControlStateNormal];
    [self.activeButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.activeButton addTarget:self action:@selector(active) forControlEvents:UIControlEventTouchUpInside];
    [self.activeButton setFrame:CGRectMake(42, 200, 236, 30)];
    [self.contentView addSubview:self.activeButton];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first"]) {

        // 没激活的情况
        

    } else {

        // 已激活的情况
        
        self.activeButton.hidden = YES;
        self.activeButton.enabled = NO;
    
    }
}

- (void)onBackButtonClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onPasswordClick
{
    SHPassWordSettingViewController *controller = [[SHPassWordSettingViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)onNetworkClick
{
    if ([self.appDelegate.host isEqualToString:self.appDelegate.host2]) {
        self.appDelegate.host = self.appDelegate.host1;
        netImageName = @"btn_switch_2";
    } else if ([self.appDelegate.host isEqualToString:self.appDelegate.host1]){
        self.appDelegate.host = self.appDelegate.host2;
        netImageName = @"btn_switch_1";
    }
    [self.network setImage:[UIImage imageNamed:netImageName] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setObject:self.appDelegate.host forKey:@"host"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self hideNavigationBar];
}

- (void)hideNavigationBar
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.contentView setFrame:CGRectMake(0.0, 0.0, 320.0, App_Height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    
    if ([self.serverTextField isFirstResponder]) {
        [self.serverTextField resignFirstResponder];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@:9999/test.xml", textField.text]]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [conn start];
    
//    AFHTTPRequestOperation *manager = [AFHTTPRequestOperationManager manager];
////    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/rss+xml"];
////    [manager setResponseSerializer:[AFXMLParserResponseSerializer new]];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager GET:[NSString stringWithFormat:@"http://%@:9999/test.xml", textField.text] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSLog(@"配置文件的内容是: %@", responseObject);
//
//        //
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"配置文件下载成功"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil, nil];
//        [alertView show];
//        
//        
//        
//        // 如果有就删除
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//        NSString *documentDirectory = [paths objectAtIndex:0];
//        NSString *file = [documentDirectory stringByAppendingPathComponent:@"test.xml"];
//        NSData *data = [NSData dataWithContentsOfFile:file];
//        
//        NSFileManager *manager = [NSFileManager defaultManager];
//        if ([manager fileExistsAtPath:file]) {
//            [manager removeItemAtPath:file error:nil];
//        }
//        
//        [manager createFileAtPath:file contents:responseObject attributes:nil];
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//        
//        //
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
//                                                            message:@"配置文件下载失败"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"确定"
//                                                  otherButtonTitles:nil, nil];
//        [alertView show];
//    }];
    
    
    
    return YES;
}

#pragma mark NSURLConnection Delegate Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [_responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now

    //
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"配置文件下载成功"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];

    // 如果有就删除
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    NSString *file = [documentDirectory stringByAppendingPathComponent:@"test.xml"];
    NSData *data = [NSData dataWithContentsOfFile:file];

    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:file]) {
        [manager removeItemAtPath:file error:nil];
    }

    [manager createFileAtPath:file contents:_responseData attributes:nil];

    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"配置文件下载失败"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
    [alertView show];
}

// 激活
- (void)active
{
    SHActiveViewController *activeViewController = [[SHActiveViewController alloc] init];
    [self.navigationController pushViewController:activeViewController animated:YES];
}

@end
