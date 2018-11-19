//
//  StockPredict.m
//  StockHelper
//
//  Created by dpc on 17/2/15.
//  Copyright © 2017年 dpc. All rights reserved.
//

#import "StockPredict.h"
//#import "StockPrice.h"
#import "FourVules.h"
#import "PredictResult.h"
#import "VolumeValue.h"
#import "StockInfo.h"

#define max(x,y) (x > y ? x : y)
#define min(x,y) (x < y ? x : y)
#define BL(x,y) ((x - y) / y)

//Date,Open,High,Low,Close,Volume,Adj Close
//2017-02-14,9.41,9.42,9.37,9.40,36240400,9.40

@implementation StockPredict
{
    FourVules *highPiontValue;
    FourVules *lowPiontValue;
    StockInfo *lastPrice;
    StockInfo *currentPrice;
    PredictResult *highResult;
    PredictResult *lowResult;
    VolumeValue *volumeValue;
}

-(instancetype)init
{
    if (self = [super init]) {
        highPiontValue = [[FourVules alloc] init];
        lowPiontValue = [[FourVules alloc] init];
        lastPrice = [[StockInfo alloc] init];
        currentPrice = [[StockInfo alloc] init];
        highResult = [[PredictResult alloc] init];
        lowResult = [[PredictResult alloc] init];
        volumeValue = [[VolumeValue alloc] init];
        self.stockRatio = [[StockRatio alloc] init];
        _info = [[PredictInfo alloc] init];
    }
    return self;
}
-(instancetype)initWithArray:(NSMutableArray*)array
{
    if (self = [super init]) {
        highPiontValue = [[FourVules alloc] init];
        lowPiontValue = [[FourVules alloc] init];
        lastPrice = [[StockInfo alloc] init];
        currentPrice = [[StockInfo alloc] init];
        highResult = [[PredictResult alloc] init];
        lowResult = [[PredictResult alloc] init];
        volumeValue = [[VolumeValue alloc] init];
        self.stockRatio = [[StockRatio alloc] init];
        _info = [[PredictInfo alloc] init];
        _stockArr = array;
    }
    return self;
}


