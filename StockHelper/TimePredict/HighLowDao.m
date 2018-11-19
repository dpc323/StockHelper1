//
//  HighLowDao.m
//  StockHelper
//
//  Created by hanarobot on 17/7/14.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "HighLowDao.h"
#import "HighLowInfo.h"

@implementation HighLowDao

- (DatePredictInfo*)analyseTheTotalCodeWithPredictDate:(NSString*)date{
    
    DatePredictInfo *predictInfo = [[DatePredictInfo alloc] init];
    predictInfo.predictDate = date;
    
    //predictDate,highMaxDate,lowMaxDate,highMaxCount,lowMaxCount,score;

    FMResultSet *rs1 = [db executeQuery:[TableHighLowInfo getQuerySQLV2]];
    while ([rs1 next]) {
        predictInfo.highMaxDate = [rs1 stringForColumnIndex:0];
        predictInfo.highMaxCount = [rs1 intForColumnIndex:1];
    }
    [rs1 close];
    
    FMResultSet *rs2 = [db executeQuery:[TableHighLowInfo getQuerySQLV3]];
    while ([rs2 next]) {
        predictInfo.lowMaxDate = [rs2 stringForColumnIndex:0];
        predictInfo.lowMaxCount = [rs2 intForColumnIndex:1];
    }
    [rs2 close];
    
    FMResultSet *rs3 = [db executeQuery:[TableHighLowInfo getHighCountSQL],date];
    while ([rs3 next]) {
        predictInfo.currentHighCount = [rs3 intForColumnIndex:0];
    }
    [rs3 close];
    
    FMResultSet *rs4 = [db executeQuery:[TableHighLowInfo getLowCountSQL],date];
    while ([rs4 next]) {
        predictInfo.currentLowCount = [rs4 intForColumnIndex:0];
    }
    [rs4 close];
    //predictInfo.score = predictInfo.ma
    return predictInfo;
}

//- (id)entityFromRS:(FMResultSet *)rs {

//    PredictInfo *info = [[PredictInfo alloc] init];
//    
//    info.code = [rs stringForColumnIndex:0];
//    info.tradeDate = [rs stringForColumnIndex:1];
//    info.highPrice = [rs doubleForColumnIndex:2];
//    info.lowPrice = [rs doubleForColumnIndex:3];
//    info.averagePrice = [rs doubleForColumnIndex:4];
//    info.currentPrice = [rs doubleForColumnIndex:5];
//    info.predictRidio = [rs doubleForColumnIndex:6];
//    info.realRido = [rs doubleForColumnIndex:7];
//    info.predictVolume = [rs doubleForColumnIndex:8];
//    info.realVolume = [rs doubleForColumnIndex:9];
//    
//    return info;
//}

- (BOOL)insertWithEntity:(Entity *)entity {
    HighLowInfo *hlInfo = (HighLowInfo *)entity;
    
    BOOL success = YES;
    
    FMResultSet *rs = nil;
    BOOL isExist = NO;
    rs = [db executeQuery:[TableHighLowInfo getQuerySQL], hlInfo.code];
    
    if ([rs next]) {
        isExist = YES;
    }
    else {
        isExist = NO;
    }
    
    if (isExist) {
        [db executeUpdate:[TableHighLowInfo getAlterSQLV2], hlInfo.highDate, hlInfo.lowDate, @(hlInfo.highPrice), @(hlInfo.lowPrice), @(hlInfo.upCounts), @(hlInfo.downCounts),  @(hlInfo.upRatios), @(hlInfo.downRatios), hlInfo.code];
    }else{
        [db executeUpdate:[TableHighLowInfo getInsertSQL], hlInfo.code, hlInfo.highDate, hlInfo.lowDate, @(hlInfo.highPrice), @(hlInfo.lowPrice), @(hlInfo.upCounts), @(hlInfo.downCounts),  @(hlInfo.upRatios), @(hlInfo.downRatios)];
    }
    
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        success = NO;
    }
    
    return success;
}

/*
CREATE TABLE DatePredictInfo (
                              predictDate date PRIMARY KEY,
                              highMaxDate date,
                              lowMaxDate date,
                              highMaxCount number(6),
                              lowMaxCount number(6),
                              score number(6)
                              );

CREATE TABLE HighLowInfo (
                          code text PRIMARY KEY,
                          highDate date,
                          lowDate date,
                          highPrice number(6),
                          lowPrice number(6)
                          );
 */

@end
