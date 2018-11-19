//
//  YT_KeyBoardZoomView.h
//  Keyboard
//
//  Created by laijihua on 16/8/16.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *  长按放大的View
 */
@interface YT_KeyBoardZoomView: UIView

@property (nonatomic, strong) UIButton *itemBtn;


/*
 *  快速实例化
 */
+ (instancetype)zoomView;

@end
