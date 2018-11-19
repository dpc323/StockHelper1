//
//  PredictMarketDao.h
//  StockHelper
//
//  Created by 邓鹏程 on 2017/5/5.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "BaseDao.h"
#import "PredictMarketInfo.h"

@interface PredictMarketDao : BaseDao
/**
 * 获取股票信息列表
 *
 * @param code 股票代码
 * @param stockDays 天数
 * @return 数组
 */
- (NSArray *)queryStockDataByStockCode:(NSString *)code withDays:(StockDays)stockDays;

/**
 * 获取股票信息列表
 *
 * @param code 股票代码
 * @param tradeDay 日期
 * @return 数组
 */
- (NSArray *)queryStockDataByStockCode:(NSString *)code withTradeDay:(NSString*)tradeDay;

/**
 * 插入股票数据列表
 *
 * @param stockInfos 插入股票数据列表
 * @return BOOL
 */
- (BOOL)insertStockInfos:(NSArray *)stockInfos;

@end
