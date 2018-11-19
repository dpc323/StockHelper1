//
//  YT_SearchBaseBar.h
//  Keyboard
//
//  Created by laijihua on 16/8/17.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YT_SearchBaseBar: UIView
@property (nonatomic, strong) UIView *leftView;  ///< 搜索框左边的view
@property (nonatomic, strong) UIView *rightView; ///< 搜索框右边的view
@property (nonatomic, strong, readonly) UITextField *searchTextField;

@property (nonatomic, copy) NSString *searchText;


- (instancetype)initWithFrame:(CGRect)frame leftView:(UIView *)leftView rightView:(UIView *)rightView;

+ (instancetype)searchBarWithFrame:(CGRect)frame
                   rightViewTarget:(id)target
                            action:(SEL)action;

@end
