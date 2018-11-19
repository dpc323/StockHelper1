//
//  WeekStockViewController.h
//  StockHelper
//
//  Created by hanarobot on 17/5/6.
//  Copyright © 2017年 hana. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YT_KeyBoardEnum.h"

@interface WeekStockViewController : UIViewController
/**
 *  键盘的样式
 */
@property (nonatomic, assign) YT_KeyBoardType keyBoardType;


/**
 *   多键盘键盘的展示样式
 */
@property (nonatomic, assign) YT_KeyBoardShowStyle keyBoardShowStyle;

@end
