//
//  SearchStockViewController.h
//  StockHelper
//
//  Created by dpc on 17/2/15.
//  Copyright © 2017年 dpc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YT_KeyBoardEnum.h"
@interface SearchStockViewController : UIViewController
/**
 *  键盘的样式
 */
@property (nonatomic, assign) YT_KeyBoardType keyBoardType;


/**
 *   多键盘键盘的展示样式
 */
@property (nonatomic, assign) YT_KeyBoardShowStyle keyBoardShowStyle;

@end
