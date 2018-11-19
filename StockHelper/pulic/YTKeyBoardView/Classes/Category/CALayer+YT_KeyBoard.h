//
//  CALayer+YT_KeyBoard.h
//  Pods
//
//  Created by laijihua on 16/8/25.
//
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>


//boarder的添加位置
typedef NS_ENUM(NSUInteger, YTBoardPositionStyle) {
    YTBoardPositionStyleBottom,
    YTBoardPositionStyleTop,
    YTBoardPositionStyleRight,
    YTBoardPositionStyleLeft,
};


@interface CALayer (YT_KeyBoard)
/**
 *  添加boarder
 *
 *  @param positionStyle boarder的方位
 *  @param stroke        boarder的粗细
 *  @param color         boarder的颜色
 */
- (void)yt_addBoardPosition:(YTBoardPositionStyle)positionStyle
                     stroke:(CGFloat)stroke
                      color:(UIColor *)color;
@end
