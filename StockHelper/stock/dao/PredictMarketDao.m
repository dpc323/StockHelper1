//
//  PredictMarketDao.m
//  StockHelper
//
//  Created by 邓鹏程 on 2017/5/5.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "PredictMarketDao.h"

@implementation PredictMarketDao

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
//    NSLog(@"getQuery SQL:%@",[TableMarketPredictInfo getQuerySQLV1]);
    FMResultSet *rs = [db executeQuery:[TableMarketPredictInfo getQuerySQLV1], code, @(stockDays)];
    
    while ([rs next]) {
        
        PredictMarketInfo *stock = [self entityFromRS:rs];
        [returnArray addObject:stock];
        
    }
    
    [rs close];
    return returnArray;
    
}
/**
 * 获取股票信息列表
 *
 * @param code 股票代码
 * @param tradeDay 日期
 * @return 数组
 */
- (NSArray *)queryStockDataByStockCode:(NSString *)code withTradeDay:(NSString*)tradeDay
{
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];

    //FMResultSet *rs = [db executeQuery:[TABLE_MARKETINFO getQuerySQL], code];
    //    NSLog(@"getQuery SQL:%@",[TableMarketPredictInfo getQuerySQLV4]);
    FMResultSet *rs = [db executeQuery:[TableMarketPredictInfo getQuerySQLV4], code, tradeDay];
    
    while ([rs next]) {
        
        PredictMarketInfo *stock = [self entityFromRS:rs];
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
//    NSLog(@"insert SQL:%@",[TableMarketPredictInfo getInsertSQL]);
    
    //用事务会有大幅效率提升
    [db beginTransaction];
    
    FMResultSet *rs = nil;
    BOOL isExist = NO;
    for (PredictMarketInfo *stockInfo in stockInfos) {
        
        //判断是否存在 如果存在就插入
        rs = [db executeQuery:[TableMarketPredictInfo getQuerySQLV4], stockInfo.code, stockInfo.tradeDate];
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
            [db executeUpdate:[TableMarketPredictInfo getInsertSQL], stockInfo.code, stockInfo.tradeDate, @(stockInfo.upCount), @(stockInfo.downCount), @(stockInfo.noChangeCount), @(stockInfo.radio),@(stockInfo.volume),@(stockInfo.score)];
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
    
    PredictMarketInfo *stockInfo = [[PredictMarketInfo alloc] init];
    
    stockInfo.code = [rs stringForColumnIndex:0];
    stockInfo.tradeDate = [rs stringForColumnIndex:1];
    stockInfo.upCount = [rs doubleForColumnIndex:2];
    stockInfo.downCount = [rs doubleForColumnIndex:3];
    stockInfo.noChangeCount = [rs doubleForColumnIndex:4];
    stockInfo.radio = [rs doubleForColumnIndex:5];
    stockInfo.volume = [rs doubleForColumnIndex:6];
    stockInfo.score = [rs doubleForColumnIndex:7];

    return stockInfo;
}

- (BOOL)insertWithEntity:(Entity *)entity {
    PredictMarketInfo *stockInfo = (PredictMarketInfo *)entity;
    
    BOOL success = YES;
    
    //根据id删除原来的这条项目基本信息的记录
    success = [self deleteWithEntity:stockInfo];
    
    [db executeUpdate:[TableMarketPredictInfo getInsertSQL], stockInfo.code, stockInfo.tradeDate, @(stockInfo.upCount), @(stockInfo.downCount), @(stockInfo.noChangeCount), @(stockInfo.radio),@(stockInfo.volume),@(stockInfo.score)];
    
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        success = NO;
    }
    return success;
}

@end
