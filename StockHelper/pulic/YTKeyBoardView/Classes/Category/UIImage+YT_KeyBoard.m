//
//  UIImage+YT_KeyBoard.m
//  Keyboard
//
//  Created by laijihua on 16/8/16.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "UIImage+YT_KeyBoard.h"

@implementation UIImage (YT_KeyBoard)
+ (UIImage *)yt_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
