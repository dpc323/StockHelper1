//
//  StockConfig.h
//  StockHelper
//
//  Created by dpc on 17/2/22.
//  Copyright © 2017年 dpc. All rights reserved.
//

#ifndef StockConfig_h
#define StockConfig_h
#define RGB(r,g,b)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define IPHONE4 ( [ [ UIScreen mainScreen ] bounds ].size.height == 480 )

#define ratioValue 5
#define weekRatioValue 20

#define sinaURL @"http://hq.sinajs.cn/list=s_sh000001"
#define rootURL @"http://q.stock.sohu.com/hisHq"
#define yahooURL @"http://table.finance.yahoo.com/table.csv"

#define kIOSVersions [[[UIDevice currentDevice] systemVersion] floatValue] //获得iOS版本

typedef NS_ENUM(NSInteger, StockDays) {
    longDays = 105,
    //longDays = 90,
    tenDays = 10,
    shortDays = 5,
    days = 21,
};


typedef NS_ENUM(NSInteger, WhichMarket) {
    sailerMarket = -1,
    buyerMarket = 1
};
#endif /* StockConfig_h */