-(NSString*)predictWithOpenAndClose
{
    StockInfo *stock = [_stockArr lastObject];
    self.stockRatio.currentPrice = stock.closePrice;
    
    for (int i = 1;i < _stockArr.count; i++) {
        lastPrice = [_stockArr objectAtIndex:i-1];
        currentPrice = [_stockArr objectAtIndex:i];
        
        
        //计算值
        
        float highBL = BL(max(currentPrice.openPrice,currentPrice.closePrice), max(lastPrice.openPrice,lastPrice.closePrice))* 100 /100;
        float lowBL = BL(min(currentPrice.openPrice,currentPrice.closePrice), min(lastPrice.openPrice,lastPrice.closePrice))* 100 /100;
        
        //计算高点
        if (highBL > 0) {
            float low = highPiontValue.lowPositivePrice;
            float high = highPiontValue.highPositivePrice;
            highPiontValue.lowPositivePrice = (low == 0 ? highBL : min(low, highBL));
            highPiontValue.highPositivePrice = (high == 0 ? highBL : max(high, highBL));
        }else if(highBL < 0)
        {
            float low = highPiontValue.lowNegativePrice;
            float high = highPiontValue.highNegativePrice;
            highPiontValue.lowNegativePrice = (low == 0 ? highBL : max(low, highBL));
            highPiontValue.highNegativePrice = (high == 0 ? highBL : min(high, highBL));
        }
        
        //计算低点
        if (lowBL > 0) {
            float low = lowPiontValue.lowPositivePrice;
            float high = lowPiontValue.highPositivePrice;
            lowPiontValue.lowPositivePrice = (low == 0 ? highBL : min(low, highBL));
            lowPiontValue.highPositivePrice = (high == 0 ? highBL : max(high, highBL));
        }else if(lowBL < 0)
        {
            float low = lowPiontValue.lowNegativePrice;
            float high = lowPiontValue.highNegativePrice;
            lowPiontValue.lowNegativePrice = (low == 0 ? highBL : max(low, highBL));
            lowPiontValue.highNegativePrice = (high == 0 ? highBL : min(high, highBL));
            
        }
    }
    
    [self computeResult];
    NSString *result = [self computeOpenAndCloseResultString];
    return result;

}
-(NSString*)predictWithMaxAndMin
{
    StockInfo *stock = [_stockArr lastObject];
    self.stockRatio.currentPrice = stock.closePrice;
    
    for (int i = 1;i < _stockArr.count; i++) {
        lastPrice = [_stockArr objectAtIndex:i-1];
        currentPrice = [_stockArr objectAtIndex:i];
        
        //计算出现次数
        [self.stockRatio countAllTimes:currentPrice.closePrice];
        
        //计算值
        float highBL = BL(currentPrice.highPrice, lastPrice.highPrice) * 100 /100;
        float lowBL = BL(currentPrice.lowPrice, lastPrice.lowPrice) * 100 /100;
        
        //计算高点
        if (highBL > 0) {
            float low = highPiontValue.lowPositivePrice;
            float high = highPiontValue.highPositivePrice;
            highPiontValue.lowPositivePrice = (low == 0 ? highBL : min(low, highBL));
            highPiontValue.highPositivePrice = (high == 0 ? highBL : max(high, highBL));
        }else if(highBL < 0)
        {
            float low = highPiontValue.lowNegativePrice;
            float high = highPiontValue.highNegativePrice;
            highPiontValue.lowNegativePrice = (low == 0 ? highBL : max(low, highBL));
            highPiontValue.highNegativePrice = (high == 0 ? highBL : min(high, highBL));
        }
        
        //计算低点
        if (lowBL > 0) {
            float low = lowPiontValue.lowPositivePrice;
            float high = lowPiontValue.highPositivePrice;
            lowPiontValue.lowPositivePrice = (low == 0 ? highBL : min(low, highBL));
            lowPiontValue.highPositivePrice = (high == 0 ? highBL : max(high, highBL));
        }else if(lowBL < 0)
        {
            float low = lowPiontValue.lowNegativePrice;
            float high = lowPiontValue.highNegativePrice;
            lowPiontValue.lowNegativePrice = (low == 0 ? highBL : max(low, highBL));
            lowPiontValue.highNegativePrice = (high == 0 ? highBL : min(high, highBL));
        }
    }
    
    [self computeResult];
    NSString *result = [self computeMaxAndMinResultString];
    return result;
}

- (void)computeResult
{
    highResult.riseMax = currentPrice.highPrice *(1+highPiontValue.highPositivePrice)* 100 /100;
    highResult.riseMin = currentPrice.highPrice *(1+ highPiontValue.lowPositivePrice) * 100 /100;
    highResult.fallMin = currentPrice.lowPrice *(1+ highPiontValue.lowNegativePrice) * 100 /100;
    highResult.fallMax = currentPrice.lowPrice *(1+ highPiontValue.highNegativePrice) * 100 /100;
    
    lowResult.riseMax = currentPrice.lowPrice *(1+ highPiontValue.highPositivePrice) * 100 /100;
    lowResult.riseMin = currentPrice.lowPrice *(1+ highPiontValue.lowPositivePrice) * 100 /100;
    lowResult.fallMin = currentPrice.lowPrice *(1+ highPiontValue.lowNegativePrice) * 100 /100;
    lowResult.fallMax = currentPrice.lowPrice *(1+ highPiontValue.highNegativePrice) * 100 /100;
}

