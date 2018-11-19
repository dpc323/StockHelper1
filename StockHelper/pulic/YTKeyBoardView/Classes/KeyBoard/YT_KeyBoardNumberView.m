//
//  YT_KeyBoardNumberView.m
//  Keyboarde
//
//  Created by laijihua on 16/8/15.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "YT_KeyBoardNumberView.h"

static NSInteger const kNumberButton_tag = 1001;

#define kNumberButtonGrayColor [UIColor grayColor]

@interface YT_KeyBoardNumberView ()
@property (nonatomic, weak) id<YT_KeyBoardViewSubViewDelegate> delegate;
@property (nonatomic, assign) YT_KeyBoardType keyBoardType_;
@property (nonatomic, assign) BOOL needLeftCol_; //

@property (nonatomic, strong) UIView *leftColView_; ///< 最左边的数列
@property (nonatomic, strong) UIView *numberBoardView_; ///< 最左边的行列

@end

@implementation YT_KeyBoardNumberView

#pragma mark - initial
- (instancetype)initWithFrame:(CGRect)frame keyBoardType:(YT_KeyBoardType)type {
    if (self = [super initWithFrame:frame]) {
        self.keyBoardType_ = type;
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame keyBoardType:(YT_KeyBoardType)type delegate:(id<YT_KeyBoardViewSubViewDelegate>)delegate {
    if (self = [self initWithFrame:frame keyBoardType:type]) {
        self.delegate = delegate;
        [self setup];
    }
    
    return self;
    
}



#pragma mark - add subviews (setup)
- (void)setup {
    [self createBoardView];
    [self createLeftColView];
}

- (CGFloat)getLineWidth {
    return  1.0;
}

- (UIColor *)textColor {
    return [UIColor blackColor];
}

- (UIColor *)boardItemBgColor {
    return [UIColor whiteColor];
}


- (void)createBoardView {
    self.backgroundColor = [self.delegate keyBoardTheme].keyBoardBackgroundColor;
    CGRect frame = self.numberBoardView_.frame;
    CGFloat line_Width = [self getLineWidth];    //线宽
    UIColor *textColor = [self textColor];
    UIColor *bgColor = [self boardItemBgColor];
    
    UIView *numberBgView = ({
        NSInteger rows = 4;
        UIFont *textFont = [UIFont fontWithName:@"Courier New" size:30.0f];
        CGFloat butt_Height = (frame.size.height - rows*line_Width)/rows;
        CGFloat width = CGRectGetWidth(frame) * 3/4;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, CGRectGetHeight(frame))];
        
        CGFloat butt_Width = (width - 2*line_Width)/3;
        NSString *rightString = @"#+=";
        NSString *leftString = @"abc";
        switch (self.keyBoardType_) {
            case YT_KeyBoardType_Number: {    //只有数字 （左下角什么都没有）
                rightString = @"";
                leftString = @"";
            }break;
                
            case YT_KeyBoardType_NumberPoint: {    //数字+小数点 （左下角是小数点“.”）
                rightString = @".";
                leftString = @"";
            }break;
                
            case YT_KeyBoardType_NumberCharacterSymbol: {
                rightString = @"#+=";
                leftString = @"abc";
            }break;
                
            case YT_KeyBoardType_NumberWarehouseLeft: {
                rightString = @"000";
                leftString = @"00";
            }break;
                
            case YT_KeyBoardType_NumBerCharacterSystemLeft:
            case YT_KeyBoardType_NumberCharacterSystem: {
                rightString = @"中文";
                leftString = @"abc";
            }break;
            default:
                break;
        }
        
        NSArray *titleArray = [NSArray arrayWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", leftString, @"0", rightString, nil];
        CGRect buttonFrame = CGRectMake(0, 0, butt_Width, butt_Height);
        NSInteger row = 0;     //行
        NSInteger col = 0;     //列
        for (NSInteger i = 0; i < titleArray.count; i++) {
            row = i/3;
            col = i%3;
            buttonFrame.origin.x = col*(butt_Width + line_Width);
            buttonFrame.origin.y = row*(butt_Height + line_Width) + line_Width;
            NSString *title = titleArray[i];
            UIButton *button = [UIButton yt_createButton:buttonFrame
                                     normalSelectImgName:nil
                                           selectImgName:nil
                                                     tag:kNumberButton_tag + i
                                                   title:title
                                              titleColor:textColor
                                               titleFont:textFont
                                                  target:self
                                                selector:@selector(buttonAction:)];
            
            if (9 == i) {
                button.backgroundColor = [self.delegate keyBoardTheme].numberBoardControlButtonColor;
            } else if (11 == i) {
                button.backgroundColor = [self.delegate keyBoardTheme].numberBoardControlButtonColor;
                
            } else {
                button.backgroundColor = [self.delegate keyBoardTheme].keyBoardInputButtonColor;
                //处理点击与松手之间的按钮背影色问题
                [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
                [button addTarget:self action:@selector(buttonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
            }
            
            [bgView addSubview:button];
        }
        
        bgView;
    });
    [self.numberBoardView_ addSubview:numberBgView];
    
    
    UIView *rightColBgView = ({
        NSUInteger rows = 2;
        CGFloat width  = frame.size.width * 1/4 - 1;
        CGFloat height = (CGRectGetHeight(frame) - line_Width * rows) / rows;
        CGFloat btnX = line_Width;
        UIColor *bgColor = [UIColor whiteColor];
        UIFont *titleFont = [UIFont systemFontOfSize:24];
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(numberBgView.frame), 0, CGRectGetWidth(frame)/4, CGRectGetHeight(frame))];
        
        
        UIButton *delBtn = [UIButton yt_createButton: CGRectMake(btnX, line_Width, width, height)
              normalSelectImgName:nil
                    selectImgName:nil
                              tag:kNumberButton_tag + 12
                            title:@"<="
                       titleColor:textColor
                        titleFont:titleFont
                           target:self
                         selector:@selector(buttonAction:)];
        UILongPressGestureRecognizer *longPressGesture = [UILongPressGestureRecognizer yt_createWithTarget:self action:@selector(clearBtnLongPress:)];
        [delBtn addGestureRecognizer:longPressGesture];
        
        UIButton *confirmBtn = [UIButton yt_createButton:CGRectMake(btnX, CGRectGetMaxY(delBtn.frame) + line_Width, width, height)
                                     normalSelectImgName:nil
                                           selectImgName:nil
                                                     tag:kNumberButton_tag + 13
                                                   title:@"确定"
                                              titleColor:textColor
                                               titleFont:titleFont
                                                  target:self
                                                selector:@selector(buttonAction:)];
        delBtn.backgroundColor = bgColor;
        confirmBtn.backgroundColor = [self.delegate keyBoardTheme].keyBoardConfirmButtonColor;
        [rightView addSubview:delBtn];
        [rightView addSubview:confirmBtn];
        rightView;
    });
    [self.numberBoardView_ addSubview:rightColBgView];

}

- (void)createLeftColView {
    if (self.needLeftCol_) {
        NSArray *leftArr = (self.keyBoardType_ == YT_KeyBoardType_NumBerCharacterSystemLeft) ? [NSArray yt_numberKeyBoardNumberLeft] : [NSArray yt_numberKeyBoardWarehouseLeft];
        CGFloat lineWith = [self getLineWidth];
        NSInteger rows = leftArr.count;
        CGFloat width = CGRectGetWidth(self.leftColView_.frame) - lineWith;
        CGFloat height = (CGRectGetHeight(self.leftColView_.frame) - rows*lineWith)/rows;
        UIFont *textFont = [UIFont fontWithName:@"Courier New" size:18.0f];
        UIColor *bgColor = [self boardItemBgColor];
        for (NSInteger i = 0; i < rows; i++) {
            CGFloat y = (height + lineWith)*i + lineWith;
            CGRect frame = CGRectMake(0, y, width, height);
            UIButton *btn = [UIButton yt_createButton:frame
                                  normalSelectImgName:nil
                                        selectImgName:nil
                                                  tag:kNumberButton_tag + 14 + i
                                                title:leftArr[i]
                                           titleColor:[self textColor]
                                            titleFont:textFont
                                               target:self
                                             selector:@selector(buttonAction:)];
            btn.backgroundColor = [self.delegate keyBoardTheme].numberBoardControlButtonColor;
            [self.leftColView_ addSubview:btn];
        }
        
        
    } else {
        self.leftColView_.hidden = YES;
    }
}



#pragma mark - private method
- (void)buttonAction:(UIButton *)button {
    NSString *text = nil;
    NSInteger tag = button.tag - kNumberButton_tag;
    if (9 == tag) {   //abc 或 00
        if (self.keyBoardType_ == YT_KeyBoardType_NumberWarehouseLeft) { // 00
            text = [button titleForState:UIControlStateNormal];
        } else if (self.keyBoardType_ == YT_KeyBoardType_NumberCharacterSymbol ||
                   self.keyBoardType_ == YT_KeyBoardType_NumberCharacterSystem ||   // abc
                   self.keyBoardType_ == YT_KeyBoardType_NumBerCharacterSystemLeft) {
            if (_delegate) {
                [_delegate setDisplayKeyBoard:YT_KeyBoardShowStyle_Character];
                
            }
            return;
        } else {
            text = [button titleForState:UIControlStateNormal];
        }
    } else if (11 == tag) {  // 右边  .|  | 000   | #+= | 中文
        if (self.keyBoardType_ == YT_KeyBoardType_NumberPoint) {  // .
            if (_delegate && [_delegate respondsToSelector:@selector(keyBoardViewSubView:isNeedAppendPointButtonTitle:)]) {
                if (![_delegate keyBoardViewSubView:self isNeedAppendPointButtonTitle:button]) {
                    return;
                }
            }
            text = [button titleForState:UIControlStateNormal];
        } else if (self.keyBoardType_ == YT_KeyBoardType_NumberWarehouseLeft){ /// 000
            text = [button titleForState:UIControlStateNormal];
        } else if (self.keyBoardType_ == YT_KeyBoardType_NumberCharacterSymbol) { // #+=
            if (_delegate) {
                [_delegate setDisplayKeyBoard:YT_KeyBoardShowStyle_Symbol];
            }
            return;
        } else if (self.keyBoardType_ == YT_KeyBoardType_NumberCharacterSystem ||  // 中文
                   self.keyBoardType_ == YT_KeyBoardType_NumBerCharacterSystemLeft) {
            if (_delegate) {
                [_delegate setDisplayKeyBoard:YT_KeyBoardShowStyle_System];
            }
            return;
        } else {
            text = [button titleForState:UIControlStateNormal];
        }
    }else if (12 == tag) {   //删除
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewSubView:cancleBtnClicked:)]) {
            [self.delegate keyBoardViewSubView:self cancleBtnClicked:button];
        }
        return;
    } else if (13 == tag ){ // 确定
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewSubView:comfirmBtnClicked:)]) {
            [self.delegate keyBoardViewSubView:self comfirmBtnClicked:button];
        }
        return;
    }else {   //其它直接添加
        text = [button titleForState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
    }
    
    if (text && text.length > 0) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewSubView:buttonAction:showText:)]) {
            [self.delegate keyBoardViewSubView:self  buttonAction:button showText:text];
        }
    }

}

