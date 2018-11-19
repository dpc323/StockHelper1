//
//  MarketScoreInfo.h
//  StockHelper
//
//  Created by 邓鹏程 on 2017/8/13.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "Entity.h"

@interface MarketScoreInfo : Entity

@property (nonatomic, copy)NSString *tradeDate;

@property (nonatomic, assign)double sumScore;

@property (nonatomic, assign)double sumScore10;

@property (nonatomic, assign)double predictScore;

@property (nonatomic, assign)WhichMarket market;

@end
