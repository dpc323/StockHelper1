//
//  YT_SearchBaseBar.m
//  Keyboarde
//
//  Created by laijihua on 16/8/17.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "YT_SearchBaseBar.h"
#import "UIButton+YT_KeyBoard.h"

@interface YT_SearchBaseBar ()
@property (nonatomic, strong) UIView *leftV_;
@property (nonatomic, strong) UIView *rightV_;

@property (nonatomic, strong) UIView *cornerView;
@end

@implementation YT_SearchBaseBar

#pragma mark - initial
- (instancetype)initWithFrame:(CGRect)frame leftView:(UIView *)leftView rightView:(UIView *)rightView {
    if (self = [super initWithFrame:frame]) {
        _leftV_ = leftView;
        _rightV_ = rightView;
        [self setup];
    }
    return self;
}

#pragma mark - add subviews (setup)
- (void)setup {
    CGFloat left = 0;
    CGFloat right = 0;
    CGFloat selfHeight = self.frame.size.height;
    CGFloat selfWidth = self.frame.size.width;
    CGFloat padding = 4;
    
    self.cornerView = [[UIView alloc] init];
    self.cornerView.layer.cornerRadius = 5;
    self.cornerView.layer.masksToBounds = YES;
    self.cornerView.layer.borderColor = [UIColor blackColor].CGColor;
    self.cornerView.layer.borderWidth = 1;
    self.cornerView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.cornerView];
    
    if (self.leftV_) {
        left = MIN(CGRectGetMaxX(self.leftV_.bounds)+ padding, selfWidth);
        CGFloat leftH = MIN(CGRectGetWidth(self.leftV_.frame),selfHeight);
        self.leftV_.frame = CGRectMake(padding, (selfHeight - leftH)/2, left, leftH);
        [self addSubview:self.leftV_];
    }
    
    if (self.rightV_) {
        right = MIN(CGRectGetWidth(self.rightV_.bounds), selfWidth);
        CGFloat rightH = MIN(CGRectGetHeight(self.rightV_.frame), selfHeight);
        self.rightV_.frame = CGRectMake(selfWidth - right, (selfHeight - rightH)/2, right, rightH);
        [self addSubview:self.rightV_];
    }
    
    self.cornerView.frame = CGRectMake(0, 0, selfWidth - right , selfHeight);
    
    
    CGRect rect = CGRectMake(left + 2 * padding , 0, selfWidth - left - right - padding, selfHeight);
    _searchTextField = [[UITextField alloc] initWithFrame:rect];
    [self addSubview:_searchTextField];
    
}


+ (instancetype)searchBarWithFrame:(CGRect)frame
                   rightViewTarget:(id)target
                            action:(SEL)action {

    UIImageView *leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Said_SearchBtn"]];
    CGRect rBtnF = CGRectMake(0, 0, 44, 34);
    UIFont *rFont = [UIFont systemFontOfSize:14];
    UIColor *rColor = [UIColor blackColor];
    NSString *title = @"取消";
    UIButton *rightBtn = [UIButton yt_createButton:rBtnF
                               normalSelectImgName:nil
                                     selectImgName:nil
                                               tag:100
                                             title:title
                                        titleColor:rColor
                                         titleFont:rFont
                                            target:target
                                          selector:action];

    YT_SearchBaseBar *searchBar = [[YT_SearchBaseBar alloc] initWithFrame:frame leftView:leftView rightView:rightBtn];
    searchBar.searchTextField.placeholder = @"股票/基金/板块";
    searchBar.searchTextField.font = rFont;
    return searchBar;
}


- (void)setSearchText:(NSString *)searchText {
    self.searchTextField.text = searchText;
}

- (NSString *)searchText {
    return  self.searchTextField.text;
}

@end
