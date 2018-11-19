//
//  MarketDao.m
//  StockHelper
//
//  Created by hanarobot on 17/4/4.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "MarketDao.h"

@implementation MarketDao

/**
 * 获取股票信息列表
 *
 * @param code 股票代码
 * @param stockDays 天数
 * @return 数组
 */
- (NSArray *)queryStockDataByStockCode:(NSString *)code withDays:(StockDays)stockDays{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    //FMResultSet *rs = [db executeQuery:[TABLE_MARKETINFO getQuerySQL], code];
//    NSLog(@"getQuery SQL:%@",[TableMarketInfo getQuerySQLV1]);
    FMResultSet *rs = [db executeQuery:[TableMarketInfo getQuerySQLV1], code, @(stockDays)];
    
    while ([rs next]) {
        StockInfo *stock = [self entityFromRS:rs];
        
        [returnArray addObject:stock];
        
    }
    [rs close];
    return returnArray;
    
}

/**
 * 插入股票数据列表
 *
 * @param stockInfos 插入股票数据列表
 * @return BOOL
 */
- (BOOL)insertStockInfos:(NSArray *)stockInfos {
    BOOL success = YES;
    
    if ([stockInfos count] == 0) {
        return success;
    }
//    NSLog(@"insert SQL:%@",[TableMarketInfo getInsertSQL]);
    
    //用事务会有大幅效率提升
    [db beginTransaction];
    
    FMResultSet *rs = nil;
    BOOL isExist = NO;
    for (StockInfo *stockInfo in stockInfos) {
        
        //判断是否存在 如果存在就插入
        rs = [db executeQuery:[TableMarketInfo getQuerySQLV4], stockInfo.code, stockInfo.date];
        if ([rs next]) {
            isExist = YES;
        }
        else {
            isExist = NO;
        }
        if (isExist) {
            break;
            //            [db executeUpdate:[TableStockInfo getAlterSQL], stockInfo.code,[NSString stringWithFormat:@"%@",stockInfo.date], stockInfo.highPrice, stockInfo.lowPrice, stockInfo.openPrice, stockInfo.closePrice, stockInfo.volume];
        }
        else {
            [db executeUpdate:[TableMarketInfo getInsertSQL], stockInfo.code, stockInfo.date, @(stockInfo.highPrice), @(stockInfo.lowPrice), @(stockInfo.openPrice), @(stockInfo.closePrice),@(stockInfo.volume)];
        }
        if ([db hadError]) {
            NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            success = NO;
            [db rollback];
            break;
        }
    }
    
    if (success) {
        [db commit];
    }
    
    return success;
}

- (id)entityFromRS:(FMResultSet *)rs {
    
    StockInfo *stockInfo = [[StockInfo alloc] init];
    
    stockInfo.code = [rs stringForColumnIndex:0];
    stockInfo.date = [rs stringForColumnIndex:1];
    stockInfo.highPrice = [rs doubleForColumnIndex:2];
    stockInfo.lowPrice = [rs doubleForColumnIndex:3];
    stockInfo.openPrice = [rs doubleForColumnIndex:4];
    stockInfo.closePrice = [rs doubleForColumnIndex:5];
    stockInfo.volume = [rs doubleForColumnIndex:6];
    
    return stockInfo;
}

- (BOOL)insertWithEntity:(Entity *)entity {
    StockInfo *stockInfo = (StockInfo *)entity;
    
    BOOL success = YES;
    
    //根据id删除原来的这条项目基本信息的记录
    success = [self deleteWithEntity:stockInfo];
    
    [db executeUpdate:[TableMarketInfo getInsertSQL], stockInfo.code, stockInfo.date, @(stockInfo.highPrice), @(stockInfo.lowPrice), @(stockInfo.openPrice), @(stockInfo.closePrice),@(stockInfo.volume)];
    
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        success = NO;
    }
    return success;
}

@end
