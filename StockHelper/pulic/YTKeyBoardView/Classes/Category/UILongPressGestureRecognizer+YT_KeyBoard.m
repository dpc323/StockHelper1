//
//  UILongPressGestureRecognizer+YT_KeyBoard.m
//  Keyboard
//
//  Created by laijihua on 16/8/15.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "UILongPressGestureRecognizer+YT_KeyBoard.h"

@implementation UILongPressGestureRecognizer (YT_KeyBoard)

+ (UILongPressGestureRecognizer *)yt_createWithTarget:(id)target action:(SEL)action {
    return [self yt_createWithPressDuration:0.5 target:target action:action];
}


+ (UILongPressGestureRecognizer *)yt_createWithPressDuration:(CFTimeInterval)duration target:(id)target action:(SEL)action {
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:target action:action];
    longPressGesture.minimumPressDuration = duration;
    return longPressGesture;
}

@end
