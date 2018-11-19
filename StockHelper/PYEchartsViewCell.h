//
//  PYEchartsViewCell.h
//  StockHelper
//
//  Created by dpc on 17/2/20.
//  Copyright © 2017年 dpc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PYEchartsView.h"
#import "StockRatio.h"

@interface PYEchartsViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet PYEchartsView *kEchartView;
@property (nonatomic, strong) StockRatio *stockRatio;

@end
