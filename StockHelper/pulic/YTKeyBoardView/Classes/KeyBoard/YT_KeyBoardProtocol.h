//
//  YT_KeyBoardProtocol.h
//  Keyboard
//
//  Created by laijihua on 16/8/15.
//  Copyright © 2016年 laijihua. All rights reserved.
//


#ifndef YT_KeyBoardProtocol_h
#define YT_KeyBoardProtocol_h

#import "YT_KeyBoardEnum.h"
@protocol YT_KeyBoardThemeProtocol;



@protocol YT_KeyBoardViewDecorationAble;

@protocol YT_KeyBoardViewSubViewDelegate <NSObject>

- (void)keyBoardViewSubView:(id<YT_KeyBoardViewDecorationAble> )subView buttonAction:(UIButton *)sender showText:(NSString *)retText;

- (void)setDisplayKeyBoard:(YT_KeyBoardShowStyle)style;


- (id<YT_KeyBoardThemeProtocol>)keyBoardTheme;

@optional
// 确定按钮点击
- (void)keyBoardViewSubView:(id<YT_KeyBoardViewDecorationAble> )subView comfirmBtnClicked:(UIButton *)sender;

// 删除|返回|取消 按钮
- (void)keyBoardViewSubView:(id<YT_KeyBoardViewDecorationAble>)subView cancleBtnClicked:(UIButton *)sender;

// 删除键长按
- (void)keyBoardViewSubView:(id<YT_KeyBoardViewDecorationAble>)subView cancleBtnLongPress:(UIButton *)sender;

- (BOOL)keyBoardViewSubView:(id<YT_KeyBoardViewDecorationAble> )subView isNeedAppendPointButtonTitle:(UIButton *)sender;

@end




@protocol YT_KeyBoardViewDecorationAble <NSObject>

- (instancetype)initWithFrame:(CGRect)frame
                 keyBoardType:(YT_KeyBoardType)type
                     delegate:(id<YT_KeyBoardViewSubViewDelegate>)delegate;

@end


@protocol YT_KeyBoardThemeProtocol <NSObject>
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


#endif /* YT_KeyBoardProtocol_h */
