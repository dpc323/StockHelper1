//
//  SearchStockViewController.m
//  StockHelper
//
//  Created by dpc on 17/2/15.
//  Copyright © 2017年 dpc. All rights reserved.
//

#import "SearchStockViewController.h"
#import "ViewController.h"
#import "DPCHTTPRequest.h"
#import "StockPrice.h"
#import "StockPredict.h"

#import "YT_SearchBaseViewController.h"
#import "YT_KeyBoardView.h"
#import "YT_KeyBoardAccessoryView.h"
#import "UITextField+YT_KeyBoard.h"
#import "PYEchartsViewCell.h"
#import "StockResult.h"
#import "StockConfig.h"
#import "StockInfo.h"
#import "StockDao.h"
#import "PredictDao.h"
#import "PredictMarketInfo.h"
#import "PredictMarketDao.h"

#import "DatePredictInfo.h"
#import "DatePredictDao.h"
#import "HighLowInfo.h"
#import "HighLowDao.h"

#import "MarketScoreInfo.h"
#import "MarketScoreDao.h"

#import <math.h>

static int dateCycle = 90;


#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface SearchStockViewController ()<YT_KeyBoardAccessoryViewDelegate, YT_KeyBoardViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *stockTableView;
@property (weak, nonatomic) IBOutlet UITextView *predictView;

@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, strong) YT_KeyBoardView *keyboardView;
@property (nonatomic, strong) YT_KeyBoardAccessoryView *keyboardAccessoryView;

@property (nonatomic, copy) NSString *searchText;

@property (nonatomic, copy) NSString *everyTradeDate;
@property (nonatomic, copy) NSString *tradeDate;
@property (nonatomic, copy) NSString *lastDate;
@property (nonatomic, copy) NSString *longDate;
@property (nonatomic, copy) NSString *shortDate;

@end

@implementation SearchStockViewController
{
    StockPredict *stockPredict;
    NSMutableArray *allStocks;
    
    int upCount;
    int downCount;
    int noChangeCount;
    
    int upOverFive;
    int upDownFive;
    
    float radio;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"日线";
    
    radio = -100;
    
    self.keyBoardType = YT_KeyBoardType_NumBerCharacterSystemLeft;
    self.keyBoardShowStyle = YT_KeyBoardShowStyle_Number;
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 120, WIDTH, 30)];
    self.searchTextField.delegate = self;
    self.searchTextField.inputView = self.keyboardView;
    self.searchTextField.inputAccessoryView = self.keyboardAccessoryView;
    [self.searchTextField becomeFirstResponder];
    self.stockTableView.tableHeaderView = self.searchTextField;
    self.stockTableView.tableFooterView = self.predictView;
//    [self.stockTableView registerNib:[UINib nibWithNibName:@"" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"统计" style:UIBarButtonItemStylePlain target:self action:@selector(totleStocks:)];
    
    allStocks = [[NSMutableArray alloc] init];
    
    [self predictAllStocks];
    
    [NSTimer scheduledTimerWithTimeInterval:900.0 repeats:1 block:^(NSTimer * _Nonnull timer) {
        [self totleStocks:nil];
    }];

//    [self predictAllPoint];
}

- (void)action{
    
}

