//
//  YT_KeyBoardZoomAbleView.h
//  Keyboard
//
//  Created by laijihua on 16/8/17.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YT_KeyBoardZoomView.h"
#import "YT_KeyBoardEnum.h"
/**
 *  键盘有对按键有放大效果的功能都可以继承这个View
 */
@interface YT_KeyBoardZoomAbleView: UIView

/**
 *  放大的View
 */
@property (nonatomic, strong) YT_KeyBoardZoomView *zoomView;

#pragma mark - 供子类重写(必须)
/**
 *  判断这个subView 是否需要放大效果
 *
 *  @param subView 选中的view
 *
 *  @return 返回BOOL
 */
- (BOOL)isNeedZoom:(UIView *)subView;


/**
 *  隐藏放大控件
 */
- (void)dismissZoomViewIn:(UIButton *)sender NS_REQUIRES_SUPER;

/**
 *  放大控件
 *
 *  @param sender 需要放大的控件
 */
- (void)showZoomView:(UIButton *)sender;

@end
