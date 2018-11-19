//
//  StockDao.h
//  StockDataBase
//
//  Created by hanarobot on 17/3/22.
//  Copyright © 2017年 dpc. All rights reserved.
//

#import "BaseDao.h"
#import "StockInfo.h"

@interface StockDao : BaseDao

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


- (int)queryCountFromDate:(NSString*)date withCode:(NSString*)code;

@end
