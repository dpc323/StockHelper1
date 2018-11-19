//
//  CALayer+YT_KeyBoard.m
//  Pods
//
//  Created by laijihua on 16/8/25.
//
//

#import "CALayer+YT_KeyBoard.h"



@implementation CALayer (YT_KeyBoard)
/**
 *  添加boarder
 *
 *  @param positionStyle boarder的方位
 *  @param stroke        boarder的粗细
 *  @param color         boarder的颜色
 */
- (void)yt_addBoardPosition:(YTBoardPositionStyle)positionStyle
                     stroke:(CGFloat)stroke
                      color:(UIColor *)color {
    
    CALayer *border = [[CALayer alloc] init];
    switch(positionStyle) {
        case YTBoardPositionStyleTop: {
            border.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), stroke);
        } break;
        case YTBoardPositionStyleLeft: {
            border.frame = CGRectMake(0, 0, stroke, CGRectGetHeight(self.frame));
        } break;
            
        case YTBoardPositionStyleRight: {
            border.frame = CGRectMake(CGRectGetWidth(self.frame) - stroke, 0, stroke, CGRectGetHeight(self.frame));
        } break;
            
        case YTBoardPositionStyleBottom: {
            border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - stroke, CGRectGetWidth(self.frame), stroke);
        } break;
    }
    
    border.backgroundColor = color.CGColor;
    [self addSublayer:border];
    
    
}

@end
