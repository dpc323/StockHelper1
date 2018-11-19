//
//  UIButton+YT_KeyBoard.h
//  Keyboard
//
//  Created by laijihua on 16/8/15.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (YT_KeyBoard)

+ (UIButton *)yt_createButton:(CGRect)frame
          normalSelectImgName:(NSString *)norSelImgName
                selectImgName:(NSString *)selImgName
                          tag:(NSInteger)tag
                        title:(NSString *)title
                   titleColor:(UIColor *)titleColor
                    titleFont:(UIFont *)titleFont
                       target:(id)target
                     selector:(SEL)selector;

/**
 *  设置圆角
 *
 *  @param radio radio
 */
- (void)yt_setCornerRadio:(CGFloat)radio;

@end
