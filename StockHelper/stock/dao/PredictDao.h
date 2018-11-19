//
//  PredictDao.h
//  StockHelper
//
//  Created by 邓鹏程 on 2017/4/3.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "BaseDao.h"
#import "PredictInfo.h"

@interface PredictDao : BaseDao
/**
 * 获取股票预测信息列表
 *
 * @param code 股票代码
 * @return 数组
 */
- (NSArray *)queryStockDataByStockCode:(NSString *)code;


/**
 * 获取某天某只股票预测信息列表
 *
 * @param code 股票代码
 * @param date 日期
 * @return 数组
 */
- (PredictInfo *)queryStockDataByStockCode:(NSString *)code withTradeDate:(NSString*)date;

/**
 * 插入股票预测数据
 *
 * @param info 插入股票数据列表
 * @return BOOL
 */
- (BOOL)insertPredictInfo:(PredictInfo *)info;

@end