- (NSString*)computeMaxAndMinResultString
{
    NSString *result = @"";
    result = [NSString stringWithFormat:@"  高低点预测结果如下:\n高点最大上涨值%.2f，高点最小上涨值%.2f，高点最小下跌值%.2f，高点最大下跌值%.2f。\n",highResult.riseMax,highResult.riseMin,highResult.fallMin,highResult.fallMax];
    // relust = [NSString stringWithFormat:@"  预测结果如下:\n高点最大上涨值%.2f，高点最小上涨值%.2f，高点最小下跌值%.2f，高点最大下跌值%.2f。",highPiontMax, ,lowPiontMax];
    result = [NSString stringWithFormat:@"%@\n低点最大上涨值%.2f，低点最小上涨值%.2f，低点最小下跌%.2f，低点最大下跌值%.2f。\n",result,lowResult.riseMax,lowResult.riseMin,lowResult.fallMin,lowResult.fallMax];
    
    float max = max(max(highResult.riseMax, highResult.riseMin),max(lowResult.riseMax, lowResult.riseMin));
     float min = min(min(highResult.fallMin, highResult.fallMax),max(lowResult.fallMin, lowResult.fallMax));
    result = [NSString stringWithFormat:@"%@\n最高点预测：%.2f最低点预测：%.2f,平均价格：%.2f,目前价格：%.2f，预测波动空间%.1f%%",result,max,min,(max+min)/2,currentPrice.closePrice,((max+min)/2/currentPrice.closePrice-1)*100];
    
    _info.code = currentPrice.code;
    _info.tradeDate = currentPrice.date;
    _info.highPrice = max;
    _info.lowPrice = min;
    _info.averagePrice =(max+min)/2;
    _info.currentPrice = currentPrice.closePrice;
    _info.predictRidio = ((max+min)/2/currentPrice.closePrice-1)*100;
    
    PredictDao *dao = [[PredictDao alloc] init];
    [dao insertPredictInfo:_info];

    PredictInfo *lastInfo = [dao queryStockDataByStockCode:lastPrice.code withTradeDate:lastPrice.date];
    lastInfo.realRido = (currentPrice.closePrice - currentPrice.openPrice)/currentPrice.openPrice;
    [dao insertPredictInfo:lastInfo];
    
    self.ratio = ((max+min)/2/currentPrice.closePrice-1)*100;
    return result;
}

- (NSString*)computeOpenAndCloseResultString
{
    NSString *result = @"";
    result = [NSString stringWithFormat:@"  开收盘预测结果如下:\n高点最大上涨值%.2f，高点最小上涨值%.2f，高点最小下跌值%.2f，高点最大下跌值%.2f。\n",highResult.riseMax,highResult.riseMin,highResult.fallMin,highResult.fallMax];
    // relust = [NSString stringWithFormat:@"  预测结果如下:\n高点最大上涨值%.2f，高点最小上涨值%.2f，高点最小下跌值%.2f，高点最大下跌值%.2f。",highPiontMax, ,lowPiontMax];
    result = [NSString stringWithFormat:@"%@\n低点最大上涨值%.2f，低点最小上涨值%.2f，低点最小下跌%.2f，低点最大下跌值%.2f。\n",result,lowResult.riseMax,lowResult.riseMin,lowResult.fallMin,lowResult.fallMax];
    
    float max = max(max(highResult.riseMax, highResult.riseMin),max(lowResult.riseMax, lowResult.riseMin));
    float min = min(min(highResult.fallMin, highResult.fallMax),max(lowResult.fallMin, lowResult.fallMax));
    result = [NSString stringWithFormat:@"%@\n最高点预测：%.2f最低点预测：%.2f,平均价格：%.2f,目前价格：%.2f，预测波动空间%.1f%%",result,max,min,(max+min)/2,currentPrice.closePrice,((max+min)/2/currentPrice.closePrice-1)*100];
    self.ratio = (min(self.ratio, (max+min)/2/currentPrice.closePrice-1))*100;
    return result;
}


