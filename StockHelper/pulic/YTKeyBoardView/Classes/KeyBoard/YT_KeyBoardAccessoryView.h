//
//  KeyBoardAccessoryView.h
//  Keyboard
//
//  Created by laijihua on 16/8/12.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YT_KeyBoardAccessoryView;

@protocol YT_KeyBoardAccessoryViewDelegate <NSObject>
@optional
- (void)keyboarAccessoryView:(YT_KeyBoardAccessoryView *)accessoryView didClickIndex:(NSInteger)index;
- (void)keyboardViewEndEdit;
@end

@interface YT_KeyBoardAccessoryView : UIView

@property (nonatomic, weak) id<YT_KeyBoardAccessoryViewDelegate> delegate;

@end
