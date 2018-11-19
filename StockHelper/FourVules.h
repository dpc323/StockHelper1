//
//  FourVules.h
//  StockHelper
//
//  Created by dpc on 17/2/14.
//  Copyright © 2017年 dpc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FourVules : NSObject
@property (assign,nonatomic) float highPositivePrice;  //最大正整数
@property (assign,nonatomic) float lowPositivePrice;   //最小正整数
@property (assign,nonatomic) float highNegativePrice;  //最大负整数
@property (assign,nonatomic) float lowNegativePrice;   //最小负整数

@end
