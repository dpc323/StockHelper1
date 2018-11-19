//
//  StockRequestManage.m
//  StockHelper
//
//  Created by hanarobot on 17/4/26.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "StockRequestManage.h"
#import "StockInfo.h"
#import "MarketDao.h"
#import "StockDao.h"

@implementation StockRequestManage
{
    NSMutableArray *allStocks;
}

- (id)init{
    if([super init])
    {
        allStocks = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)getAllPoint
{

    [self getMarketWithCode:@"000001.ss"];
    [self getMarketWithCode:@"399001.SZ"];
    [self getMarketWithCode:@"000300.ss"];

}

- (void)getMarketWithCode:(NSString *)code
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
            
        }
    } failedError:^(NSString *failBlock) {
        
    }];
}


- (void)getAllStocks
{
    [self printPath];
    
    NSString *code = @"";
    
    for (int i =1; i <= 2856 ; i++) {
        NSString *intStr = [NSString stringWithFormat:@"%d",i];
        NSString *zeroStr = @"";
        for (int j =1; j<= 4-intStr.length; j++) {
            zeroStr = [zeroStr stringByAppendingString:@"0"];
        }
        code = [NSString stringWithFormat:@"00%@%d",zeroStr,i];
        [self getAllStocksWithCode:code];
    }
    
    for (int i =0; i<= 3979 ; i++) {
        NSString *intStr = [NSString stringWithFormat:@"%d",i];
        NSString *zeroStr = @"";
        for (int j =1; j<= 4-intStr.length; j++) {
            zeroStr = [zeroStr stringByAppendingString:@"0"];
        }
        code = [NSString stringWithFormat:@"60%@%d",zeroStr,i];
        [self getAllStocksWithCode:code];
    }

}


- (void)printPath
{
    NSLog(@"路径：%@",[self plistFilePath]);
}

- (NSString*)plistFilePath
{
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.plist",[self getDateTime]]];
    return path;
}
- (NSString*)getDateTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *dateTime = [formatter stringFromDate:date];
    return dateTime;
}

- (void)getAllStocksWithCode:(NSString *)code
{
    NSString *param = @"";
#ifndef yahoo
    if ([[code substringToIndex:2] isEqualToString:@"60"]) {
        param = [NSString stringWithFormat:@"s=%@.%@",code, @"ss"];
        
    }else if([[code substringToIndex:2] isEqualToString:@"30"] || [[code substringToIndex:2]  isEqualToString:@"00"]){
        param = [NSString stringWithFormat:@"s=%@.%@",code,@"sz"];
    }
#else
    //http://q.stock.sohu.com/hisHq?code=cn_601766,cn_000002&start=20170401&end=20170419
    //此处需获取时间
    param = [NSString stringWithFormat:@"code=cn_%@&start=%@&end=%@",code,[self getDateTime],[self getDateTime]];
    //周线数据 http://q.stock.sohu.com/hisHq?code=cn_000829&start=20170125&end=20170426&period=w
#endif
    [[DPCHTTPRequest shareInstance] getAddByUrlPath:rootURL addParams:param completion:^(id successBlock) {
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
                    info.code = [[dic allKeys] lastObject];
                    info.date = [stock objectAtIndex:0];
                    info.highPrice = [[stock objectAtIndex:2] doubleValue];
                    info.lowPrice = [[stock objectAtIndex:3] doubleValue];
                    info.openPrice = [[stock objectAtIndex:1] doubleValue];
                    info.closePrice = [[stock objectAtIndex:4] doubleValue];
                    info.volume = [[stock objectAtIndex:5] doubleValue];
                    [fetchArr addObject:info];
                    
                }
            }
            
            StockDao *dao = [[StockDao alloc] init];
            [dao insertStockInfos:fetchArr];
          }
    } failedError:^(NSString *failBlock) {
        
    }];
}

@end
