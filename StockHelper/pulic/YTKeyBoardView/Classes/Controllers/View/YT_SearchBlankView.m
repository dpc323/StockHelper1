//
//  YT_SearchBlankView.m
//  Keyboarde
//
//  Created by laijihua on 16/8/18.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "YT_SearchBlankView.h"
#import "NSString+YT_KeyBoard.h"

@interface YT_SearchBlankView ()
@property (nonatomic, strong) UILabel *titleLabel; 
@end

@implementation YT_SearchBlankView

#pragma mark - initial

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

#pragma mark - add subviews (setup)
- (void)setup {
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.titleLabel];
    [self yt_laoutSubViews];
}

- (void)yt_laoutSubViews {
    CGFloat padding = 20;
    self.titleLabel.frame = CGRectMake(padding, 64, CGRectGetWidth(self.frame) - 2 * padding, 0);
}

- (void)setBlankTitle:(NSString *)blankTitle {
    self.titleLabel.text = blankTitle;
    CGRect frame = self.titleLabel.frame;
    frame.size.height = [blankTitle yt_kGetHeightByWidth:frame.size.width font:self.titleLabel.font];
    self.titleLabel.frame = frame;
}

- (NSString *)blankTitle {
    return self.titleLabel.text;
}


#pragma mark - setter and getter
- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}






@end
