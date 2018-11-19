//
//  YT_KeyBoardCharacterView.m
//  Keyboarde
//
//  Created by laijihua on 16/8/15.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "YT_KeyBoardCharacterView.h"
static NSInteger const kCharacterButton_tag = 1001;

#define kCharacterButtonGrayColor [UIColor grayColor]


@interface YT_KeyBoardCharacterView ()

@property (nonatomic, weak) id<YT_KeyBoardViewSubViewDelegate> delegate;


@property (nonatomic, assign) YT_KeyBoardType keyBoardType_;

@property (nonatomic, assign) BOOL    bForeverEnglish_;   ///< 永远大写

@property (nonatomic, assign) BOOL    bBigEnglish_;       ///< 英语是否大写


@property (nonatomic, weak) UIButton *clearButton;


@end

@implementation YT_KeyBoardCharacterView

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

#pragma mark - add subviews (setup)/**  */

- (void)setup {
    self.backgroundColor = [self.delegate keyBoardTheme].keyBoardBackgroundColor;
    CGRect frame = self.frame;
    CGFloat fZMButt_Width = (frame.size.width/10)*5/6;    //上面字母按钮的宽
    CGFloat fMidd_Width = (frame.size.width/10)/6;        //按钮之间的宽
    CGFloat fZMButt_Height = 40.0f;  //上面字母按钮的高
    CGFloat fBott_Height = 45.0f;    //最下面一排按钮的高
    CGFloat fMidd_Height = (frame.size.height - 3*fZMButt_Height - fBott_Height)/5;        //按钮之间的高
    
    UIFont *textFont = [UIFont fontWithName:@"Sinhala Sangam MN" size:25.0f];
    UIColor *textColor = [UIColor blackColor];
    NSString *abcString = @"中文";
    if (YT_KeyBoardType_NumberCharacterSymbol == self.keyBoardType_) {   //
        abcString = @"#+=";
    } else if (YT_KeyBoardType_NumberCharacterSystem == self.keyBoardType_) {
        abcString = @"中文";
    }
    
    NSArray *titleArray = [NSArray arrayWithObjects:@"Q", @"W", @"E", @"R", @"T", @"Y", @"U", @"I", @"O", @"P", @"A", @"S",
                           @"D", @"F", @"G", @"H", @"J", @"K", @"L", @"大", @"Z", @"X", @"C", @"V",
                           @"B", @"N", @"M", @"<=", @"123", abcString, @"空格", @"确定", nil];
    CGRect buttonFrame = CGRectMake(fMidd_Width/2, fMidd_Height, fZMButt_Width, fZMButt_Height);
    NSInteger row = 0;     //行
    NSInteger col = 0;     //列
    for (NSInteger i = 0; i < titleArray.count; i++) {
        if (i < 10) {
            row = 0;
            col = i;
            buttonFrame.origin.x = fMidd_Width/2 + col*(fZMButt_Width + fMidd_Width);
            buttonFrame.origin.y = fMidd_Height + row*(fZMButt_Height + fMidd_Height);
        } else if (i >= 10 && i < 19) {
            row = 1;
            col = i - 10;
            buttonFrame.origin.x = fMidd_Width + fZMButt_Width/2 + col*(fZMButt_Width + fMidd_Width);
            buttonFrame.origin.y = fMidd_Height + row*(fZMButt_Height + fMidd_Height);
        } else if (i >= 19 && i < 28) { // 第三行
            row = 2;
            col = i - 19;
            if (19 == i) {   //大小写
                buttonFrame.origin.x = fMidd_Width/2;
                buttonFrame.size.width = fZMButt_Width*3/2 + fMidd_Width/2;
            } else if (27 == i) {   //返回
                buttonFrame.origin.x = fMidd_Width + fZMButt_Width/2 + col*(fZMButt_Width + fMidd_Width);
                buttonFrame.size.width = fZMButt_Width*3/2 + fMidd_Width/2;
            } else {
                buttonFrame.origin.x = fMidd_Width + fZMButt_Width/2 + col*(fZMButt_Width + fMidd_Width);
                buttonFrame.size.width = fZMButt_Width;
            }
            buttonFrame.origin.y = fMidd_Height + row*(fZMButt_Height + fMidd_Height);
        } else { // 第四行
            row = 3;
            //            col = i - 28;
            if (28 == i) {    //数字
                buttonFrame.origin.x = fMidd_Width/2;
                buttonFrame.size.width = fZMButt_Width*2 + fMidd_Width*2;
            } else if (29 == i) {   // 字母， 中文
                buttonFrame.origin.x += buttonFrame.size.width + fMidd_Width;
                buttonFrame.size.width = fZMButt_Width*2 + fMidd_Width*2;
            } else if (30 == i) {    //空格
                buttonFrame.origin.x += buttonFrame.size.width + fMidd_Width;
                buttonFrame.size.width = fZMButt_Width*3 + fMidd_Width*6;
            } else if (31 == i) {   // 确定
                buttonFrame.origin.x +=  buttonFrame.size.width + fMidd_Width;
                buttonFrame.size.width = fZMButt_Width*2 + fMidd_Width;
            }
            
            buttonFrame.origin.y = fMidd_Height + row*(fZMButt_Height + fMidd_Height);
            buttonFrame.size.height = fBott_Height;
        }
        
        UIButton *button = [UIButton yt_createButton:buttonFrame
                                 normalSelectImgName:nil
                                       selectImgName:nil
                                                 tag:kCharacterButton_tag + i
                                               title:[titleArray objectAtIndex:i]
                                          titleColor:textColor
                                           titleFont:textFont
                                              target:self
                                            selector:@selector(buttonAction:)];
        [button yt_setCornerRadio:2];
        if (19 == i       //大小写
            || 27 == i) {   //删除
        
            button.backgroundColor = [self.delegate keyBoardTheme].characterBoardContrlColor;
            if ( i == 27 ) { // 删除
                UILongPressGestureRecognizer *gesture = [UILongPressGestureRecognizer yt_createWithTarget:self action:@selector(clearBtnLongPress:)];
                [button addGestureRecognizer:gesture];
                self.clearButton = button;
                
            }
        } else if (28 == i     // 数字
                   || 29 == i  // 中文|字符
                   || 31 == i) {   //确定
        
            button.backgroundColor = [self.delegate keyBoardTheme].characterBoardContrlColor;
            
            button.titleLabel.font = [UIFont systemFontOfSize:20];
            
            
        } else {
            button.backgroundColor = [self.delegate keyBoardTheme].keyBoardInputButtonColor;
            //处理点击与松手之间的按钮背影色问题
            [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
            [button addTarget:self action:@selector(buttonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside];
        }
        
        if (19 == i) {
            //双击大小写
            [button addTarget:self action:@selector(buttonDownRepeat:) forControlEvents:UIControlEventTouchDownRepeat];
        }
        
        [self addSubview:button];
    }
}

#pragma mark - 重写YT_KeyBoardZoomAbleView方法

- (BOOL)isNeedZoom:(UIView *)subView {
    BOOL bRet = YES;
    NSInteger vTag = subView.tag - kCharacterButton_tag;
    if (vTag == 19 || vTag == 28 || vTag == 30 || vTag == 27 || vTag == 29 || vTag == 31) {
        bRet = NO;
    }
    return bRet;
}

- (void)dismissZoomViewIn:(UIButton *)sender {
    [super dismissZoomViewIn:sender];
    if (_delegate && [_delegate respondsToSelector:@selector(keyBoardViewSubView:buttonAction:showText:)]) {
        [_delegate keyBoardViewSubView:self buttonAction:sender showText:[sender titleForState:UIControlStateNormal]];
    }
}

#pragma mark - private method
- (void)buttonAction:(UIButton *)button {
    
    NSString *text = nil;
    if (kCharacterButton_tag + 19 == button.tag) {   //大小写
        if (!self.bForeverEnglish_) {
            [self setBigOrSmallForEnglish:!self.bBigEnglish_];
        }
        return;
        
    } else if (kCharacterButton_tag + 28 == button.tag) {    //数字
        
        if (_delegate) {
            [_delegate setDisplayKeyBoard:YT_KeyBoardShowStyle_Number];
        }
        [self setBigOrSmallForEnglish:NO];   //设置小写
        return;
        
    } else if (kCharacterButton_tag + 29 == button.tag) { // 符号|中文
        if (_delegate) {
            if (self.keyBoardType_ == YT_KeyBoardType_NumberCharacterSymbol) { //符号
                [_delegate setDisplayKeyBoard:YT_KeyBoardShowStyle_Symbol];
            } else if (self.keyBoardType_ == YT_KeyBoardType_NumberCharacterSystem ||
                       self.keyBoardType_ == YT_KeyBoardType_NumBerCharacterSystemLeft) { // 中文
                [_delegate setDisplayKeyBoard:YT_KeyBoardShowStyle_System];
            }
        }
        return;
    } else if (kCharacterButton_tag + 31 == button.tag) {    // 确定
        [self setBigOrSmallForEnglish:NO];   //设置小写
        if(_delegate && [_delegate respondsToSelector:@selector(keyBoardViewSubView:comfirmBtnClicked:)]){
            [_delegate keyBoardViewSubView:self  comfirmBtnClicked:button];
        }
        return;
    }else {
        if (kCharacterButton_tag + 27 == button.tag) {   //返回
            if (_delegate && [_delegate respondsToSelector:@selector(keyBoardViewSubView:cancleBtnClicked:)]){
                [_delegate keyBoardViewSubView:self cancleBtnClicked:button];
                return;
            }
            
        } else if (kCharacterButton_tag + 30 == button.tag) { //空格
            text = @" ";
            button.backgroundColor = [UIColor whiteColor];
        } else {
            if (self.bBigEnglish_) {   //大写
                text = [[button titleForState:UIControlStateNormal] uppercaseString];
            } else {   //小写
                text = [[button titleForState:UIControlStateNormal] lowercaseString];
            }
            button.backgroundColor = [UIColor whiteColor];
        }
        
        //修改大小写
        if (self.bBigEnglish_ && !self.bForeverEnglish_) {
            [self setBigOrSmallForEnglish:NO];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewSubView:buttonAction:showText:)]) {
        [self.delegate keyBoardViewSubView:self  buttonAction:button showText:text];
    }
}


- (void)buttonTouchDown:(UIButton *)button {
    button.backgroundColor = [self.delegate keyBoardTheme].characterBoardInputButtonPressDownColor;
}


- (void)buttonTouchUpOutside:(UIButton *)button {
    button.backgroundColor = [self.delegate keyBoardTheme].keyBoardInputButtonColor;
}


- (void)buttonDownRepeat:(UIButton *)button {
    [self setBigOrSmallForEnglish:!self.bForeverEnglish_];
}


- (void)clearBtnLongPress:(UILongPressGestureRecognizer *)recognizer {
    UIButton *sender = (UIButton *)recognizer.view;
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewSubView:cancleBtnLongPress:)]) {
        [self.delegate keyBoardViewSubView:self cancleBtnLongPress:sender];
    }
}

#pragma mark - helper
- (void)setBigOrSmallForEnglish:(BOOL)bBig {
    self.bBigEnglish_ = bBig;
    NSString *buttName = @"小";
    if (self.bBigEnglish_) {
        buttName = @"大";
    }
    UIButton *bigSmallButt = (UIButton *)[self viewWithTag:kCharacterButton_tag + 19];
    [bigSmallButt setTitle:buttName forState:UIControlStateNormal];
    [self changeKeyBoardTitle:bBig];
}

- (void)changeKeyBoardTitle:(BOOL)bBig {
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)subView;
            NSInteger tag = subView.tag - kCharacterButton_tag;
            NSString *text = bBig ? [[button titleForState:UIControlStateNormal] uppercaseString]: [[button titleForState:UIControlStateNormal] lowercaseString];
            if (tag < 27 && tag != 19) { // 除去大小写
                [button setTitle:text forState:UIControlStateNormal];
            }
        }
    }];
}

@end
