//
//  KeyBoardView.m
//  Keyboard
//
//  Created by laijihua on 16/8/12.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "YT_KeyBoardView.h"
#import "YT_KeyBoardNumberView.h"
#import "YT_KeyBoardCharacterView.h"
#import "YT_KeyBoardSymbolView.h"

@interface YT_KeyBoardView()

@property (nonatomic, assign) YT_KeyBoardType keyBoardType_;   /// 键盘的展示类型
@property (nonatomic, assign) YT_KeyBoardShowStyle keyBoardShowStyle_; ///< 当前键盘的显示样式

@property (nonatomic, strong) YT_KeyBoardNumberView *numberKeyBoardView_; ///< 数字键盘
@property (nonatomic, strong) YT_KeyBoardCharacterView *characterKeyBoardView_; // 字母键盘
@property (nonatomic, strong) YT_KeyBoardSymbolView *symbolKeyBoardView_; ///< 符号键盘

@property (nonatomic, weak) id<YT_KeyBoardViewDelegate> delegate;

@property (nonatomic, strong) id<YT_KeyBoardThemeProtocol> keyboardTheme_;

@property (nonatomic, weak) UITextField *textField;

@end

@implementation YT_KeyBoardView

- (instancetype)initWithFrame:(CGRect)frame
             keyBoardType:(YT_KeyBoardType)type
             keyBoardFirstShowType:(YT_KeyBoardShowStyle)showType
                     delegate:(id<YT_KeyBoardViewDelegate>)delegate
                    textField:(UITextField *)textField{
    return [self initWithFrame:frame keyBoardType:type keyBoardFirstShowType:showType delegate:delegate textField:textField theme:[[YT_KeyBoardTheme alloc] init]];
}

- (instancetype)initWithFrame:(CGRect)frame
                 keyBoardType:(YT_KeyBoardType)type
        keyBoardFirstShowType:(YT_KeyBoardShowStyle)showType
                     delegate:(id<YT_KeyBoardViewDelegate>)delegate
                    textField:(UITextField *)textField
                        theme:(id<YT_KeyBoardThemeProtocol>)theme{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor colorWithRed:203/255.0f green:203/255.0f blue:203/255.0f alpha:1.0f];
        self.keyBoardType_ = type;
        self.keyBoardShowStyle_ = showType;
        self.delegate = delegate;
        self.textField = textField;
        self.keyboardTheme_ = theme;
        [self setup];
    }
    return self;
}



- (void)setup {
    switch (self.keyBoardType_) {
        case YT_KeyBoardType_Number: {    //只有数字 （左下角什么都没有）
            [self createNumberKeyBoardView];
            self.keyBoardShowStyle_ = YT_KeyBoardShowStyle_Number;
        }break;
            
        case YT_KeyBoardType_NumberPoint: {    //数字+小数点 （左下角是小数点“.”）
            [self createNumberKeyBoardView];
            self.keyBoardShowStyle_ = YT_KeyBoardShowStyle_Number;
        }break;
            
        case YT_KeyBoardType_NumberWarehouseLeft: { // 数字 + 左行列仓库
            [self createNumberKeyBoardView];
            self.keyBoardShowStyle_ = YT_KeyBoardShowStyle_Number;
        }break;
            
        case YT_KeyBoardType_NumberCharacterSystem: { // 数字 + 字母 + 中文
            [self createNumberKeyBoardView];
            [self createCharacterKeyBoardView];
        }break;
            
        case YT_KeyBoardType_NumBerCharacterSystemLeft: { // 数字（有left一列） + 字母 + 中文
            [self createNumberKeyBoardView];
            [self createCharacterKeyBoardView];
        }break;
            
        case YT_KeyBoardType_NumberCharacterSymbol: { //数字 字母 符号
            [self createNumberKeyBoardView];
            [self createCharacterKeyBoardView];
            [self createSymbolKeyBoardView];
        }break;
        
        default:
        break;
    }
    
    // 多种输入方式的时候，先显示哪种输入方式
    [self setDisplayKeyBoard:self.keyBoardShowStyle_];
}

#pragma mark - 键盘创建
- (void)createNumberKeyBoardView {
    [self addSubview:self.numberKeyBoardView_];
}

- (void)createCharacterKeyBoardView {
    [self addSubview:self.characterKeyBoardView_];
}

- (void)createSymbolKeyBoardView {
    [self addSubview:self.symbolKeyBoardView_];
}

