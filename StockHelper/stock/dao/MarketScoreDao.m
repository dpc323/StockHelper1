//
//  MarketScoreDao.m
//  StockHelper
//
//  Created by 邓鹏程 on 2017/8/13.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "MarketScoreDao.h"
#import "MarketScoreInfo.h"

@implementation MarketScoreDao


- (MarketScoreInfo*)analyseTheScoreWithPredictDate:(NSString*)date{
    
    MarketScoreInfo *mScoreInfo = [[MarketScoreInfo alloc] init];
    mScoreInfo.tradeDate = date;
        
    FMResultSet *rs1 = [db executeQuery:[TableMarketPredictInfo getQuerySQLV3],@(105)];
    while ([rs1 next]) {
        mScoreInfo.sumScore = [rs1 doubleForColumnIndex:0];
    }
    [rs1 close];
    
    FMResultSet *rs2 = [db executeQuery:[TableMarketPredictInfo getQuerySQLV3], @(10)];
    while ([rs2 next]) {
        mScoreInfo.sumScore10 = [rs2 doubleForColumnIndex:0];
    }
    [rs2 close];
    
    //predictInfo.score = predictInfo.ma
    return mScoreInfo;
}

- (MarketScoreInfo *)queryStockDataByStockCodeWithTradeDate:(NSString*)date
{
    MarketScoreInfo *info = nil;
    //    NSLog(@"getQuery SQL:%@",[TablePredictInfo getQuerySQLV1]);
    FMResultSet *rs = [db executeQuery:[TableMarketScoreInfo getQuerySQL],date];
    
    while ([rs next]) {
        info = [self entityFromRS:rs];
    }
    [rs close];
    return  info;
}


- (id)entityFromRS:(FMResultSet *)rs {
    
    MarketScoreInfo *info = [[MarketScoreInfo alloc] init];
    
    info.tradeDate = [rs stringForColumnIndex:0];
    info.sumScore = [rs doubleForColumnIndex:1];
    info.sumScore10 = [rs doubleForColumnIndex:2];
    info.predictScore = [rs doubleForColumnIndex:3];
    info.market = [rs intForColumnIndex:4];
    
    return info;
}

- (WhichMarket)getWhichMarketwithTradeDate:(NSString*)date withLongDate:(NSString*)longDate
{
    MarketScoreInfo *mScoreInfo = [self queryStockDataByStockCodeWithTradeDate:date];
    
    NSString *maxDate =@"";
    NSString *minDate =@"";
    FMResultSet *rs1 = [db executeQuery:[TableMarketScoreInfo getQuerySQLV2],longDate];
    while ([rs1 next]) {
        maxDate = [rs1 stringForColumnIndex:0];
    }
    [rs1 close];
    
    FMResultSet *rs2 = [db executeQuery:[TableMarketScoreInfo getQuerySQLV3],longDate];
    while ([rs2 next]) {
        minDate = [rs2 stringForColumnIndex:0];
    }
    [rs2 close];
   
    mScoreInfo.market = [self compareDate:maxDate withDate:minDate];
    [self insertWithEntity:mScoreInfo];
    return  mScoreInfo.market;
}

- (NSInteger)compareDate:(NSString*)aDate withDate:(NSString*)bDate
{
    NSInteger aa;
    NSDateFormatter *dateformater = [[NSDateFormatter alloc] init];
    [dateformater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dta = [[NSDate alloc] init];
    NSDate *dtb = [[NSDate alloc] init];
    
    dta = [dateformater dateFromString:aDate];
    dtb = [dateformater dateFromString:bDate];
    NSComparisonResult result = [dta compare:dtb];
    if (result == NSOrderedSame)
    {
        //        相等  aa=0
    }else if (result == NSOrderedAscending)
    {
        //bDate比aDate大
        aa=1;
    }else if (result == NSOrderedDescending)
    {
        //bDate比aDate小
        aa=-1;
    }
    
    return aa;
}

- (BOOL)insertWithEntity:(Entity *)entity {
    MarketScoreInfo *scoreInfo = (MarketScoreInfo *)entity;
    
    BOOL success = YES;
    
    //根据id删除原来的这条项目基本信息的记录
    success = [self deleteWithEntity:scoreInfo];
    
    [db executeUpdate:[TableMarketScoreInfo getInsertSQL], scoreInfo.tradeDate, @(scoreInfo.sumScore), @(scoreInfo.sumScore10), @(scoreInfo.predictScore), @(scoreInfo.market)];
    
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        success = NO;
    }
    return success;
}

@end
