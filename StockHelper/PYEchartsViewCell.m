//
//  PYEchartsViewCell.m
//  StockHelper
//
//  Created by dpc on 17/2/20.
//  Copyright © 2017年 dpc. All rights reserved.
//

#import "PYEchartsViewCell.h"

@implementation PYEchartsViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    //NSString *tornadoJson = @"{\"grid\":{\"x\":30,\"x2\":30},\"tooltip\":{\"trigger\":\"axis\",\"axisPointer\":{\"type\":\"shadow\"}},\"legend\":{\"x\":\"right\",\"data\":[\"下降(天)\",\"上升(天)\"]},\"toolbox\":{\"x\":\"left\",\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"line\",\"bar\"]},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"xAxis\":[{\"type\":\"value\"}],\"yAxis\":[{\"type\":\"category\",\"axisTick\":{\"show\":false},\"data\":[\"1.191\",\"1.03\",\"1.382\",\"1.5\",\"1.618\",\"1.8\"]}],\"series\":[{\"name\":\"上升(天)\",\"type\":\"bar\",\"stack\":\"总量\",\"barWidth\":5,\"itemStyle\":{\"normal\":{\"label\":{\"show\":true}}},\"data\":[20,22,41,74,90,80,100]},{\"name\":\"下降(天)\",\"type\":\"bar\",\"stack\":\"总量\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true,\"position\":\"left\"}}},\"data\":[-20,-32,-1,-34,-90,-30,-10]}]}";
    NSString *tornadoJson = [NSString stringWithFormat:@"{\"grid\":{\"x\":30,\"x2\":30},\"tooltip\":{\"trigger\":\"axis\",\"axisPointer\":{\"type\":\"shadow\"}},\"legend\":{\"x\":\"right\",\"data\":[\"下降(天)\",\"上升(天)\"]},\"toolbox\":{\"x\":\"left\",\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"line\",\"bar\"]},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"xAxis\":[{\"type\":\"value\"}],\"yAxis\":[{\"type\":\"category\",\"axisTick\":{\"show\":false},\"data\":[\"1.191\",\"1.382\",\"1.5\",\"1.618\",\"1.8\"]}],\"series\":[{\"name\":\"上升(天)\",\"type\":\"bar\",\"stack\":\"总量\",\"barWidth\":5,\"itemStyle\":{\"normal\":{\"label\":{\"show\":true}}},\"data\":[%d,%d,%d,%d,%d]},{\"name\":\"下降(天)\",\"type\":\"bar\",\"stack\":\"总量\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true,\"position\":\"left\"}}},\"data\":[%d,%d,%d,%d,%d]}]}",_stockRatio.ratioTimes6,_stockRatio.ratioTimes7,_stockRatio.ratioTimes8,_stockRatio.ratioTimes9,_stockRatio.ratioTimes10,_stockRatio.ratioTimes5,_stockRatio.ratioTimes4,_stockRatio.ratioTimes3,_stockRatio.ratioTimes2,_stockRatio.ratioTimes1];

    NSData *jsonData = [tornadoJson dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
    PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
    [_kEchartView setOption:option];
    [_kEchartView loadEcharts];
}

- (void)setStockRatio:(StockRatio *)stockRatio
{
    if (_stockRatio != stockRatio) {
        _stockRatio = stockRatio;
        NSString *tornadoJson = [NSString stringWithFormat:@"{\"grid\":{\"x\":30,\"x2\":30},\"tooltip\":{\"trigger\":\"axis\",\"axisPointer\":{\"type\":\"shadow\"}},\"legend\":{\"x\":\"right\",\"data\":[\"低位(天)\",\"高位(天)\"]},\"toolbox\":{\"x\":\"left\",\"show\":true,\"feature\":{\"mark\":{\"show\":true},\"dataView\":{\"show\":true,\"readOnly\":false},\"magicType\":{\"show\":true,\"type\":[\"line\",\"bar\"]},\"restore\":{\"show\":true},\"saveAsImage\":{\"show\":true}}},\"calculable\":true,\"xAxis\":[{\"type\":\"value\"}],\"yAxis\":[{\"type\":\"category\",\"axisTick\":{\"show\":false},\"data\":[\"一\",\"二\",\"三\",\"四\",\"五\"]}],\"series\":[{\"name\":\"高位(天)\",\"type\":\"bar\",\"stack\":\"总量\",\"barWidth\":5,\"itemStyle\":{\"normal\":{\"label\":{\"show\":true}}},\"data\":[%d,%d,%d,%d,%d]},{\"name\":\"低位(天)\",\"type\":\"bar\",\"stack\":\"总量\",\"itemStyle\":{\"normal\":{\"label\":{\"show\":true,\"position\":\"left\"}}},\"data\":[%d,%d,%d,%d,%d]}]}",stockRatio.ratioTimes6,stockRatio.ratioTimes7,stockRatio.ratioTimes8,stockRatio.ratioTimes9,stockRatio.ratioTimes10,-stockRatio.ratioTimes5,-stockRatio.ratioTimes4,-stockRatio.ratioTimes3,-stockRatio.ratioTimes2,-stockRatio.ratioTimes1];
        
        NSData *jsonData = [tornadoJson dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        PYOption *option = [RMMapper objectWithClass:[PYOption class] fromDictionary:jsonDic];
        [_kEchartView setOption:option];
        [_kEchartView loadEcharts];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
