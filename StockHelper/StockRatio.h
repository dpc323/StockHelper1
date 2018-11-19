//
//  StockRatio.h
//  StockHelper
//
//  Created by dpc on 17/2/21.
//  Copyright © 2017年 dpc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockRatio : NSObject

@property (nonatomic, assign) float currentPrice;

@property (nonatomic, assign) float ratioPrice1;
@property (nonatomic, assign) float ratioPrice2;
@property (nonatomic, assign) float ratioPrice3;
@property (nonatomic, assign) float ratioPrice4;
@property (nonatomic, assign) float ratioPrice5;
@property (nonatomic, assign) float ratioPrice6;
@property (nonatomic, assign) float ratioPrice7;
@property (nonatomic, assign) float ratioPrice8;
@property (nonatomic, assign) float ratioPrice9;
@property (nonatomic, assign) float ratioPrice10;

@property (nonatomic, assign) int ratioTimes1;
@property (nonatomic, assign) int ratioTimes2;
@property (nonatomic, assign) int ratioTimes3;
@property (nonatomic, assign) int ratioTimes4;
@property (nonatomic, assign) int ratioTimes5;
@property (nonatomic, assign) int ratioTimes6;
@property (nonatomic, assign) int ratioTimes7;
@property (nonatomic, assign) int ratioTimes8;
@property (nonatomic, assign) int ratioTimes9;
@property (nonatomic, assign) int ratioTimes10;

- (void)countAllTimes:(float)countPrice;
@end
