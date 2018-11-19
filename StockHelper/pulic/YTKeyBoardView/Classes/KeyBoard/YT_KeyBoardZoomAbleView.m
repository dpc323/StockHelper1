//
//  YT_KeyBoardZoomAbleView.m
//  Keyboarde
//
//  Created by laijihua on 16/8/17.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "YT_KeyBoardZoomAbleView.h"


@interface YT_KeyBoardZoomAbleView ()
@property (nonatomic,assign) BOOL isLongPressed;
/*
 *  选中的itemBtn
 */
@property (nonatomic,weak) UIButton *selectedItemBtn;

@end

@implementation YT_KeyBoardZoomAbleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _zoomView = [YT_KeyBoardZoomView zoomView];
        [self addGesture];
    }
    return self;
}

- (void)addGesture {
    //长按手势
    UILongPressGestureRecognizer *gesture = [UILongPressGestureRecognizer yt_createWithPressDuration:0.2 target:self action:@selector(longPress:)];
    [self addGestureRecognizer:gesture];
}

- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: // 手势开始
        case UIGestureRecognizerStateChanged: {// 手势移动
            CGPoint location = [gestureRecognizer locationInView:self];
            UIButton *itemBtn = [self itemBtnWithLocation:location]; // 寻找到要放大的btn
            self.selectedItemBtn.backgroundColor = [UIColor whiteColor];
            self.selectedItemBtn = itemBtn;
            _isLongPressed = YES;
            
        }break;
            
        default: {
            _isLongPressed = NO;
            [self dismissZoomViewIn:self.selectedItemBtn];
        }break;
    }
}


/**
 * 根据当前的点计算对应的btn
 */
- (UIButton *)itemBtnWithLocation:(CGPoint)location {
    __block UIButton *itemBtn = nil;
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull subView, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self isNeedZoom: subView]) {
            if(CGRectContainsPoint(subView.frame, location)){
                itemBtn = (UIButton *)subView;
                *stop = YES;
            }
        }
    }];
    return itemBtn;
}

- (BOOL)isNeedZoom:(UIView *)subView {
    return NO;
}

/**
 *  隐藏放大控件
 */
- (void)dismissZoomViewIn:(UIButton *)sender{
    [self dismissZoomView];
}

- (void)dismissZoomView {
    [self.zoomView removeFromSuperview];
}

- (void)setSelectedItemBtn:(UIButton *)selectedItemBtn {
    if (_selectedItemBtn == selectedItemBtn  && _isLongPressed) return;
    _selectedItemBtn = selectedItemBtn;
    [self showZoomView];

}

- (void)showZoomView {
    if (_selectedItemBtn == nil) {
        [self dismissZoomView];
        return;
    }
    [self.window addSubview:self.zoomView];
    self.zoomView.itemBtn = _selectedItemBtn;
}

- (void)showZoomView:(UIButton *)sender {
    if (_selectedItemBtn == nil) {
        [self dismissZoomView];
        return;
    }
    _selectedItemBtn = sender;
    [self.window addSubview:self.zoomView];
    self.zoomView.itemBtn = sender;
}



@end