- (void)buttonTouchDown:(UIButton *)button {
    button.backgroundColor = kNumberButtonGrayColor;
}

- (void)buttonTouchUpOutside:(UIButton *)button {
    button.backgroundColor = [UIColor whiteColor];
}

- (void)clearBtnLongPress:(UILongPressGestureRecognizer *)recognizer {
    UIButton *sender = (UIButton *)recognizer.view;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewSubView:cancleBtnLongPress:)]) {
        [self.delegate keyBoardViewSubView:self cancleBtnLongPress:sender];
    }
    
}

#pragma mark - setter and getter
- (void)setKeyBoardType_:(YT_KeyBoardType)keyBoardType_ {
    _keyBoardType_ = keyBoardType_;
    if (_keyBoardType_ == YT_KeyBoardType_NumberWarehouseLeft || _keyBoardType_ == YT_KeyBoardType_NumBerCharacterSystemLeft) { // 不需要左边的扩展列
        self.needLeftCol_ = YES;
    } else { // 需要左边的扩展列
        self.needLeftCol_ = NO;
    }
    
    [self setupContainerView:self.needLeftCol_];
}

- (void)setupContainerView:(BOOL)needLeftCol {
    CGFloat leftColWidth = needLeftCol ? CGRectGetWidth(self.frame) / 5 : 0;
    CGFloat height = CGRectGetHeight(self.frame);
    
    _leftColView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, leftColWidth, height)];
    _numberBoardView_ = [[UIView alloc] initWithFrame:CGRectMake(leftColWidth, 0, CGRectGetWidth(self.frame) - leftColWidth, height)];
    
    [self addSubview:_leftColView_];
    [self addSubview:_numberBoardView_];
    
    _leftColView_.hidden = !needLeftCol;
}


@end
