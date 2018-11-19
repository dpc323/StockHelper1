//
//  StockInfo.h
//  StockDataBase
//
//  Created by hanarobot on 17/3/22.
//  Copyright © 2017年 dpc. All rights reserved.
//

#import "Entity.h"

//[{"status":0,"hq":[["2017-04-26","10.10","10.19","0.10","0.99%","10.04","10.22","67772","6859.82","0.71%"],["2017-04-25","10.30","10.09","-0.15","-1.46%","10.03","10.43","77349","7919.39","0.81%"]],"code":"cn_000829"}]

@interface StockInfo : Entity

@property (nonatomic, copy)NSString *code;

@property (nonatomic, copy)NSString *date;

@property (nonatomic, assign)double highPrice;

@property (nonatomic, assign)double lowPrice;

@property (nonatomic, assign)double openPrice;

@property (nonatomic, assign)double closePrice;

@property (nonatomic, assign)double radio;

@property (nonatomic, assign)double volume;

@property (nonatomic, assign)double changeRadio;

@end
