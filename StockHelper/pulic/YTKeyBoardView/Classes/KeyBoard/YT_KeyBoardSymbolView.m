//
//  YT_KeyBoardSymbolView.m
//  Keyboarde
//
//  Created by laijihua on 16/8/16.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "YT_KeyBoardSymbolView.h"

#define kSymbolButtonGrayColor [UIColor grayColor]

static NSInteger const kYT_KeyBoardSymbolView_Tag = 2001;

@interface YT_KeyBoardSymbolView ()
@property (nonatomic, assign) YT_KeyBoardType type;
@property (nonatomic, weak) id<YT_KeyBoardViewSubViewDelegate> delegate;
@end

@implementation YT_KeyBoardSymbolView

#pragma mark - initial
- (instancetype)initWithFrame:(CGRect)frame keyBoardType:(YT_KeyBoardType)type {
    if (self = [super initWithFrame:frame]) {
        self.type = type;
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
    self.backgroundColor = [self.delegate keyBoardTheme].keyBoardBackgroundColor;
    NSArray *titleArray = @[@"!",@"@",@"#",@"$",@"%",@"^",@"&",@"*",@"(",@")",
                            @"'",@"\"",@"=",@"_",@"`",@":",@";",@"?",@"~",@"|",
                            @"+",@"-",@"\\",@"/",@"[",@"]",@"{",@"}",
                            @"<="/*删除*/,@"123",@"abc",
                            @",",@".",@"<",@">",
                            @"确定"
                            ];
    NSInteger rows = 4;
    NSInteger cols = 10;
    CGRect frame = self.frame;
    CGFloat padding = 4;
    CGFloat itemBtnW = (frame.size.width - padding * (cols+1)) / cols;
    CGFloat itemBtnH = (frame.size.height - padding * (rows + 1)) / rows;
    UIFont *textFont = [UIFont fontWithName:@"Sinhala Sangam MN" size:25.0f];
    UIColor *textColor = [UIColor blackColor];

    for (NSInteger i = 0; i < titleArray.count; i++ ) {
        NSInteger col = i % cols;
        NSInteger row = i / cols;
        if (i == 29) {
            col = 0;
            row = 3;
        } else if (i == 30) {
            col = col + 2;
        } else if (i > 30) {
            col = col + 3;
        }
        
        CGFloat itemX = padding + (itemBtnW + padding) * col;
        CGFloat itemY = padding + (itemBtnH + padding) * row;
        CGFloat itemW = itemBtnW;
        if (i == 28 || i == 29 || i == 30 || i == 35) {
            itemW = 2 * itemBtnW + padding;
        }
        
        CGRect  rect = CGRectMake(itemX, itemY, itemW, itemBtnH);
        
        UIButton *button = [UIButton yt_createButton:rect normalSelectImgName:nil selectImgName:nil  tag:kYT_KeyBoardSymbolView_Tag + i title:titleArray[i] titleColor:textColor titleFont:textFont target:self selector:@selector(btnClickAction:)];
        [button yt_setCornerRadio:2];
        // 做一些单独处理
        if (i == 28) { // 删除, 可以添加长按手势
            button.backgroundColor = kSymbolButtonGrayColor;
            UILongPressGestureRecognizer *longPressGesture = [UILongPressGestureRecognizer yt_createWithTarget:self action:@selector(clearBtnLongPress:)];
            [button addGestureRecognizer:longPressGesture];
        } else if(i == 29   // 数字
                  || i == 30  // 字母
                  || i == 35) {  // 确定
            button.backgroundColor = [self.delegate keyBoardTheme].characterBoardContrlColor;
            
        } else {
            
            button.backgroundColor = [UIColor whiteColor];
            //处理点击与松手之间的按钮背影色问题
            [button addTarget:self action:@selector(buttonTouchDown:) forControlEvents:UIControlEventTouchDown];
            
            [button addTarget:self action:@selector(buttonTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
            
        }
        
        [self addSubview:button];
        
    }
    
}

#pragma mark - 父类YT_KeyBoardZoomAbleView的重写

- (BOOL)isNeedZoom:(UIView *)subView {
    BOOL bRet = YES;
    NSInteger vTag = subView.tag - kYT_KeyBoardSymbolView_Tag;
    
    if (vTag == 28 || vTag == 29 || vTag == 30 || vTag == 35) {
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

#pragma mark - 按钮点击
- (void)btnClickAction:(UIButton *)button {
    NSString *text = nil;
    NSInteger tag = button.tag - kYT_KeyBoardSymbolView_Tag;
    if (tag == 28) { // 删除
        if (_delegate && [_delegate respondsToSelector:@selector(keyBoardViewSubView:cancleBtnClicked:)]){
            [_delegate keyBoardViewSubView:self cancleBtnClicked:button];
            return;
        }
    } else if (tag == 29) { // 数字123
        if (_delegate) {
            [_delegate setDisplayKeyBoard:YT_KeyBoardShowStyle_Number];
        }
        return;
    } else if (tag == 30) { // 字母abc
        if (_delegate) {
            [_delegate setDisplayKeyBoard:YT_KeyBoardShowStyle_Character];
        }
        return;
        
    } else if (tag == 35) { // 确定
        if (_delegate && [_delegate respondsToSelector:@selector(keyBoardViewSubView:comfirmBtnClicked:)]) {
            [_delegate keyBoardViewSubView:self comfirmBtnClicked: button];
        }
        return;
    } else {
        text = [button titleForState:UIControlStateNormal];
        button.backgroundColor = [UIColor whiteColor];
        if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewSubView:buttonAction:showText:)]) {
            [self.delegate keyBoardViewSubView:self  buttonAction:button showText:text];
        }
    }
}

- (void)buttonTouchDown:(UIButton *)button {
    button.backgroundColor = [self.delegate keyBoardTheme].keyBoardInputButtonPressDownColor;
}

- (void)buttonTouchUpOutside:(UIButton *)button {
    button.backgroundColor = [self.delegate keyBoardTheme].keyBoardInputButtonColor;
    
}


- (void)clearBtnLongPress:(UILongPressGestureRecognizer *)recognizer {
    UIButton *sender = (UIButton *)recognizer.view;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(keyBoardViewSubView:cancleBtnLongPress:)]) {
        [self.delegate keyBoardViewSubView:self cancleBtnLongPress:sender];
    }
    
}

#pragma mark - setter and getter

@end