- (void)totleStocks:(id)sender
{
    
    float score =  upCount+downCount+noChangeCount > 0 ? (float)(upCount-downCount)/(float)(upCount+downCount+noChangeCount)*50 : 0;
 
    __block float scoreRadio = 0;
    __block float volumeScore = 0;

    if (radio == -100) {
        [[DPCHTTPRequest shareInstance] getAddByUrlPath:sinaURL addParams:nil completion:^(id successBlock) {
            if (successBlock == nil || [successBlock isEqual:@{}]) {
                return;
            }
            NSString *str = nil;
            if ([successBlock isKindOfClass:[NSArray class]]) {
                str = [successBlock lastObject];
            }else{
                str = successBlock;
            }
            if (str.length != 0) {
                NSArray *resultArr = [str componentsSeparatedByString:@","];
                if(resultArr.count > 4)
                {
                    radio = [[resultArr objectAtIndex:3] floatValue];
                    scoreRadio = radio*30;

                    if(self.tradeDate.length > 0)
                    {
                        PredictMarketInfo *info = [[PredictMarketInfo alloc] init];
                        info.code = @"000001";
                        info.tradeDate = self.tradeDate;
                        info.upCount = upCount;
                        info.downCount = downCount;
                        info.noChangeCount = noChangeCount;
                        info.radio = radio;
                        info.volume = [[resultArr objectAtIndex:4] doubleValue];
                        
                        PredictMarketDao *dao = [[PredictMarketDao alloc] init];
                        if (self.lastDate.length > 0) {
                            PredictMarketInfo *lastInfo = [[dao queryStockDataByStockCode:@"000001" withTradeDay:self.lastDate] lastObject];
                            if (lastInfo.volume > 0)
                                volumeScore = (info.volume - lastInfo.volume)/lastInfo.volume * radio * 20;
                        }
                        
                        info.score = score + scoreRadio + volumeScore;
                        [dao insertWithEntity:info];
                        
                        //时间点
                        HighLowDao *hlDao = [[HighLowDao alloc] init];
                        DatePredictInfo * datePredictInfo = [hlDao analyseTheTotalCodeWithPredictDate:self.tradeDate];
                        
                        int maxCount = [self getDateCountFromDate:datePredictInfo.highMaxDate];
                        int lowCount = [self getDateCountFromDate:datePredictInfo.lowMaxDate];
                        
                        datePredictInfo.score =
                        pow((dateCycle - maxCount),2)/2 + pow((lowCount - dateCycle),2)/2;

                        DatePredictDao *dateDao = [[DatePredictDao alloc] init];
                        [dateDao insertWithEntity:datePredictInfo];
                        
                        //MarketScoreInfo
                        MarketScoreDao *mScoreDao = [[MarketScoreDao alloc] init];
                        MarketScoreInfo *mScoreInfo = [mScoreDao analyseTheScoreWithPredictDate:self.tradeDate];
                        [mScoreDao insertWithEntity:mScoreInfo];
                    }
                    radio = -100;
                }
            }
            
            NSLog(@"上涨个股%d,下跌个股%d,平盘个股%d;\n涨幅超过5个股%d,跌幅超过5个股%d;\n总评分:%.0f",upCount,downCount,noChangeCount,upOverFive,upDownFive,score + scoreRadio);

        } failedError:^(NSString *failBlock) {
            
        }];
    }
}

- (int)getDateCountFromDate:(NSString*)date
{
    StockDao *sDao = [[StockDao alloc] init];
    int count1 = [sDao queryCountFromDate:date withCode:@"000001"];
    int count2 = [sDao queryCountFromDate:date withCode:@"600001"];
    return MAX(count1, count2);
}

- (void)predictAllStocks
{
    [self printPath];

    NSString *code = @"";
   
    for (int i =1; i <= 2873 ; i++) {
        NSString *intStr = [NSString stringWithFormat:@"%d",i];
        NSString *zeroStr = @"";
        for (int j =1; j<= 4-intStr.length; j++) {
            zeroStr = [zeroStr stringByAppendingString:@"0"];
        }
        code = [NSString stringWithFormat:@"00%@%d",zeroStr,i];
        [self predictAllStocksWithCode:code];
    }
    
    for (int i =0; i<= 663 ;i++) {
        NSString *intStr = [NSString stringWithFormat:@"%d",i];
        NSString *zeroStr = @"";
        for (int j =1; j<= 4-intStr.length; j++) {
            zeroStr = [zeroStr stringByAppendingString:@"0"];
        }
        code = [NSString stringWithFormat:@"30%@%d",zeroStr,i];
        [self predictAllStocksWithCode:code];
    }
    
    for (int i =0; i<= 3977 ; i++) {
        NSString *intStr = [NSString stringWithFormat:@"%d",i];
        NSString *zeroStr = @"";
        for (int j =1; j<= 4-intStr.length; j++) {
           zeroStr = [zeroStr stringByAppendingString:@"0"];
        }
        code = [NSString stringWithFormat:@"60%@%d",zeroStr,i];
        [self predictAllStocksWithCode:code];
    }
    
    if (allStocks.count > 0) {
        [self.stockTableView reloadData];
    }

}

