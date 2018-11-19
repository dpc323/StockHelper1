//
//  PredictResult.h
//  StockHelper
//
//  Created by dpc on 17/2/16.
//  Copyright © 2017年 dpc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PredictResult : NSObject

@property (assign,nonatomic) float riseMax;   //上涨最高点
@property (assign,nonatomic) float riseMin;   //上涨最低点
@property (assign,nonatomic) float fallMax;    //下降最低点
@property (assign,nonatomic) float fallMin;    //下降最高点

@end
