//
//  PredictDao.m
//  StockHelper
//
//  Created by 邓鹏程 on 2017/4/3.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "PredictDao.h"

@implementation PredictDao

/**
 * 获取股票预测信息列表
 *
 * @param code 股票代码
 * @return 数组
 */
- (NSArray *)queryStockDataByStockCode:(NSString *)code{
    
    NSMutableArray *returnArray = [[NSMutableArray alloc] init];
    
    //FMResultSet *rs = [db executeQuery:[TableStockInfo getQuerySQL], code];
//    NSLog(@"getQuery SQL:%@",[TablePredictInfo getQuerySQLV1]);
    FMResultSet *rs = [db executeQuery:[TablePredictInfo getQuerySQLV1], code];
    
    while ([rs next]) {
        
        PredictInfo *info = [self entityFromRS:rs];
        [returnArray addObject:info];
        
    }
    [rs close];
    return returnArray;
    
}


/**
 * 获取某天某只股票预测信息列表
 *
 * @param code 股票代码
 * @param date 日期
 * @return 数组
 */
- (PredictInfo *)queryStockDataByStockCode:(NSString *)code withTradeDate:(NSString*)date
{
    PredictInfo *info = nil;
//    NSLog(@"getQuery SQL:%@",[TablePredictInfo getQuerySQLV1]);
    FMResultSet *rs = [db executeQuery:[TablePredictInfo getQuerySQLV1], code,date];
    
    while ([rs next]) {
        info = [self entityFromRS:rs];
    }
    [rs close];
    return  info;
}
/**
 * 插入股票预测数据
 *
 * @param info 插入股票数据列表
 * @return BOOL
 */
- (BOOL)insertPredictInfo:(PredictInfo *)info;
 {
    BOOL success = YES;
    

//    NSLog(@"insert SQL:%@",[TablePredictInfo getInsertSQL]);
    
    //用事务会有大幅效率提升
    [db beginTransaction];
    
    FMResultSet *rs = nil;
    BOOL isExist = NO;
     
    //判断是否存在 如果存在就插入
    rs = [db executeQuery:[TablePredictInfo getQuerySQLV4], info.code, info.tradeDate];
    if ([rs next]) {
        isExist = YES;
    }
    else {
        isExist = NO;
    }
     
    if (isExist) {
         [db executeUpdate:[TablePredictInfo getAlterSQL],  @(info.highPrice), @(info.lowPrice), @(info.averagePrice), @(info.currentPrice),@(info.predictRidio),@(info.realRido),@(info.predictVolume),@(info.realVolume),info.code, info.tradeDate];
    } else {
        [db executeUpdate:[TablePredictInfo getInsertSQL], info.code, info.tradeDate, @(info.highPrice), @(info.lowPrice), @(info.averagePrice), @(info.currentPrice),@(info.predictRidio),@(info.realRido),@(info.predictVolume),@(info.realVolume)];
    }
     
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        success = NO;
        [db rollback];
        return NO;
    }
    
    if (success) {
        [db commit];
    }
    
    return success;
}

- (id)entityFromRS:(FMResultSet *)rs {
    
    PredictInfo *info = [[PredictInfo alloc] init];
    
    info.code = [rs stringForColumnIndex:0];
    info.tradeDate = [rs stringForColumnIndex:1];
    info.highPrice = [rs doubleForColumnIndex:2];
    info.lowPrice = [rs doubleForColumnIndex:3];
    info.averagePrice = [rs doubleForColumnIndex:4];
    info.currentPrice = [rs doubleForColumnIndex:5];
    info.predictRidio = [rs doubleForColumnIndex:6];
    info.realRido = [rs doubleForColumnIndex:7];
    info.predictVolume = [rs doubleForColumnIndex:8];
    info.realVolume = [rs doubleForColumnIndex:9];
    
    return info;
}

- (BOOL)insertWithEntity:(Entity *)entity {
    PredictInfo *info = (PredictInfo *)entity;
    
    BOOL success = YES;
    FMResultSet *rs = nil;
    BOOL isExist = NO;
    
    //判断是否存在 如果存在就插入
    rs = [db executeQuery:[TablePredictInfo getQuerySQLV4], info.code, info.tradeDate];
    if ([rs next]) {
        isExist = YES;
    }
    else {
        isExist = NO;
    }
    
    if (isExist) {
        [db executeUpdate:[TablePredictInfo getAlterSQL], info.code, info.tradeDate, @(info.highPrice), @(info.lowPrice), @(info.averagePrice), @(info.currentPrice),@(info.predictRidio),@(info.realRido),@(info.predictVolume),@(info.realVolume)];
    } else {
        [db executeUpdate:[TablePredictInfo getInsertSQL], info.code, info.tradeDate, @(info.highPrice), @(info.lowPrice), @(info.averagePrice), @(info.currentPrice),@(info.predictRidio),@(info.realRido),@(info.predictVolume),@(info.realVolume)];
    }

    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        success = NO;
    }
    return success;
}

@end