// 多种输入方式的时候设置键盘
- (void)setDisplayKeyBoard:(YT_KeyBoardShowStyle)style {
    switch (style) {
        case YT_KeyBoardShowStyle_Number: {
            if (_numberKeyBoardView_) {
                _numberKeyBoardView_.hidden = NO;
                _characterKeyBoardView_.hidden = YES;
                _symbolKeyBoardView_.hidden = YES;
                [self bringSubviewToFront:_numberKeyBoardView_];
            }
        }break;
        case YT_KeyBoardShowStyle_Symbol: { // 字符
            if (_symbolKeyBoardView_) {
                _symbolKeyBoardView_.hidden = NO;
                _numberKeyBoardView_.hidden = YES;
                _characterKeyBoardView_.hidden = YES;
                [self bringSubviewToFront:_symbolKeyBoardView_];
            }
            
        }break;
            
        case YT_KeyBoardShowStyle_Character: { // 字母
            if(_characterKeyBoardView_) {
                _characterKeyBoardView_.hidden = NO;
                _symbolKeyBoardView_.hidden = YES;
                _numberKeyBoardView_.hidden = YES;
                [self bringSubviewToFront:_characterKeyBoardView_];
                [_characterKeyBoardView_ setBigOrSmallForEnglish:NO];
            }
            
        }break;
        case YT_KeyBoardShowStyle_System: { // 系统中文
             self.textField.inputView = nil;
            [self.textField reloadInputViews];
        }break;
    }
}

#pragma  mark - YT_KeyBoardViewSubViewDelegate
- (void)keyBoardViewSubView:(id<YT_KeyBoardViewDecorationAble>)subView buttonAction:(UIButton *)sender showText:(NSString *)text {
    // 拼接字符串功能
    if (text.length <= 0){
        return ;
    }
    NSMutableString *currentText = [self.textField.text mutableCopy];
    [currentText appendString:text];
    self.textField.text = [currentText copy];
    [self textChangedShouldCallBack];
}

- (YT_KeyBoardTheme *)keyBoardTheme {
    return self.keyboardTheme_;
}


// 是否要添加.， 只针对纯数字键盘
- (BOOL)keyBoardViewSubView:(id<YT_KeyBoardViewDecorationAble>)subView isNeedAppendPointButtonTitle:(UIButton *)sender {
    NSString *title = [sender titleForState:UIControlStateNormal];
    if ([title isEqual: @"."]) {
        if (([self.textField.text length] == 0)
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
            || [self.textField.text containsString:@"."]
#else
            || [self.textField.text rangeOfString:@"."].location != NSNotFound
#endif
            ) {   //第一个是小数点或已经有一小数点则不输入
            return NO;
        }else {
            return YES;
        }
    }else {
        return YES;
    }
}

// 删除
- (void)keyBoardViewSubView:(id<YT_KeyBoardViewDecorationAble>)subView cancleBtnClicked:(UIButton *)sender {
    
    NSMutableString *currentText = [self.textField.text mutableCopy];
    if (currentText.length <= 0) {
        return;
    }else {
        self.textField.text = [currentText substringToIndex:currentText.length - 1];
    }
    
    [self textChangedShouldCallBack];
}

// 长按删除
- (void)keyBoardViewSubView:(id<YT_KeyBoardViewDecorationAble>)subView cancleBtnLongPress:(UIButton *)sender {
    if (self.textField.text.length > 0){
        self.textField.text = @"";
        // 回调改变
        [self textChangedShouldCallBack];
    }
}

// 确定按钮点击
- (void)keyBoardViewSubView:(id<YT_KeyBoardViewDecorationAble>)subView comfirmBtnClicked:(UIButton *)sender {
    
    [self.textField endEditing:YES];
    
    if(_delegate && [_delegate respondsToSelector:@selector(keyBoardViewShouldConfirm:)]) {
        [_delegate keyBoardViewShouldConfirm:self];
    }
}

#pragma mark - helper
- (void)textChangedShouldCallBack {
    if (_delegate && [_delegate respondsToSelector:@selector(keyBoardView:changeText:)]) {
        [_delegate keyBoardView:self changeText:self.textField.text];
    }
}


#pragma mark - setter and getter
- (YT_KeyBoardNumberView *)numberKeyBoardView_ {
    if (!_numberKeyBoardView_) {
        _numberKeyBoardView_ = [[YT_KeyBoardNumberView alloc] initWithFrame:self.bounds keyBoardType:self.keyBoardType_ delegate:self];
    }
    return _numberKeyBoardView_;
}

- (YT_KeyBoardCharacterView *)characterKeyBoardView_ {
    if (!_characterKeyBoardView_) {
        _characterKeyBoardView_ = [[YT_KeyBoardCharacterView alloc]
                                   initWithFrame:self.bounds
                                    keyBoardType:self.keyBoardType_
                                        delegate:self];
        
    }
    return _characterKeyBoardView_;
}

- (YT_KeyBoardSymbolView *)symbolKeyBoardView_ {
    if (!_symbolKeyBoardView_) {
        _symbolKeyBoardView_ = [[YT_KeyBoardSymbolView alloc] initWithFrame:self.bounds keyBoardType:self.keyBoardType_ delegate:self];
       
    }
    return _symbolKeyBoardView_;
}


@end
