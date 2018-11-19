//
//  NSArray+YT_KeyBoard.h
//  Keyboard
//
//  Created by laijihua on 16/8/17.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (YT_KeyBoard)
/**
 *  返回的是数字键盘最右边仓库数据
 *
 *  @return [String]
 */
+ (NSArray<NSString *> *)yt_numberKeyBoardWarehouseLeft;

/**
 *  返回的是数字键盘最右边的数字数据
 *
 *  @return [String]
 */
+ (NSArray<NSString *> *)yt_numberKeyBoardNumberLeft;
@end
