//
//  StockResult.h
//  StockHelper
//
//  Created by 邓鹏程 on 2017/2/28.
//  Copyright © 2017年 hana. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockResult : NSObject

@property (nonatomic,copy) NSString *stockCode;
@property (nonatomic,assign) float fluctuateRatio; //波动比率
@property (nonatomic,copy) NSString *result;
@property (nonatomic,copy) NSString *tradeDate;
@end
