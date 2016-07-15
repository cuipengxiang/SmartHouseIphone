//
//  SHRoomCell.h
//  SmartHouse
//
//  Created by Roc on 13-11-5.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SHRoomModel.h"

@interface SHRoomCell : UITableViewCell

@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UIImageView *line;
@property (nonatomic, strong) SHRoomModel *data;

@end
