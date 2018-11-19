//
//  UIButton+YT_KeyBoard.m
//  Keyboard
//
//  Created by laijihua on 16/8/15.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "UIButton+YT_KeyBoard.h"

@implementation UIButton (YT_KeyBoard)

+ (UIButton *)yt_createButton:(CGRect)frame
          normalSelectImgName:(NSString *)norSelImgName
                selectImgName:(NSString *)selImgName
                          tag:(NSInteger)tag
                        title:(NSString *)title
                   titleColor:(UIColor *)titleColor
                    titleFont:(UIFont *)titleFont
                       target:(id)target
                     selector:(SEL)selector {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.tag = tag;
    [button setTitle:title forState:UIControlStateNormal];
    
    if (titleColor) {
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (titleFont) {
        if ([title isEqualToString:@"中文"]) {
            button.titleLabel.font = [UIFont fontWithName:@"Courier New" size:22.0f];
        }else if([title isEqualToString:@"adc"])
        {
            button.titleLabel.font = [UIFont fontWithName:@"Courier New" size:26.0f];
        }else{
            button.titleLabel.font = titleFont;
        }
    }
    if (norSelImgName) {
        [button setBackgroundImage:[UIImage imageNamed:norSelImgName] forState:UIControlStateNormal];
    }
    if (selImgName) {
        [button setBackgroundImage:[UIImage imageNamed:selImgName] forState:UIControlStateSelected];
    }
    [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (void)yt_setCornerRadio:(CGFloat)radio {
    self.layer.cornerRadius = radio;
    self.layer.masksToBounds = YES;
}

@end
