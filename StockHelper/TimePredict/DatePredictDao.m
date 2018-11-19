//
//  DatePredictDao.m
//  StockHelper
//
//  Created by hanarobot on 17/7/14.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "DatePredictDao.h"
#import "DatePredictInfo.h"

@implementation DatePredictDao

- (BOOL)insertWithEntity:(Entity *)entity {
    DatePredictInfo *dpInfo = (DatePredictInfo *)entity;
    
    BOOL success = YES;
    
    FMResultSet *rs = nil;
    BOOL isExist = NO;
    rs = [db executeQuery:[TableDatePredictInfo getQuerySQL], dpInfo.predictDate];
    
    if ([rs next]) {
        isExist = YES;
    }
    else {
        isExist = NO;
    }
    
    if (isExist) {
        [db executeUpdate:[TableDatePredictInfo getAlterSQL], dpInfo.predictDate, dpInfo.highMaxDate, dpInfo.lowMaxDate, @(dpInfo.highMaxCount), @(dpInfo.lowMaxCount), @(dpInfo.currentHighCount),@(dpInfo.currentLowCount),@(dpInfo.score)];
    }else{
         [db executeUpdate:[TableDatePredictInfo getInsertSQL], dpInfo.predictDate, dpInfo.highMaxDate, dpInfo.lowMaxDate, @(dpInfo.highMaxCount), @(dpInfo.lowMaxCount),@(dpInfo.currentHighCount),@(dpInfo.currentLowCount), @(dpInfo.score)];
    }
    
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        success = NO;
    }
    
    if ([db hadError]) {
        NSLog(@"Err %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        success = NO;
    }
    return success;
}

@end
