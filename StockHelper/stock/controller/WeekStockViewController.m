//
//  WeekStockViewController.m
//  StockHelper
//
//  Created by hanarobot on 17/5/6.
//  Copyright © 2017年 hana. All rights reserved.
//

#import "WeekStockViewController.h"
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

#define WIDTH [UIScreen mainScreen].bounds.size.width

@interface WeekStockViewController ()<YT_KeyBoardAccessoryViewDelegate, YT_KeyBoardViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *stockTableView;
@property (weak, nonatomic) IBOutlet UITextView *predictView;

@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, strong) YT_KeyBoardView *keyboardView;
@property (nonatomic, strong) YT_KeyBoardAccessoryView *keyboardAccessoryView;

@property (nonatomic, copy) NSString *searchText;

@end

@implementation WeekStockViewController
{
    StockPredict *stockPredict;
    NSMutableArray *allStocks;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"周线";
    
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
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"手动" style:UIBarButtonItemStylePlain target:self action:@selector(getWeekDatas:)];
    
    allStocks = [[NSMutableArray alloc] init];
    
    [self predictAllStocks];
    //    [self predictAllPoint];
}

//- (void)predictAllPoint
//{
//    [self predictAllPoint:@"000001.ss"];
//    [self predictAllPoint:@"399001.SZ"];
//    [self predictAllPoint:@"000300.ss"];
//}

//- (void)predictAllPoint:(NSString *)market
//{
//    NSString *url = [NSString stringWithFormat:@"%@?s=%@",rootURL,market];
//    [[DPCHTTPRequest shareInstance] getAddByUrlPath:url addParams:nil completion:^(id successBlock) {
//        NSDictionary *dic = successBlock;
//        if (dic) {
//            NSString *result = [[dic allValues] lastObject];
//            NSArray *resultArr = [result componentsSeparatedByString:@"\n"];
//            NSMutableArray *fetchArr = [[NSMutableArray alloc] init];
//            int j = (longDays <= resultArr.count - 1 ? longDays : (int)resultArr.count-1);
//            if (resultArr.count <=3) {
//                return ;
//            }
//            for(int i = j; i > 0; i--)
//            {
//                NSString *stockStr = [resultArr objectAtIndex:i];
//                NSArray *stock = [stockStr componentsSeparatedByString:@","];
//                if(stock.count > 4)
//                {
//                    StockPrice *stockModel = [[StockPrice alloc] init];
//                    stockModel.date = [stock objectAtIndex:0];
//                    //                stockModel.code = code;
//                    stockModel.openPrice = [[stock objectAtIndex:1] floatValue];
//                    stockModel.highPrice = [[stock objectAtIndex:2] floatValue];
//                    stockModel.lowPrice = [[stock objectAtIndex:3] floatValue];
//                    stockModel.closePrice = [[stock objectAtIndex:4] floatValue];
//                    [fetchArr addObject:stockModel];
//                }
//            }
//
//            stockPredict = [[StockPredict alloc] initWithArray:fetchArr];
//            NSString *max_min_result = [stockPredict predictWithMaxAndMin];
//            NSString *open_close_result = [stockPredict predictWithOpenAndClose];
//
//            //通知主线程刷新
//            dispatch_async(dispatch_get_main_queue(), ^{
//                //回调或者说是通知主线程刷新，
//                NSString *log = [NSString stringWithFormat:@"大盘：%@\n\n%@",max_min_result,open_close_result];
//                NSLog(@"%@",log);
//            });
//        }
//    } failedError:^(NSString *failBlock) {
//
//    }];
//}

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
    
    for (int i =0; i<= 663 ; i++) {
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
    NSString *param = [NSString stringWithFormat:@"code=cn_%@&start=%@&end=%@&period=w",code,@"20160101",[self getCurrentDate]];
    __block float sumPrice =0;
    __block float currentPrice =0;
    __block NSString *tradeDate =nil;
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
            
            sumPrice = 0;
            currentPrice = 0;
            
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
                    sumPrice += info.closePrice;
                    info.radio = [[stock objectAtIndex:4] doubleValue];
                    info.volume = [[stock objectAtIndex:7] doubleValue];
                    info.changeRadio = [[stock objectAtIndex:9] doubleValue];
                    [fetchArr addObject:info];
                    
                    if (currentPrice == 0) {
                        if (i == 0) {
                            currentPrice = info.closePrice;
                            tradeDate = info.date;
                        }
                    }
                }
            }
            
            if (sumPrice >0) {
                sumPrice /= j;
            }
#pragma mark buttomFeild
            if (sumPrice > currentPrice) {
                return;
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
            stockResult.tradeDate = tradeDate;

            //NSLog(@"股票%@,结果%@",stockResult.stockCode,stockResult.result);
            
            if (ratio >= weekRatioValue) {
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

- (NSString*)getCurrentDate
{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMdd"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
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
        
        NSString *param = [NSString stringWithFormat:@"code=cn_%@&start=%@&end=%@&period=w",self.searchText,@"20160101",[self getCurrentDate]];
        
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
                
                //            StockDao *dao = [[StockDao alloc] init];
                //            [dao insertStockInfos:fetchArr];
                
                stockPredict = [[StockPredict alloc] initWithArray:fetchArr];
                NSString *max_min_result = [stockPredict predictWithMaxAndMin];
                NSString *open_close_result = [stockPredict predictWithOpenAndClose];
                float ratio = stockPredict.ratio;
                
                
                StockResult *stockResult = [[StockResult alloc] init];
                stockResult.stockCode = code;
                stockResult.result = [NSString stringWithFormat:@"%@\n\n%@",max_min_result,open_close_result];
                stockResult.fluctuateRatio = ratio;
                //NSLog(@"股票%@,结果%@",stockResult.stockCode,stockResult.result);
                
                if (ratio >= weekRatioValue) {
                    [allStocks addObject:stockResult];
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

-(void)getWeekDatas:(id)sender
{
    [self predictAllStocks];

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
