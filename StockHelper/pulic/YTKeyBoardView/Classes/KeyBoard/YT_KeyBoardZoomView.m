//
//  YT_KeyBoardZoomView.m
//  Keyboarde
//
//  Created by laijihua on 16/8/16.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "YT_KeyBoardZoomView.h"

@interface YT_KeyBoardZoomView ()

@property (nonatomic, strong) UILabel *zoomLabel;
@property (nonatomic, strong) UIImageView *bgImgView;

@end

@implementation YT_KeyBoardZoomView

#pragma mark - initial

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

+ (instancetype)zoomView {
    YT_KeyBoardZoomView *zoomView = [[YT_KeyBoardZoomView alloc] initWithFrame:CGRectMake(0, 0, 64, 90)];
    
    return zoomView;
}



- (void)setItemBtn:(UIButton *)itemBtn {
    _itemBtn = itemBtn;
    
    [self showWithItemBtn:itemBtn];
}


/**
 *  实时显示位置
 *
 *  @param itemBtn 选中的表情的按钮
 */
- (void)showWithItemBtn:(UIButton *)itemBtn {
    self.zoomLabel.text = [itemBtn titleForState:UIControlStateNormal];
    //坐标系转换
    CGRect frame_selectedItemBtn_convert = [itemBtn convertRect:itemBtn.bounds toView:itemBtn.window];
    
    //得到之前的frame
    CGRect frame_zoomView = self.bounds;
    
    frame_zoomView.origin.x = frame_selectedItemBtn_convert.origin.x + (frame_selectedItemBtn_convert.size.width - frame_zoomView.size.width) * .5f;
    frame_zoomView.origin.y = frame_selectedItemBtn_convert.origin.y + frame_selectedItemBtn_convert.size.height -self.bounds.size.height-5.0f;
    
    self.frame = frame_zoomView;
}


#pragma mark - add subviews (setup)
- (void)setup {
    [self addSubview:self.bgImgView];
    [self addSubview:self.zoomLabel];
}

- (NSString *)bundlePath {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"Resources" ofType:@"bundle"];
    return path;
}

- (UIImage *)bgImage {
    NSString *path = [[self bundlePath] stringByAppendingPathComponent:@"emoticon_keyboard_magnifier@2x.png"];
    return [UIImage imageWithContentsOfFile:path];
}


#pragma mark - getter / setter
- (UIImageView *)bgImgView {
    if (!_bgImgView) {
        _bgImgView = [[UIImageView alloc] initWithImage: [self bgImage]];
    }
    return _bgImgView;
}


- (UILabel *)zoomLabel {
    if (!_zoomLabel) {
        _zoomLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 8, 36, 36)];
        _zoomLabel.textAlignment = NSTextAlignmentCenter;
        _zoomLabel.font = [UIFont systemFontOfSize:36];
    }
    return _zoomLabel;
}

#pragma mark - config test data


@end
