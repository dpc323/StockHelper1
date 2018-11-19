//
//  YT_KeyBoardTheme.m
//  Pods
//
//  Created by laijihua on 16/8/25.
//
//

#import "YT_KeyBoardTheme.h"

@implementation YT_KeyBoardTheme

- (instancetype)init {
    if (self = [super init]) {
        self.keyBoardBackgroundColor = [UIColor colorWithRed:0.7647 green:0.7882 blue:0.8078 alpha:1.0];
        self.keyBoardInputButtonColor = [UIColor whiteColor];
        
        self.keyBoardInputButtonPressDownColor = [UIColor colorWithRed:0.7647 green:0.7882 blue:0.8078 alpha:1.0];
        
        
        self.keyBoardConfirmButtonColor = [UIColor colorWithRed:0.0588 green:0.3647 blue:0.7529 alpha:1.0];
        
        self.keyBoardConfirmButtonPressDownColor = [UIColor colorWithRed:0.0588 green:0.3647 blue:0.7529 alpha:1.0];
        
        
        self.numberBoardControlButtonColor = [UIColor colorWithRed:0.8863 green:0.9098 blue:0.949 alpha:1.0];
        self.numberBoardControlButtonPressColor = [UIColor whiteColor];
        
        self.characterBoardContrlColor = [UIColor colorWithRed:0.8863 green:0.9098 blue:0.949 alpha:1.0];
        self.characterBoardControlPressColor = [UIColor whiteColor];
        
        self.characterBoardInputButtonPressDownColor = [UIColor colorWithRed:0.0588 green:0.3647 blue:0.7529 alpha:1.0];
        
        self.characterBoardContrlColor = [UIColor colorWithRed:0.6039 green:0.6353 blue:0.6863 alpha:1.0];
    }
    return self;
}


@end
