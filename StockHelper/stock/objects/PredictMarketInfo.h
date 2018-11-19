//
//  PredictMarketInfo.h
//  StockHelper
//
//  Created by 邓鹏程 on 2017/5/5.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "Entity.h"

@interface PredictMarketInfo : Entity

@property (nonatomic, copy)NSString *code;

@property (nonatomic, copy)NSString *tradeDate;

@property (nonatomic, assign)double upCount;

@property (nonatomic, assign)double downCount;

@property (nonatomic, assign)double noChangeCount;

@property (nonatomic, assign)double radio;

@property (nonatomic, assign)double volume;

@property (nonatomic, assign)double score;

@end
