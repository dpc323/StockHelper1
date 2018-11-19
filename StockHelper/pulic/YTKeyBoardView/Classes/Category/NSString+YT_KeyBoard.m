//
//  NSString+YT_KeyBoard.m
//  Keyboard
//
//  Created by laijihua on 16/8/18.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "NSString+YT_KeyBoard.h"

@implementation NSString (YT_KeyBoard)

- (CGFloat)yt_kGetHeightByWidth:(CGFloat)width font:(UIFont *)font {
    CGSize size = [self boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                   attribute:@{NSFontAttributeName:font}];
    
    return size.height;
    
}


- (CGSize)boundingRectWithSize:(CGSize)size attribute:(NSDictionary *)attribute
{
    CGSize retSize;
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
        retSize = [self boundingRectWithSize:size
                                     options:
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                  attributes:attribute
                                     context:nil].size;
    else{
        NSAttributedString * string = [[NSAttributedString alloc] initWithString:self attributes:attribute];
        retSize = [NSString boundingRectWithSize:size text:string];
    }
    
    return retSize;
}


+ (CGSize)boundingRectWithSize:(CGSize)size  text:(NSAttributedString *)text
{
    CGSize retSize = [text boundingRectWithSize:size
                                        options:
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                        context:nil].size;
    
    return retSize;
}



@end
