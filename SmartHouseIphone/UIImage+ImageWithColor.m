//
//  UIImage+ImageWithColor.m
//  SmartHouseIphone
//
//  Created by Sidney Zou on 15/4/7.
//  Copyright (c) 2015年 Roc. All rights reserved.
//

#import "UIImage+ImageWithColor.h"

@implementation UIImage (ImageWithColor)

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1,1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
