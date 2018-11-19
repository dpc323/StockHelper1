//
//  YT_KeyBoardCharacterView.h
//  Keyboard
//
//  Created by laijihua on 16/8/15.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YT_KeyBoardZoomAbleView.h"

/**
 *  字母键盘
 */
@interface YT_KeyBoardCharacterView: YT_KeyBoardZoomAbleView<YT_KeyBoardViewDecorationAble>

/**
 *  设置键盘大小写
 *
 *  @param bBig 大小写
 */
- (void)setBigOrSmallForEnglish:(BOOL)bBig;

@end