- (void)predictAllStocksWithCode:(NSString *)code
{
    NSString *param = [NSString stringWithFormat:@"code=cn_%@&start=%@&end=%@&period=d",code,@"20160101",[self getCurrentDate]];
    
    [[DPCHTTPRequest shareInstance] getAddByUrlPath:rootURL addParams:param completion:^(id successBlock) {
        if (successBlock == nil || [successBlock isEqual:@{}]) {
            return;
        }
        //      [{"status":0,"hq":[["2017-05-05","12.30","12.14","-0.28","-2.25%","12.06","12.55","150490","18574.91","1.45%"]],"code":"cn_000828"}]
        NSDictionary *dic = successBlock[0];
        if ([[dic objectForKey:@"status"] longValue] == 0) {
            NSString *code = [[dic objectForKey:@"code"] substringWithRange:NSMakeRange(3, 6)];
            NSArray *resultArr = [dic objectForKey:@"hq"];
            NSMutableArray *fetchArr = [[NSMutableArray alloc] init];
            int j = (longDays <= resultArr.count - 1 ? longDays : (int)resultArr.count-1);
            if (resultArr.count <=3) {
                return ;
            }
            
            HighLowInfo *hlInfo = [[HighLowInfo alloc] init];
            
            for(int i = j-1; i >= 0; i--)
            {
                NSArray *stock = [resultArr objectAtIndex:i];
                if(stock.count > 4)
                {
                    StockInfo *info = [[StockInfo alloc] init];
                    info.code = code;
                    info.date = [stock objectAtIndex:0];
                    info.highPrice = [[stock objectAtIndex:6] doubleValue];
                    info.lowPrice = [[stock objectAtIndex:5] doubleValue];
                    info.openPrice = [[stock objectAtIndex:1] doubleValue];
                    info.closePrice = [[stock objectAtIndex:2] doubleValue];
                    info.radio = [[stock objectAtIndex:4] doubleValue];
                    info.volume = [[stock objectAtIndex:7] doubleValue];
                    info.changeRadio = [[stock objectAtIndex:9] doubleValue];
                    [fetchArr addObject:info];
                    
                    //时间预测代码
                    hlInfo.code = code;
                    if (hlInfo.highPrice <= info.closePrice) {
                        hlInfo.highPrice = info.closePrice;
                        hlInfo.highDate = info.date;
                    }
                    
                    if (hlInfo.lowPrice == 0)
                    {
                        hlInfo.lowPrice = info.closePrice;
                    }
                    
                    if (hlInfo.lowPrice >= info.closePrice) {
                        hlInfo.lowPrice = info.closePrice;
                        hlInfo.lowDate = info.date;
                    }

                    if (i == 0 ) {
                        self.everyTradeDate = [stock objectAtIndex:0];
                        if(self.tradeDate.length == 0)
                        {
                            self.tradeDate = [stock objectAtIndex:0];
                        }
//                        else{
//                            NSString *date = [stock objectAtIndex:0];
//                            self.tradeDate = [self getTheLaterDate:self.tradeDate withOtherDay:date];
//                        }
                        if(info.radio > 0)
                        {
                            upCount++;
                            if (info.radio > 5) {
                                upOverFive++;
                            }
                        }else if(info.radio < 0)
                        {
                            downCount++;
                            if (info.radio < -5) {
                                upDownFive++;
                            }
                        }else{
                            noChangeCount++;
                        }
                    }else if(i == 1)
                    {
                        if(self.lastDate.length == 0)
                        {
                            self.lastDate = [stock objectAtIndex:0];
                        }
                    }else if(i == longDays)
                    {
                        if(self.longDate.length == 0)
                        {
                            self.longDate = [stock objectAtIndex:0];
                        }
                    }else if (i == 10)
                    {
                        if(self.shortDate.length == 0)
                        {
                            self.shortDate = [stock objectAtIndex:0];
                        }
                    }
                    
                    if (info.radio > 0) {
                        hlInfo.upCounts++;
                        hlInfo.upRatios+=info.radio;
                    }else if(info.radio < 0){
                        hlInfo.downCounts++;
                        hlInfo.downRatios+=info.radio;
                    }
                }
            }
            
            StockDao *sdao = [[StockDao alloc] init];
            [sdao insertStockInfos:fetchArr];
            
            //插入时间点数据
            HighLowDao *hlDao = [[HighLowDao alloc] init];
            [hlDao insertWithEntity:hlInfo];
//            if ([hlInfo.highDate isEqualToString:@"2017-07-18"]) {
//                NSLog(@"创新高代码：%@",hlInfo.code);
//            }
            stockPredict = [[StockPredict alloc] initWithArray:fetchArr];
            NSString *max_min_result = [stockPredict predictWithMaxAndMin];
            NSString *open_close_result = [stockPredict predictWithOpenAndClose];
            float ratio = stockPredict.ratio;
            
            
            StockResult *stockResult = [[StockResult alloc] init];
            stockResult.stockCode = code;
            stockResult.result = [NSString stringWithFormat:@"%@\n\n%@",max_min_result,open_close_result];
            stockResult.fluctuateRatio = ratio;
            stockResult.tradeDate = self.everyTradeDate;
            //NSLog(@"股票%@,结果%@",stockResult.stockCode,stockResult.result);
            
            if (ratio >= ratioValue && [stockResult.tradeDate isEqualToString:self.tradeDate]) {
                [allStocks addObject:stockResult];
                NSLog(@"\n大于百分20的股票   %@:%f     %@",stockResult.stockCode,stockResult.fluctuateRatio,stockResult.tradeDate);
            }
            /*else if (ratio <= -5 && ratio >= -11)
             {
             [allStocks addObject:stockResult];
             NSLog(@"小于百分5的股票%@:%f",stockResult.stockCode,stockResult.fluctuateRatio);
             }*/
            
            //保存预测数据
//            PredictInfo *info = stockPredict.info;
//            PredictDao *predictDao = [[PredictDao alloc] init];
//            [predictDao insertPredictInfo:info];
            
            //通知主线程刷新
            dispatch_async(dispatch_get_main_queue(), ^{
                if (allStocks.count > 0) {
                    [self.stockTableView reloadData];
                    
                }
            });
            
            /*  static dispatch_once_t onceToken;
             dispatch_once(&onceToken, ^{
             [self saveResultToPlistFile:stockResult];
             });*/
            //保存测试信息
        }
    } failedError:^(NSString *failBlock) {
        
    }];

}

