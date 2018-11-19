//
//  MarketScoreDao.h
//  StockHelper
//
//  Created by 邓鹏程 on 2017/8/13.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "BaseDao.h"
@class MarketScoreInfo;

@interface MarketScoreDao : BaseDao

- (MarketScoreInfo*)analyseTheScoreWithPredictDate:(NSString*)date;

- (WhichMarket)getWhichMarketwithTradeDate:(NSString*)date withLongDate:(NSString*)longDate;

- (BOOL)insertStockInfos:(NSArray *)stockInfos;

@end
