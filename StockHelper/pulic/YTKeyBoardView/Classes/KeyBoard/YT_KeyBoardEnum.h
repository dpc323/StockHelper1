//
//  YT_KeyBoardEnum.h
//  Keyboard
//
//  Created by laijihua on 16/8/15.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#ifndef YT_KeyBoardEnum_h
#define YT_KeyBoardEnum_h

// 决定键盘切换的方式
typedef NS_ENUM(NSUInteger, YT_KeyBoardType) {
    YT_KeyBoardType_Number = 1001,       ///< 只有数字 （左下角什么都没有）
    YT_KeyBoardType_NumberPoint,         ///< 数字+小数点 （左下角是小数点“.”）
    YT_KeyBoardType_NumberWarehouseLeft,     ///< 数字+最左边一列是仓库选项  eg: 全仓 1/2仓库  1/3仓库  1/4仓库
    YT_KeyBoardType_NumberCharacterSymbol,  ///< 数字，字母，符号
    YT_KeyBoardType_NumberCharacterSystem,  ///< 数字，字母, 系统中文
    YT_KeyBoardType_NumBerCharacterSystemLeft,  ///< 数字，字母，系统中文，数字键盘的左边有一栏 eg: 000 200 300 600
};

// 当前键盘切换样式
typedef NS_ENUM(NSUInteger, YT_KeyBoardShowStyle) {
    YT_KeyBoardShowStyle_Number = 10001,  ///< 显示是数字键盘
    YT_KeyBoardShowStyle_Symbol,          ///< 显示是符号键盘
    YT_KeyBoardShowStyle_Character,       ///< 显示的是字符键盘
    YT_KeyBoardShowStyle_System,          ///< 系统中文
};


#import "YT_KeyBoardProtocol.h"
#import "UIButton+YT_KeyBoard.h"
#import "UILongPressGestureRecognizer+YT_KeyBoard.h"
#import "UIImage+YT_KeyBoard.h"
#import "NSArray+YT_KeyBoard.h"



#endif /* YT_KeyBoardEnum_h */