- (NSString*)getTheLaterDate:(NSString*)oneDay withOtherDay:(NSString*)otherDay
{
    NSArray *oneDayArr = [oneDay componentsSeparatedByString:@"-"];
    NSArray *otherDayArr = [otherDay componentsSeparatedByString:@"-"];
    for (int i =0; i < 3; i++) {
        int one = [[oneDayArr objectAtIndex:i] intValue];
        int other = [[otherDayArr objectAtIndex:i] intValue];
        if (one > other) {
            return oneDay;
        }else if(one < other)
        {
            return otherDay;
        }
    }
    return oneDay;
}

- (NSString*)getCurrentDate
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
//    return @"20170925";
}

- (NSString*)plistFilePath
{
    NSString *path = @"";
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    path = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@.plist",DateTime]];
    return path;
}

- (void)printPath
{
    NSLog(@"路径：%@",[self plistFilePath]);
}

- (void)saveResultToPlistFile:(StockResult*)stockResult{
    NSString *path = [self plistFilePath];
    if (path) {
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        NSDictionary *oldDic = [NSDictionary dictionaryWithContentsOfFile:path];
        [result addEntriesFromDictionary:oldDic];
        NSDictionary *codeResult = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%.1f%%", stockResult.fluctuateRatio],stockResult.result] forKeys:@[@"fluctuateRatio",@"detail"]];
        
        [result addEntriesFromDictionary:[NSDictionary dictionaryWithObject:codeResult forKey:[NSString stringWithFormat:@"%@:  %0.2f%%",stockResult.stockCode,stockResult.fluctuateRatio]]];
        
        [result writeToFile:path atomically:NO];
    }else{
        NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
        NSDictionary *codeResult = [NSDictionary dictionaryWithObjects:@[[NSString stringWithFormat:@"%.1f%%", stockResult.fluctuateRatio],stockResult.result] forKeys:@[@"fluctuateRatio",@"detail"]];
        [result addEntriesFromDictionary:[NSDictionary dictionaryWithObject:codeResult forKey:[NSString stringWithFormat:@"%@:  %0.2f%%",stockResult.stockCode,stockResult.fluctuateRatio]]];
        [result writeToFile:path atomically:NO];
    }
}

