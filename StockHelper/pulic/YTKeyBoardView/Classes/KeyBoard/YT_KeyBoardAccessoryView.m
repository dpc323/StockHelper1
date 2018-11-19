//
//  KeyBoardAccessoryView.m
//  Keyboard
//
//  Created by laijihua on 16/8/12.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "YT_KeyBoardAccessoryView.h"
#import "CALayer+YT_KeyBoard.h"



static NSInteger const kKeyBoardAccessoryViewTag = 34923;

@interface YT_KeyBoardAccessoryView()
@end

@implementation YT_KeyBoardAccessoryView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame: frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {

    UIColor *borderColor = [UIColor colorWithRed:0.8745 green:0.8745 blue:0.8745 alpha:1.0];
    UIButton *hiddenBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 50, 0, 50, self.frame.size.height)];
    
    hiddenBtn.tag = kKeyBoardAccessoryViewTag + 2;
    [hiddenBtn setTitle:@"隐藏" forState:UIControlStateNormal];
    [hiddenBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self addSubview:hiddenBtn];
    [hiddenBtn addTarget:self  action:@selector(hidenKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.layer yt_addBoardPosition:YTBoardPositionStyleTop stroke:1 color:borderColor];
    [hiddenBtn.layer yt_addBoardPosition:YTBoardPositionStyleLeft stroke:1 color:borderColor];
}

- (void)hidenKeyboard:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(keyboardViewEndEdit)]) {
        [_delegate keyboardViewEndEdit];
    }
}

- (void)clickAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(keyboarAccessoryView:didClickIndex:)]) {
        [_delegate keyboarAccessoryView:self didClickIndex:sender.tag - kKeyBoardAccessoryViewTag];
    }
}


@end
