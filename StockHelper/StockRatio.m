//
//  StockRatio.m
//  StockHelper
//
//  Created by dpc on 17/2/21.
//  Copyright © 2017年 dpc. All rights reserved.
//

#import "StockRatio.h"

#define count(a,b,c) b-(a+c)/2

@implementation StockRatio

- (void)setCurrentPrice:(float)currentPrice
{
    if (_currentPrice != currentPrice) {
        _currentPrice = currentPrice;
        
        _ratioPrice1 = currentPrice / 1.08;
        _ratioPrice2 = currentPrice / 1.0618;
        _ratioPrice3 = currentPrice / 1.05;
        _ratioPrice4 = currentPrice / 1.0382;
        _ratioPrice5 = currentPrice / 1.0191;
        _ratioPrice6 = currentPrice * 1.0191;
        _ratioPrice7 = currentPrice * 1.0382;
        _ratioPrice8 = currentPrice * 1.05;
        _ratioPrice9 = currentPrice * 1.0618;
        _ratioPrice10 = currentPrice * 1.08;


    }
}

- (void)countAllTimes:(float)countPrice
{
    if (countPrice <= _ratioPrice1) {
        _ratioTimes1++;
    }else if (countPrice >= _ratioPrice1 && countPrice < _ratioPrice2)
    {
        if (count(_ratioPrice1,countPrice,_ratioPrice2) < 0) {
            _ratioTimes1++;
        }else if(count(_ratioPrice1,countPrice,_ratioPrice2) < 0){
            _ratioTimes2++;
        }
    }else if (countPrice >= _ratioPrice2 && countPrice < _ratioPrice3)
    {
        if (count(_ratioPrice2,countPrice,_ratioPrice3) < 0) {
            _ratioTimes2++;
        }else if(count(_ratioPrice2,countPrice,_ratioPrice3) < 0){
            _ratioTimes3++;
        }
    }else if (countPrice >= _ratioPrice3 && countPrice < _ratioPrice4)
    {
        if (count(_ratioPrice3,countPrice,_ratioPrice4) < 0) {
            _ratioTimes3++;
        }else if(count(_ratioPrice3,countPrice,_ratioPrice4) < 0){
            _ratioTimes4++;
        }
    }else if (countPrice >= _ratioPrice4 && countPrice < _ratioPrice5)
    {
        if (count(_ratioPrice4,countPrice,_ratioPrice5) < 0) {
            _ratioTimes4++;
        }else if(count(_ratioPrice4,countPrice,_ratioPrice5) < 0){
            _ratioTimes5++;
        }
    }else if (countPrice >= _ratioPrice5 && countPrice < _ratioPrice6)
    {
        if (count(_ratioPrice5,countPrice,_ratioPrice6) < 0) {
            _ratioTimes5++;
        }else if(count(_ratioPrice5,countPrice,_ratioPrice6) < 0){
            _ratioTimes6++;
        }
    }else if (countPrice >= _ratioPrice6 && countPrice < _ratioPrice7)
    {
        if (count(_ratioPrice6,countPrice,_ratioPrice7) < 0) {
            _ratioTimes6++;
        }else if(count(_ratioPrice6,countPrice,_ratioPrice7) < 0){
            _ratioTimes7++;
        }
    }else if (countPrice >= _ratioPrice7 && countPrice < _ratioPrice8)
    {
        if (count(_ratioPrice7,countPrice,_ratioPrice8) < 0) {
            _ratioTimes7++;
        }else if(count(_ratioPrice7,countPrice,_ratioPrice8) < 0){
            _ratioTimes8++;
        }
    }else if (countPrice >= _ratioPrice8 && countPrice < _ratioPrice9)
    {
        if (count(_ratioPrice8,countPrice,_ratioPrice9) < 0) {
            _ratioTimes8++;
        }else if(count(_ratioPrice8,countPrice,_ratioPrice9) < 0){
            _ratioTimes9++;
        }
    }else if (countPrice >= _ratioPrice9 && countPrice < _ratioPrice10)
    {
        if (count(_ratioPrice9,countPrice,_ratioPrice10) < 0) {
            _ratioTimes9++;
        }else if(count(_ratioPrice2,countPrice,_ratioPrice3) < 0){
            _ratioTimes10++;
        }
    }else if (countPrice <= _currentPrice*2)
    {
        _ratioTimes10++;
    }
}
@end
