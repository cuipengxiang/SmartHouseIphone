//
//  SHMusicViewNew.m
//  SmartHouseIphone
//
//  Created by Roc on 15/3/3.
//  Copyright (c) 2015年 Roc. All rights reserved.
//

#import "SHMusicViewNew.h"
#import "SHMusicButtonModel.h"
#import "UIImage+ImageWithColor.h"

@interface SHMusicViewNew ()

@property (strong, nonatomic) UIButton *onButton;
@property (strong, nonatomic) UIButton *offButton;

@property (nonatomic) NSInteger sourceNumber;

@end

@implementation SHMusicViewNew

- (id)initWithFrame:(CGRect)frame andModel:(SHMusicModel *)model
{
    self = [super initWithFrame:frame];
    if (self) {
        self.model = model;
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        self.sourceNumber = 99;
    }
    return self;
}

- (void)layoutSubviews
{
    [self setBackgroundColor:[UIColor clearColor]];
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height)];
    [bgView setImage:[UIImage imageNamed:@"music_bg"]];
    [self addSubview:bgView];
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(52.0, 20.0, 191.0, 37.0)];
    [titleView setImage:[UIImage imageNamed:@"title_bg"]];
    [self addSubview:titleView];
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 191.0, 37.0)];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:self.model.name];
    [titleView addSubview:titleLabel];
    
    UIImageView *control_bg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"musice_ctrl_bg"]];
    [control_bg setFrame:CGRectMake((self.frame.size.width - control_bg.frame.size.width)/2, 122.0, control_bg.frame.size.width, control_bg.frame.size.height)];
    [control_bg setUserInteractionEnabled:YES];
    [self addSubview:control_bg];
    
    volHigherButton = [[UIButton alloc] initWithFrame:CGRectMake(36.0, 4.0, 123.0, 59.0)];
    [volHigherButton setBackgroundImage:[UIImage imageNamed:@"btn_v+"] forState:UIControlStateNormal];
    [volHigherButton setBackgroundImage:[UIImage imageNamed:@"btn_v+_pressed"] forState:UIControlStateHighlighted];
    [volHigherButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [control_bg addSubview:volHigherButton];
    
    volLowerButton = [[UIButton alloc] initWithFrame:CGRectMake(36.0, 132.0, 123.0, 59.0)];
    [volLowerButton setBackgroundImage:[UIImage imageNamed:@"btn_v-"] forState:UIControlStateNormal];
    [volLowerButton setBackgroundImage:[UIImage imageNamed:@"btn_v-_pressed"] forState:UIControlStateHighlighted];
    [volLowerButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [control_bg addSubview:volLowerButton];
    
    preButton = [[UIButton alloc] initWithFrame:CGRectMake(4.0, 36.0, 59.0, 123.0)];
    [preButton setBackgroundImage:[UIImage imageNamed:@"btn_prev"] forState:UIControlStateNormal];
    [preButton setBackgroundImage:[UIImage imageNamed:@"btn_prev_pressed"] forState:UIControlStateHighlighted];
    [preButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [control_bg addSubview:preButton];
    
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(132.0, 36.0, 59.0, 123.0)];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"btn_next"] forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"btn_next_pressed"] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [control_bg addSubview:nextButton];
    
    startButton = [[UIButton alloc] initWithFrame:CGRectMake(57.5, 57.5, 80.0, 80.0)];
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
    [startButton setBackgroundImage:[UIImage imageNamed:@"btn_play_pressed"] forState:UIControlStateHighlighted];
    [startButton setTag:0];
    [startButton addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [control_bg addSubview:startButton];
    
    sourceButtons = [[NSMutableArray alloc] init];
    for (int i = 0; i < self.model.sources.count; i++) {
        UIButton *sourceButton = [[UIButton alloc] initWithFrame:CGRectMake(18.0 + 66.0 * i, 335.0, 61.0, 52.0)];
        [sourceButton setBackgroundImage:[UIImage imageNamed:@"type_btn_normal"] forState:UIControlStateNormal];
        [sourceButton setBackgroundImage:[UIImage imageNamed:@"type_btn_selected"] forState:UIControlStateHighlighted];
        [sourceButton setBackgroundImage:[UIImage imageNamed:@"type_btn_selected"] forState:UIControlStateSelected];
        [sourceButton setTag:20000 + i];
        [sourceButton setTitle:[self.model.sources objectAtIndex:i] forState:UIControlStateNormal];
        [sourceButton setTitleColor:[UIColor colorWithRed:0.533 green:0.533 blue:0.533 alpha:1] forState:UIControlStateNormal];
        [sourceButton setTitleColor:[UIColor colorWithRed:0.000 green:0.533 blue:0.984 alpha:1] forState:UIControlStateHighlighted];
        [sourceButton setTitleColor:[UIColor colorWithRed:0.000 green:0.533 blue:0.984 alpha:1] forState:UIControlStateSelected];
        [sourceButton setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];
        [sourceButton addTarget:self action:@selector(onSourceClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sourceButton];
        [sourceButtons addObject:sourceButton];
    }
    
//    on_off = [[UIButton alloc] initWithFrame:CGRectMake(106.5, 73.0, 82.0, 29.0)];
//    [on_off setImage:[UIImage imageNamed:@"btn_switch_off"] forState:UIControlStateNormal];
//    [on_off setTag:0];
//    [on_off addTarget:self action:@selector(onButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:on_off];
    
    self.onButton = [[UIButton alloc] initWithFrame:CGRectMake(106.5, 73.0, 40, 40)];
    [self.onButton setTitle:@"开" forState:UIControlStateNormal];
    [self.onButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.onButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:213/255.0 green:213/255.0 blue:213.0/255.0 alpha:1]]  forState:UIControlStateNormal];
    [self.onButton addTarget:self action:@selector(musicOnButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.onButton];

    self.offButton = [[UIButton alloc] initWithFrame:CGRectMake(150, 73, 40, 40)];
    [self.offButton setTitle:@"关" forState:UIControlStateNormal];
    [self.offButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.offButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:213/255.0 green:213/255.0 blue:213.0/255.0 alpha:1]] forState:UIControlStateNormal];
    [self.offButton addTarget:self action:@selector(musicOffButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.offButton];
}

