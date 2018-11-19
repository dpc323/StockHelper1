//
//  MonthViewController.h
//  StockHelper
//
//  Created by 邓鹏程 on 2017/6/18.
//  Copyright © 2017年 hana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YT_KeyBoardEnum.h"

@interface MonthViewController : UIViewController
/**
 *  键盘的样式
 */
@property (nonatomic, assign) YT_KeyBoardType keyBoardType;


/**
 *   多键盘键盘的展示样式
 */
@property (nonatomic, assign) YT_KeyBoardShowStyle keyBoardShowStyle;
@end
