//
//  KeyBoardView.h
//  Keyboard
//
//  Created by laijihua on 16/8/12.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "YT_KeyBoardEnum.h"
#import "YT_KeyBoardTheme.h"

@class YT_KeyBoardView;

@protocol YT_KeyBoardViewDelegate <NSObject>

@optional
- (void)keyBoardViewShouldConfirm:(YT_KeyBoardView *)keyBoardView;
- (void)keyBoardView:(YT_KeyBoardView *)keyBoardView changeText:(NSString *)text;

@end


/**
 *  键盘的容器类，负责键盘的切换，处理公有事物
 */
@interface YT_KeyBoardView : UIView<YT_KeyBoardViewSubViewDelegate>
/**
 *  创建键盘，初始化相关样式, 默认主题设置
 *
 *  @param frame     frame
 *  @param type      决定键盘切换组合
 *  @param showType  决定键盘显示样式
 *  @param delegate  代理
 *  @param textField 绑定的输出控件
 *
 *  @return YT_KeyBoardView
 */
- (instancetype)initWithFrame:(CGRect)frame
                 keyBoardType:(YT_KeyBoardType)type
        keyBoardFirstShowType:(YT_KeyBoardShowStyle)showType
                     delegate:(id<YT_KeyBoardViewDelegate>)delegate
                    textField:(UITextField *)textField;



/**
 *  创建键盘，初始化相关样式
 *
 *  @param frame     frame
 *  @param type      决定键盘切换组合
 *  @param showType  决定键盘显示样式
 *  @param delegate  代理
 *  @param textField 绑定的输出控件
 *  @param theme     主题
 *
 *  @return YT_KeyBoardView
 */
- (instancetype)initWithFrame:(CGRect)frame
                 keyBoardType:(YT_KeyBoardType)type
        keyBoardFirstShowType:(YT_KeyBoardShowStyle)showType
                     delegate:(id<YT_KeyBoardViewDelegate>)delegate
                    textField:(UITextField *)textField
                        theme:(id<YT_KeyBoardThemeProtocol>)theme;



@end
