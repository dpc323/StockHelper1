//
//  StockPredict.h
//  StockHelper
//
//  Created by dpc on 17/2/15.
//  Copyright © 2017年 dpc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockRatio.h"
#import "PredictInfo.h"
#import "PredictDao.h"

@interface StockPredict : NSObject
@property (strong, nonatomic) NSMutableArray *stockArr;
@property (strong, nonatomic) StockRatio *stockRatio;
@property (nonatomic, assign) float ratio;
@property (nonatomic, strong) PredictInfo* info;

-(instancetype)initWithArray:(NSMutableArray*)array;
-(NSString*)predictWithOpenAndClose;
-(NSString*)predictWithMaxAndMin;

@end