- (YT_KeyBoardView *)keyboardView {
    if (!_keyboardView) {
        _keyboardView = [[YT_KeyBoardView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 200) keyBoardType:self.keyBoardType keyBoardFirstShowType:self.keyBoardShowStyle delegate:self textField:self.searchTextField];
    }
    return _keyboardView;
}

- (YT_KeyBoardAccessoryView *)keyboardAccessoryView {
    if (!_keyboardAccessoryView) {
        _keyboardAccessoryView = [[YT_KeyBoardAccessoryView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 44) ];
        //_keyboardAccessoryView.backgroundColor = [UIColor brownColor];
        _keyboardAccessoryView.delegate = self.searchTextField;
    }
    
    return _keyboardAccessoryView;
}
#pragma mark - YT_KeyBoardViewDelegate
// TextField 文字改变
- (void)keyBoardView:(YT_KeyBoardView *)keyBoardView changeText:(NSString *)text {
    NSLog(@"text--- %@",text);
    self.searchText = text;
}
// 点击确定按钮
- (void)keyBoardViewShouldConfirm:(YT_KeyBoardView *)keyBoardView {
    NSLog(@"键盘确定按钮点击");
    stockPredict = nil;
    
    if (self.searchText.length == 6) {
        
        NSString *param = [NSString stringWithFormat:@"code=cn_%@&start=%@&end=%@&period=d",self.searchText,@"20160101",[self getCurrentDate]];
        
        [[DPCHTTPRequest shareInstance] getAddByUrlPath:rootURL addParams:param completion:^(id successBlock) {
            if (successBlock == nil || [successBlock[0] isEqual:@{}]) {
                return;
            }
            //      [{"status":0,"hq":[["2017-05-05","12.30","12.14","-0.28","-2.25%","12.06","12.55","150490","18574.91","1.45%"]],"code":"cn_000828"}]
            NSDictionary *dic = successBlock[0];
            if ([[dic objectForKey:@"status"] longValue] == 0) {
                NSString *code = [[dic objectForKey:@"code"] substringWithRange:NSMakeRange(3, 6)];
                NSArray *resultArr = [dic objectForKey:@"hq"];
                NSMutableArray *fetchArr = [[NSMutableArray alloc] init];
                int j = (longDays <= resultArr.count - 1 ? longDays : (int)resultArr.count-1);
                if (resultArr.count <=3) {
                    return ;
                }
                for(int i = j-1; i >= 0; i--)
                {
                    NSArray *stock = [resultArr objectAtIndex:i];
                    if(stock.count > 4)
                    {
                        StockInfo *info = [[StockInfo alloc] init];
                        info.code = code;
                        info.date = [stock objectAtIndex:0];
                        info.highPrice = [[stock objectAtIndex:6] doubleValue];
                        info.lowPrice = [[stock objectAtIndex:5] doubleValue];
                        info.openPrice = [[stock objectAtIndex:1] doubleValue];
                        info.closePrice = [[stock objectAtIndex:2] doubleValue];
                        info.radio = [[stock objectAtIndex:4] doubleValue];
                        info.volume = [[stock objectAtIndex:7] doubleValue];
                        info.changeRadio = [[stock objectAtIndex:9] doubleValue];
                        [fetchArr addObject:info];
                    }
                }
                
                StockDao *dao = [[StockDao alloc] init];
                [dao insertStockInfos:fetchArr];
                
                stockPredict = [[StockPredict alloc] initWithArray:fetchArr];
                NSString *max_min_result = [stockPredict predictWithMaxAndMin];
                NSString *open_close_result = [stockPredict predictWithOpenAndClose];
                float ratio = stockPredict.ratio;
                
                
                StockResult *stockResult = [[StockResult alloc] init];
                stockResult.stockCode = code;
                stockResult.result = [NSString stringWithFormat:@"%@\n\n%@",max_min_result,open_close_result];
                stockResult.fluctuateRatio = ratio;
                //NSLog(@"股票%@,结果%@",stockResult.stockCode,stockResult.result);
                
                if (ratio >= ratioValue) {
                    NSLog(@"\n大于百分20的股票   %@:%f",stockResult.stockCode,stockResult.fluctuateRatio);
                }
                /*else if (ratio <= -5 && ratio >= -11)
                 {
                 [allStocks addObject:stockResult];
                 NSLog(@"小于百分5的股票%@:%f",stockResult.stockCode,stockResult.fluctuateRatio);
                 }*/
                
                //保存预测数据
                //            PredictInfo *info = stockPredict.info;
                //            PredictDao *predictDao = [[PredictDao alloc] init];
                //            [predictDao insertPredictInfo:info];
                
                //通知主线程刷新
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (allStocks.count > 0) {
                        _predictView.text = [NSString stringWithFormat:@"%@\n\n%@",max_min_result,open_close_result];
                        [self.stockTableView reloadData];
                    }
                });
                /*  static dispatch_once_t onceToken;
                 dispatch_once(&onceToken, ^{
                 [self saveResultToPlistFile:stockResult];
                 });*/
                //保存测试信息
            }
        } failedError:^(NSString *failBlock) {
            
        }];
    }

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return allStocks.count+1;
    return allStocks.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%f",self.view.bounds.size.height - _stockTableView.tableFooterView.bounds.size.height -164);
//    if (indexPath.row == 0) {
//        return self.view.bounds.size.height - _stockTableView.tableFooterView.bounds.size.height - 100;
//
//    }
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.row == 0) {
//        PYEchartsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PYEchartsViewCell"];
//        if (!cell)
//        {
//            cell = [[[NSBundle mainBundle] loadNibNamed:@"PYEchartsViewCell" owner:self options:nil] lastObject];
//            cell.stockRatio = stockPredict.stockRatio;
//        }
//        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
//        cell.backgroundColor = [UIColor clearColor];
//        return cell;
//
//    }else{
//        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UITableViewCell *cell = [self.stockTableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        }
//        StockResult *stockResult = [allStocks objectAtIndex:indexPath.row - 1];
        StockResult *stockResult = [allStocks objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@:%f    %@",stockResult.stockCode,stockResult.fluctuateRatio,stockResult.tradeDate];
        return cell;
//    }
}

-(void)pushViewController:(id)sender
{
    ViewController *vc = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
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
