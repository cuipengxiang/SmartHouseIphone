//
//  SHRoomCell.m
//  SmartHouse
//
//  Created by Roc on 13-11-5.
//  Copyright (c) 2013年 Roc. All rights reserved.
//

#import "SHRoomCell.h"

@implementation SHRoomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.image = [[UIImageView alloc] initWithFrame:CGRectMake(271.0, 15.0, 9.0, 15.0)];
        [self.image setImage:[UIImage imageNamed:@"arrow_iphone"]];
        self.line = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 43.5, 300.0, 1.5)];
        [self.line setImage:[UIImage imageNamed:@"line_iphone"]];
        
        [self.contentView addSubview:self.image];
        [self.contentView addSubview:self.line];
    }
    return self;
}

- (void)layoutSubviews {
    [self.textLabel setFrame:CGRectMake(16.0, 0.0, 250.0, 45.0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

}

@end
