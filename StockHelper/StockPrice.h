//
//  StockPrice.h
//  StockHelper
//
//  Created by dpc on 17/2/14.
//  Copyright © 2017年 dpc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JKDBModel.h"

@interface StockPrice : NSObject
@property (copy,nonatomic) NSString *date;
@property (copy,nonatomic) NSString *code;
@property (assign,nonatomic) float openPrice;
@property (assign,nonatomic) float closePrice;
@property (assign,nonatomic) float highPrice;
@property (assign,nonatomic) float lowPrice;
@property (assign,nonatomic) float volume;
@end


