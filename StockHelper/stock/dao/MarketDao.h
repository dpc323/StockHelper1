//
//  MarketDao.h
//  StockHelper
//
//  Created by hanarobot on 17/4/4.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "BaseDao.h"
#import "StockInfo.h"

@interface MarketDao : BaseDao
/**
 * 获取股票信息列表
 *
 * @param code 股票代码
 * @param stockDays 天数
 * @return 数组
 */
- (NSArray *)queryStockDataByStockCode:(NSString *)code withDays:(StockDays)stockDays;

/**
 * 插入股票数据列表
 *
 * @param stockInfos 插入股票数据列表
 * @return BOOL
 */
- (BOOL)insertStockInfos:(NSArray *)stockInfos;

@end
