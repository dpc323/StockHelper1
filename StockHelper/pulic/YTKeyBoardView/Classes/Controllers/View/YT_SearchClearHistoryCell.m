//
//  YT_SearchClearHistoryCell.m
//  Keyboarde
//
//  Created by laijihua on 16/8/18.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "YT_SearchClearHistoryCell.h"

NSString *const kCellID_YT_SearchClearHistoryCell = @"YT_SearchClearHistoryCell";

@interface YT_SearchClearHistoryCell ()
@property (nonatomic, strong) UILabel *clearLable;
@end

@implementation YT_SearchClearHistoryCell

#pragma mark - initial
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    
    return self;
}


#pragma mark - add subviews (setup)
- (void)setup {
    [self.contentView addSubview:self.clearLable];
    self.clearLable.text = @"清除搜索记录";
}

#pragma mark - getter / setter

- (UILabel *)clearLable {
    if (!_clearLable) {
        _clearLable = [[UILabel alloc] initWithFrame:self.bounds];
        _clearLable.font = [UIFont systemFontOfSize:14];
        _clearLable.textAlignment = NSTextAlignmentCenter;
        _clearLable.textColor = [UIColor grayColor];
    }
    return _clearLable;
}

@end
