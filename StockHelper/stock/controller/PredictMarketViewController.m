//
//  PredictMarketViewController.m
//  StockHelper
//
//  Created by hanarobot on 17/4/4.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "PredictMarketViewController.h"
#import "DPCHTTPRequest.h"
#import "StockInfo.h"
#import "StockPredict.h"
#import "MarketDao.h"
#import "StockResult.h"

@interface PredictMarketViewController ()
{
    StockPredict *stockPredict;
    NSMutableArray *allStocks;
    UILabel *marketLab;
    UISegmentedControl *segmentCtr;
}
@end

@implementation PredictMarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    marketLab.frame = self.view.bounds;
    
    [self.view addSubview:marketLab];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    segmentCtr = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"000001",@"399001",@"000300", nil]];
   UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"上证" style:UIBarButtonItemStylePlain target:self action:@selector(predictAllPoint:)];
   UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"深证" style:UIBarButtonItemStylePlain target:self action:@selector(predictAllPoint:)];
   UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"沪深300" style:UIBarButtonItemStylePlain target:self action:@selector(predictAllPoint:)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:item1, item2, item3, nil];

}
- (void)predictAllPoint:(UIBarButtonItem*)item
{
    if([item.title isEqualToString:@"上证"])
    {
        [self predictMarketWithCode:@"000001.ss"];
    }else if([item.title isEqualToString:@"深证"])
    {
        [self predictMarketWithCode:@"399001.SZ"];

    }else if([item.title isEqualToString:@"沪深300"])
    {
        [self predictMarketWithCode:@"000300.ss"];
    }
}

- (void)predictMarketWithCode:(NSString *)code
{
    NSString *url = [NSString stringWithFormat:@"%@?s=%@",rootURL,code];
    [[DPCHTTPRequest shareInstance] getAddByUrlPath:url addParams:nil completion:^(id successBlock) {
        NSDictionary *dic = successBlock;
        if (dic) {
            NSString *result = [[dic allValues] lastObject];
            NSArray *resultArr = [result componentsSeparatedByString:@"\n"];
            NSMutableArray *fetchArr = [[NSMutableArray alloc] init];
            int j = (longDays <= resultArr.count - 1 ? longDays : (int)resultArr.count-1);
            if (resultArr.count <=3) {
                return ;
            }
            
            for(int i = j; i > 0; i--)
            {
                NSString *stockStr = [resultArr objectAtIndex:i];
                NSArray *stock = [stockStr componentsSeparatedByString:@","];
                if(stock.count > 4)
                {
                    StockInfo *info = [[StockInfo alloc] init];
                    info.code = [code substringToIndex:6];
                    info.date = [stock objectAtIndex:0];
                    info.highPrice = [[stock objectAtIndex:2] doubleValue];
                    info.lowPrice = [[stock objectAtIndex:3] doubleValue];
                    info.openPrice = [[stock objectAtIndex:1] doubleValue];
                    info.closePrice = [[stock objectAtIndex:4] doubleValue];
                    info.volume = [[stock objectAtIndex:5] doubleValue];
                    [fetchArr addObject:info];
                }
            }
            
            MarketDao *dao = [[MarketDao alloc] init];
            [dao insertStockInfos:fetchArr];
            
            stockPredict = [[StockPredict alloc] initWithArray:fetchArr];
            NSString *max_min_result = [stockPredict predictWithMaxAndMin];
            NSString *open_close_result = [stockPredict predictWithOpenAndClose];
            float ratio = stockPredict.ratio;
            
            StockResult *stockResult = [[StockResult alloc] init];
            stockResult.stockCode = [code substringToIndex:6];
            stockResult.result = [NSString stringWithFormat:@"%@\n\n%@",max_min_result,open_close_result];
            stockResult.fluctuateRatio = ratio;
            //NSLog(@"股票%@,结果%@",stockResult.stockCode,stockResult.result);
          
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调或者说是通知主线程刷新，
                NSString *text = [NSString stringWithFormat:@"大盘：%@\n\n%@",max_min_result,open_close_result];
                marketLab.text = text;
            });
        }
    } failedError:^(NSString *failBlock) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
