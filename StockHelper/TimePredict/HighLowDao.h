//
//  HighLowDao.h
//  StockHelper
//
//  Created by hanarobot on 17/7/14.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "BaseDao.h"
#import "DatePredictInfo.h"

@interface HighLowDao : BaseDao

//统计数据
- (DatePredictInfo*)analyseTheTotalCodeWithPredictDate:(NSString*)date;
@end
