//
//  UITextField+YT_KeyBoard.m
//  Keyboard
//
//  Created by laijihua on 16/8/15.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "UITextField+YT_KeyBoard.h"

@implementation UITextField (YT_KeyBoard)

#pragma  mark - YT_KeyBoardAccessoryViewDelegate
- (void)keyboardViewEndEdit {
    [self endEditing:YES];
}

@end