- (void)musicOnButtonClick
{
    NSString *cmdString;
    if (self.sourceNumber == 99) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"请选择音源"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    cmdString = [NSString stringWithFormat:@"*audioc %@,%@,0,0,%d", self.model.area, self.model.channel, self.sourceNumber];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self.appDelegate delegateQueue:self.appDelegate.socketQueue];
        socket.command = [NSString stringWithFormat:@"%@\r\n", cmdString];
        [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
    });
}

- (void)musicOffButtonClick
{
    NSString *cmdString;
    if (self.sourceNumber == 99) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"请选择音源"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        return;
    }
    cmdString = [NSString stringWithFormat:@"*audioc %@,%@,2,0,%d", self.model.area, self.model.channel, self.sourceNumber];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self.appDelegate delegateQueue:self.appDelegate.socketQueue];
        socket.command = [NSString stringWithFormat:@"%@\r\n", cmdString];
        [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
    });
}

- (void)onSourceClicked:(UIButton *)button
{
    int index = button.tag - 20000;
    for (int i = 0; i < sourceButtons.count; i++) {
        [[sourceButtons objectAtIndex:i] setSelected:NO];
    }
    [[sourceButtons objectAtIndex:index] setSelected:YES];
    [self onButtonClicked:button];
}

- (void)onButtonClicked:(UIButton *)button
{

    
    NSString *cmdString;
    if (button == on_off) {
        if (button.tag == 1) {
            [on_off setTag:0];
            [on_off setImage:[UIImage imageNamed:@"btn_switch_off"] forState:UIControlStateNormal];
            cmdString = [NSString stringWithFormat:@"*audioc %@,%@,0,0,%d", self.model.area, self.model.channel, self.sourceNumber];
        } else {
            [on_off setTag:1];
            [on_off setImage:[UIImage imageNamed:@"btn_switch_on"] forState:UIControlStateNormal];
            cmdString = [NSString stringWithFormat:@"*audioc %@,%@,1,0,%d", self.model.area, self.model.channel, self.sourceNumber];
        }
    } else if (button == startButton) {
        
        
        
        if (self.sourceNumber == 99) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"请选择音源"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        
        
        
            BOOL isChosenMusicSource = NO;
            for (int i = 0; i < [sourceButtons count]; i++) {
                if ([[sourceButtons objectAtIndex:i] isSelected]) {
                    isChosenMusicSource = YES;
                } else {
                    
                }
            }
            if (!isChosenMusicSource) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:@"请选择音源"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        
        if (button.tag == 1) {
            [startButton setTag:0];
            [startButton setBackgroundImage:[UIImage imageNamed:@"btn_play"] forState:UIControlStateNormal];
            [startButton setBackgroundImage:[UIImage imageNamed:@"btn_play_pressed"] forState:UIControlStateHighlighted];
            cmdString = [NSString stringWithFormat:@"*audioc %@,%@,2,0,%d", self.model.area, self.model.channel, self.sourceNumber];
        } else {
            NSNumber *vol = [[NSUserDefaults standardUserDefaults] objectForKey:@"vol"];
            if (vol) {
//                cmdString = [NSString stringWithFormat:@"*audioc %@,%@,3,%d,0", self.model.area, self.model.channel, [vol intValue]];
                cmdString = [NSString stringWithFormat:@"*audioc %@,%@,3,%d,%d", self.model.area, self.model.channel, 0, self.sourceNumber];
            } else {
//                cmdString = [NSString stringWithFormat:@"*audioc %@,%@,3,%d,0", self.model.area, self.model.channel, 15];
                cmdString = [NSString stringWithFormat:@"*audioc %@,%@,3,%d,%d", self.model.area, self.model.channel, 0, self.sourceNumber];
            }
            [startButton setTag:1];
            [startButton setBackgroundImage:[UIImage imageNamed:@"btn_pause"] forState:UIControlStateNormal];
            [startButton setBackgroundImage:[UIImage imageNamed:@"btn_pause_pressed"] forState:UIControlStateHighlighted];
        }
    } else if (button == volHigherButton) {
        
        
        if (self.sourceNumber == 99) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"请选择音源"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        
//        cmdString = [NSString stringWithFormat:@"*audioc %@,%@,7,0,0", self.model.area, self.model.channel];
        NSNumber *vol = [[NSUserDefaults standardUserDefaults] objectForKey:@"vol"];
        cmdString = [NSString stringWithFormat:@"*audioc %@,%@,7,%d,%d", self.model.area, self.model.channel, [vol intValue], self.sourceNumber];

        if (vol) {
            if ([vol intValue] + 1 < 32) {
                vol = [NSNumber numberWithInt:[vol intValue] + 1];
                [[NSUserDefaults standardUserDefaults] setObject:vol forKey:@"vol"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                //提醒，最大音量
//                [KVNProgress showErrorWithStatus:@"最高音量"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"最高音量"
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        } else {
            vol = [NSNumber numberWithInt:16];
            [[NSUserDefaults standardUserDefaults] setObject:vol forKey:@"vol"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } else if (button == volLowerButton) {
        
        
        if (self.sourceNumber == 99) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"请选择音源"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        
//        cmdString = [NSString stringWithFormat:@"*audioc %@,%@,6,0,0", self.model.area, self.model.channel];
        NSNumber *vol = [[NSUserDefaults standardUserDefaults] objectForKey:@"vol"];
        cmdString = [NSString stringWithFormat:@"*audioc %@,%@,6,%d,%d", self.model.area, self.model.channel, [vol intValue], self.sourceNumber];

        if (vol) {
            if ([vol intValue] - 1 > 0) {
                vol = [NSNumber numberWithInt:[vol intValue] - 1];
                [[NSUserDefaults standardUserDefaults] setObject:vol forKey:@"vol"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } else {
                //提醒，最小音量
//                [KVNProgress showErrorWithStatus:@"最低音量"];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"最低音量"
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        } else {
            vol = [NSNumber numberWithInt:14];
            [[NSUserDefaults standardUserDefaults] setObject:vol forKey:@"vol"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } else if (button == preButton) {
        
        if (self.sourceNumber == 99) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"请选择音源"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        
        cmdString = [NSString stringWithFormat:@"*audioc %@,%@,4,0,%d", self.model.area, self.model.channel, self.sourceNumber];
    } else if (button == nextButton) {
        
        if (self.sourceNumber == 99) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"请选择音源"
                                                               delegate:nil
                                                      cancelButtonTitle:@"确定"
                                                      otherButtonTitles:nil, nil];
            [alertView show];
            return;
        }
        
        cmdString = [NSString stringWithFormat:@"*audioc %@,%@,5,0,%d", self.model.area, self.model.channel, self.sourceNumber];
    } else if ([sourceButtons containsObject:button]) {
        if ([button.titleLabel.text isEqualToString:@"FM"]) {
            self.sourceNumber = 0;
            cmdString = [NSString stringWithFormat:@"*audioc %@,%@,8,0,%d", self.model.area, self.model.channel, self.sourceNumber];
        } else if ([button.titleLabel.text isEqualToString:@"MP3"]) {
            self.sourceNumber = 1;
            cmdString = [NSString stringWithFormat:@"*audioc %@,%@,9,0,1, %d", self.model.area, self.model.channel, self.sourceNumber];
        } else if ([button.titleLabel.text isEqualToString:@"AUX"]) {
            self.sourceNumber = 2;
            cmdString = [NSString stringWithFormat:@"*audioc %@,%@,10,0, %d", self.model.area, self.model.channel, self.sourceNumber];
        } else if ([button.titleLabel.text isEqualToString:@"DVD"]) {
            self.sourceNumber = 3;
            cmdString = [NSString stringWithFormat:@"*audioc %@,%@,11,0,%d", self.model.area, self.model.channel, self.sourceNumber];
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^(void){
        NSError *error;
        GCDAsyncSocket *socket = [[GCDAsyncSocket alloc] initWithDelegate:self.appDelegate delegateQueue:self.appDelegate.socketQueue];
        socket.command = [NSString stringWithFormat:@"%@\r\n", cmdString];
        [socket connectToHost:self.appDelegate.host onPort:self.appDelegate.port withTimeout:3.0 error:&error];
    });
}

@end