//1、预测成交量 2、预测成交量变化跟上涨下跌的关系
- (void)preidctVolumeAndRadioModel
{
    currentPrice = [_stockArr lastObject];
    
    for (int i = 1;i < _stockArr.count; i++) {
        lastPrice = [_stockArr objectAtIndex:i-1];
        currentPrice = [_stockArr objectAtIndex:i];
        float volumeBL = BL(currentPrice.volume, lastPrice.volume) * 100 /100;
        
        //计算高点
        if (volumeBL > 0) {
//            float low = highPiontValue.lowPositivePrice;
            float max = volumeValue.maxVolumeRadio;
//            highPiontValue.lowPositivePrice = (low == 0 ? highBL : min(low, highBL));
//            highPiontValue.highPositivePrice = (high == 0 ? highBL : max(high, highBL));
            volumeValue.maxVolumeRadio = (max == 0 ? volumeBL : max(max,volumeBL));
            /*
             if (highPiontValue.lowPositivePrice == 0) {
             highPiontValue.lowPositivePrice = highBL;
             }else{
             highPiontValue.highPositivePrice = max(highPiontValue.lowPositivePrice, highBL);
             if (highBL == highPiontValue.highPositivePrice) {
             highPiontValue.lowPositivePrice = min(highPiontValue.lowPositivePrice, highBL);
             }else{
             highPiontValue.lowPositivePrice = min(highPiontValue.highPositivePrice, highBL);
             }
             }
             */
        }else if(volumeBL < 0)
        {
            float min = volumeValue.maxVolumeRadio;
            volumeValue.maxVolumeRadio = (min == 0 ? volumeBL : min(min,volumeBL));
        }
        
    }
    
    float maxVolume = currentPrice.volume*(1+volumeValue.maxVolumeRadio);
    float minVolume = currentPrice.volume*(1+volumeValue.minVolumeRadio);
    float aveVolume = (maxVolume + minVolume)/2;
    _info.predictVolume = aveVolume;
    PredictDao *dao = [[PredictDao alloc] init];
    PredictInfo *lastInfo = [dao queryStockDataByStockCode:lastPrice.code withTradeDate:lastPrice.date];
    lastInfo.realVolume = currentPrice.volume;
    [dao insertWithEntity:lastInfo];
    
//    for (int i = 1;i < _stockArr.count; i++) {
//        lastPrice = [_stockArr objectAtIndex:i-1];
//        currentPrice = [_stockArr objectAtIndex:i];
//        
//        float volumeBL = BL(currentPrice.volume, lastPrice.volume) * 100 /100;
//        
//        //计算高点
//        if (volumeBL > 0) {
//            //            float low = highPiontValue.lowPositivePrice;
//            float max = volumeValue.maxVolumeRadio;
//            //            highPiontValue.lowPositivePrice = (low == 0 ? highBL : min(low, highBL));
//            //            highPiontValue.highPositivePrice = (high == 0 ? highBL : max(high, highBL));
//            volumeValue.maxVolumeRadio = (max == 0 ? volumeBL : max(max,volumeBL));
//            /*
//             if (highPiontValue.lowPositivePrice == 0) {
//             highPiontValue.lowPositivePrice = highBL;
//             }else{
//             highPiontValue.highPositivePrice = max(highPiontValue.lowPositivePrice, highBL);
//             if (highBL == highPiontValue.highPositivePrice) {
//             highPiontValue.lowPositivePrice = min(highPiontValue.lowPositivePrice, highBL);
//             }else{
//             highPiontValue.lowPositivePrice = min(highPiontValue.highPositivePrice, highBL);
//             }
//             }
//             */
//        }else if(volumeBL < 0)
//        {
//            float min = volumeValue.maxVolumeRadio;
//            volumeValue.maxVolumeRadio = (min == 0 ? volumeBL : min(min,volumeBL));
//        }
//        
//    }
//
    
//    [self computeResult];
//    NSString *result = [self computeMaxAndMinResultString];
//    return result;

}

@end
