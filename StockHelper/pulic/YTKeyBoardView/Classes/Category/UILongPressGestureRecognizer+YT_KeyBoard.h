//
//  UILongPressGestureRecognizer+YT_KeyBoard.h
//  Keyboard
//
//  Created by laijihua on 16/8/15.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILongPressGestureRecognizer (YT_KeyBoard)
+ (UILongPressGestureRecognizer *)yt_createWithTarget:(id)target action:(SEL)action;

+ (UILongPressGestureRecognizer *)yt_createWithPressDuration:(CFTimeInterval)duration target:(id)target action:(SEL)action;
@end
