//
//  YT_SearchBaseTabelCell.m
//  KDS_Phonee
//
//  Created by laijihua on 16/8/18.
//  Copyright © 2016年 kds. All rights reserved.
//

#import "YT_SearchBaseTabelCell.h"
#import "Masonry.h"

NSString *const kCellID_YT_SearchBaseTabelCell = @"YT_SearchBaseTabelCell";

@interface YT_SearchBaseTabelCell()

@property (nonatomic, strong) UILabel *markLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *codeLabel;
@property (nonatomic, strong) UIButton *editBtn;

@property (nonatomic, assign) BOOL bZiXuan;  // 是否为自选
@end

@implementation YT_SearchBaseTabelCell

#pragma mark - initial
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setup];
        
    }
    return  self;
    
}


#pragma mark - add subviews (setup)
- (void)setup {
    [self.contentView addSubview:self.markLabel];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.codeLabel];
    [self.contentView addSubview:self.editBtn];
    [self layoutUI];
}

#pragma mark - view layouts
- (void)layoutUI {
    CGFloat padding = 5;
    [self.markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(padding);
        make.centerY.mas_equalTo(self);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(14);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.markLabel.mas_right).offset(padding);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(100);
    }];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(padding);
        make.centerY.equalTo(self);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(14);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-padding);
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.centerY.equalTo(self);
    }];

}

#pragma mark - getter / setter
- (UILabel *)markLabel {
    if (!_markLabel) {
        _markLabel = [[UILabel alloc] init];
        _markLabel.font = [UIFont systemFontOfSize:12];
        _markLabel.textAlignment = NSTextAlignmentCenter;
        _markLabel.backgroundColor = [UIColor colorWithRed:1.0 green:0.446 blue:0.074 alpha:1.0];
        _markLabel.layer.cornerRadius = 2;
        _markLabel.textColor = [UIColor blackColor];
        _markLabel.layer.masksToBounds = YES;
    }
    
    return _markLabel;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:14];
    }
    return _nameLabel;
}

- (UILabel *)codeLabel {
    if (!_codeLabel) {
        _codeLabel = [[UILabel alloc] init];
        _codeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _codeLabel;
}

- (UIButton *)editBtn {
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        _editBtn.backgroundColor = [UIColor brownColor];
        [_editBtn setTitle:@"+" forState:UIControlStateNormal];
        [_editBtn addTarget:self action:@selector(editBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editBtn;
}

- (void)setBZiXuan:(BOOL)bZiXuan {
    
    _bZiXuan = bZiXuan;
    if (_bZiXuan) {
        [self.editBtn setTitle:@"-" forState:UIControlStateNormal];
    } else {
        [self.editBtn setTitle:@"+" forState:UIControlStateNormal];
    }
}


- (void)configData:(id<YT_SearchBaseTabelCellAssignable>)data {
    self.nameLabel.text = data.name;
    self.codeLabel.text = data.code;
    self.markLabel.text = data.pszMark;
    self.bZiXuan = data.bZiXuan;
}

- (void)editBtnClick:(UIButton *)sender {
    if (_delegate) {
        [_delegate searchBaseTableCell:self editButtonClicked:self.bZiXuan];
    }
}

@end
