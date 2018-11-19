//
//  YT_KeyBoardTheme.h
//  Pods
//
//  Created by laijihua on 16/8/25.
//
//

#import <Foundation/Foundation.h>
#import "YT_KeyBoardProtocol.h"

@interface YT_KeyBoardTheme : NSObject<YT_KeyBoardThemeProtocol>
// ---------------------------- 三个键盘共用 ------------------/
/** 键盘的背景颜色 */
@property (nonatomic, strong) UIColor *keyBoardBackgroundColor;


/** 键盘输入键的颜色 */
@property (nonatomic, strong) UIColor *keyBoardInputButtonColor;

/** 输入键按下的颜色 */
@property (nonatomic, strong) UIColor *keyBoardInputButtonPressDownColor;

/** 键盘确定按钮按下的颜色 */
@property (nonatomic, strong) UIColor *keyBoardConfirmButtonPressDownColor;
/** 键盘确定按钮的普通状态下的颜色*/
@property (nonatomic, strong) UIColor *keyBoardConfirmButtonColor;

// --------------------------- 数字键盘 --------------------------
/** 数字键盘控制键的颜色 */
@property (nonatomic, strong) UIColor *numberBoardControlButtonColor;
/** 数字键盘控制键按下的颜色 */
@property (nonatomic, strong) UIColor *numberBoardControlButtonPressColor;

// -------------------- 符号键盘 -----------------------------
/** 符号键盘控制键颜色 */
@property (nonatomic, strong) UIColor *symbolBoardControlColor;
/** 符号键盘控制键按下颜色 */
@property (nonatomic, strong) UIColor *symbolBoardControlPressDownColor;

// -------------------- 字母键盘 -----------------------------
/** 字母键盘控制键的颜色 */
@property (nonatomic, strong) UIColor *characterBoardContrlColor;
/** 字母键盘控制键的按下颜色*/
@property (nonatomic, strong) UIColor *characterBoardControlPressColor;

/** 字母键盘的控制键的颜色 */
@property (nonatomic, strong) UIColor *characterBoardInputButtonPressDownColor;

@end
