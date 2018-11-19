//
//  DatePredictInfo.h
//  StockHelper
//
//  Created by hanarobot on 17/7/14.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "Entity.h"

@interface DatePredictInfo : Entity

@property (nonatomic, copy)NSString *predictDate;

@property (nonatomic, copy)NSString *highMaxDate;

@property (nonatomic, copy)NSString *lowMaxDate;

@property (nonatomic, assign)int highMaxCount;

@property (nonatomic, assign)int lowMaxCount;

@property (nonatomic, assign)int currentHighCount;

@property (nonatomic, assign)int currentLowCount;

@property (nonatomic, assign)double score;

@end
