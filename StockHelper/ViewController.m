//
//  ViewController.m
//  StockHelper
//
//  Created by dpc on 17/2/14.
//  Copyright © 2017年 dpc. All rights reserved.
//


//唯趋势而为 周期5，7天

#import "ViewController.h"
#import "StockPrice.h"
#import "FourVules.h"

#define shortDays 5
#define days 21
#define longDays 105

#define max(x,y) (x > y ? x : y)*100/100
#define min(x,y) (x < y ? x : y)*100/100
#define BL(x,y) ((x - y) / y)

//Date,Open,High,Low,Close,Volume,Adj Close
//2017-02-14,9.41,9.42,9.37,9.40,36240400,9.40

@interface ViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;
@property (weak, nonatomic) IBOutlet UIButton *predictBtn;
@property (weak, nonatomic) IBOutlet UITextView *resultView;
@property (weak, nonatomic) IBOutlet UITextField *highPiont;
@property (weak, nonatomic) IBOutlet UITextField *lowPiont;
@property (strong, nonatomic) NSMutableArray *stockArr;

@property (strong, nonatomic) FourVules *highPiontValue;
@property (strong, nonatomic) FourVules *lowPiontValue;

@property (strong, nonatomic) StockPrice *lastPrice;
@property (strong, nonatomic) StockPrice *currentPrice;

//@property (strong, nonatomic) FourVules *resultHighValue;
//@property (strong, nonatomic) FourVules *resultLowValue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"手动输入数据";
    _stockArr = [[NSMutableArray alloc] init];
    _highPiontValue = [[FourVules alloc] init];
    _lowPiontValue = [[FourVules alloc] init];
    
    _lastPrice = [[StockPrice alloc] init];
    _currentPrice = [[StockPrice alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)next:(id)sender {
    if (!_highPiont.text || !_lowPiont.text) {
        [_highPiont becomeFirstResponder];
        return;
    }
  
    if (_stockArr.count < days) {
        
        StockPrice *stockPrice = [[StockPrice alloc] init];
        stockPrice.highPrice = [_highPiont.text floatValue] * 100 / 100 ;
        stockPrice.lowPrice = [_lowPiont.text floatValue] * 100 / 100; 
        
        [_stockArr addObject:stockPrice];
        
        self.dayLabel.text = [NSString stringWithFormat:@"第%lu天",(unsigned long)_stockArr.count+1];

        if (_currentPrice) {
            _lastPrice = _currentPrice;
        }
        _currentPrice = stockPrice;
        
        if(_stockArr.count > 1)
        {
            //计算值
            float highBL = BL(_currentPrice.highPrice, _lastPrice.highPrice);
            float lowBL = BL(_currentPrice.lowPrice, _lastPrice.lowPrice);
            
            //计算高点
            if (highBL >= 0) {
                if (_highPiontValue.lowPositivePrice == 0) {
                    _highPiontValue.lowPositivePrice = highBL;
                }else{
                    _highPiontValue.highPositivePrice = max(_highPiontValue.lowPositivePrice, highBL);
                    if (highBL == _highPiontValue.highPositivePrice) {
                        _highPiontValue.lowPositivePrice = min(_highPiontValue.lowPositivePrice, highBL);
                    }else{
                        _highPiontValue.lowPositivePrice = min(_highPiontValue.highPositivePrice, highBL);
                    }
                }
            }else if(highBL < 0)
            {
                if (_highPiontValue.lowNegativePrice == 0) {
                    _highPiontValue.lowNegativePrice = highBL;
                }else{
                    _highPiontValue.highNegativePrice = min(_highPiontValue.lowNegativePrice, highBL);
                    if (highBL == _highPiontValue.highNegativePrice) {
                        _highPiontValue.lowNegativePrice = max(_highPiontValue.lowNegativePrice, highBL);
                    }else{
                        _highPiontValue.lowNegativePrice = max(_highPiontValue.highNegativePrice, highBL);
                    }
                }
            }
            
            //计算低点
            if (lowBL >= 0) {
                if (_lowPiontValue.lowPositivePrice == 0) {
                    _lowPiontValue.lowPositivePrice = lowBL;
                }else{
                    _lowPiontValue.highPositivePrice = max(_lowPiontValue.lowPositivePrice, lowBL);
                    if (highBL == _highPiontValue.highPositivePrice) {
                        _lowPiontValue.lowPositivePrice = min(_lowPiontValue.lowPositivePrice, lowBL);
                    }else{
                        _lowPiontValue.lowPositivePrice = min(_lowPiontValue.highPositivePrice, lowBL);
                    }
                }
            }else if(lowBL < 0)
            {
                if (_lowPiontValue.lowNegativePrice == 0) {
                    _lowPiontValue.lowNegativePrice = lowBL;
                }else{
                    _lowPiontValue.highNegativePrice = min(_lowPiontValue.lowNegativePrice, lowBL);
                    if (highBL == _highPiontValue.highNegativePrice) {
                        _lowPiontValue.lowNegativePrice = max(_lowPiontValue.lowNegativePrice, lowBL);
                    }else{
                        _lowPiontValue.lowNegativePrice = max(_lowPiontValue.highNegativePrice, lowBL);
                    }
                }
            }
        }
    }else if(_stockArr.count == days){
        [self predict:nil];
    }
    _lowPiont.text = @"";
    _highPiont.text = @"";
    [_highPiont becomeFirstResponder];
}

- (IBAction)predict:(id)sender {
    
     self.dayLabel.text = @"第1天";
    NSString *relust = [NSString stringWithFormat:@"  预测结果如下:\n高点最大上涨值%.2f，高点最小上涨值%.2f，高点最小下跌值%.2f，高点最大下跌值%.2f。",_currentPrice.highPrice*(1+_highPiontValue.highPositivePrice),_currentPrice.highPrice*(1+_highPiontValue.lowPositivePrice),_currentPrice.highPrice*(1+_highPiontValue.lowNegativePrice),_currentPrice.highPrice*(1+_highPiontValue.highNegativePrice)];
    relust = [NSString stringWithFormat:@"%@\n低点最大上涨值%.2f，低点最小上涨值%.2f，低点最小下跌%.2f，低点最大下跌值%.2f。",relust,_currentPrice.lowPrice*(1+_lowPiontValue.highPositivePrice),_currentPrice.lowPrice*(1+_lowPiontValue.lowPositivePrice),_currentPrice.lowPrice*(1+_lowPiontValue.lowNegativePrice),_currentPrice.lowPrice*(1+_lowPiontValue.highNegativePrice)];
    NSLog(@"高点最大值 %0.2f 高点最小值%0.2f",_highPiontValue.highPositivePrice,_highPiontValue.lowPositivePrice);
    float highPiontMax = _currentPrice.highPrice*(max(_highPiontValue.highPositivePrice,_highPiontValue.lowPositivePrice)+1);
    float lowPiontMax = _currentPrice.lowPrice*(max(_lowPiontValue.highPositivePrice,_lowPiontValue.lowPositivePrice)+1);
    float max = max(highPiontMax, lowPiontMax);
    
    float min = min((min(_highPiontValue.highNegativePrice,_highPiontValue.lowNegativePrice)+1)*_currentPrice.highPrice,(min(_lowPiontValue.highNegativePrice,_lowPiontValue.lowNegativePrice)+1)*_currentPrice.lowPrice);
    
    relust = [NSString stringWithFormat:@"%@\n最高点预测：%.2f最低点预测：%.2f",relust,max,min];

    _resultView.text = relust;
}

#pragma mark TextFieldDelegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    if (textField == _lowPiont) {
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
