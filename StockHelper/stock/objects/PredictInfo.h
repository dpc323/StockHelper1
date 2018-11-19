//
//  PredictInfo.h
//  StockHelper
//
//  Created by 邓鹏程 on 2017/4/3.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "Entity.h"


@interface PredictInfo : Entity

@property (nonatomic, copy)NSString *code;

@property (nonatomic, copy)NSString *tradeDate;

@property (nonatomic, assign)double highPrice;

@property (nonatomic, assign)double lowPrice;

@property (nonatomic, assign)double averagePrice;

@property (nonatomic, assign)double currentPrice;

@property (nonatomic, assign)double predictRidio;

@property (nonatomic, assign)double realRido;

@property (nonatomic, assign)double predictVolume;

@property (nonatomic, assign)double realVolume;


@end
