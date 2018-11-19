//
//  HighLowInfo.h
//  StockHelper
//
//  Created by hanarobot on 17/7/14.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "Entity.h"

@interface HighLowInfo : Entity

@property (nonatomic, copy)NSString *code;

@property (nonatomic, copy)NSString *highDate;

@property (nonatomic, copy)NSString *lowDate;

@property (nonatomic, assign)double highPrice;

@property (nonatomic, assign)double lowPrice;

@property (nonatomic, assign)int upCounts;

@property (nonatomic, assign)int downCounts;

@property (nonatomic, assign)double upRatios;

@property (nonatomic, assign)int downRatios;

@end
