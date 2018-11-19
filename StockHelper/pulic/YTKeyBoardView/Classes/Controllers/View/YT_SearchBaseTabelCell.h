//
//  YT_SearchBaseTabelCell.h
//  KDS_Phone
//
//  Created by laijihua on 16/8/18.
//  Copyright © 2016年 kds. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YT_SearchBaseTabelCell;

// 可对这个cell赋值的操作
@protocol YT_SearchBaseTabelCellAssignable <NSObject>
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, copy) NSString *pszMark;
@property (nonatomic, assign, readonly) BOOL bZiXuan;
@end


@protocol YT_SearchBaseTabelCellDelegate <NSObject>

/**
 *  编辑按钮点击
 *
 *  @param cell     cell
 *  @param isZiXuan 该信息是自选信息
 */
- (void)searchBaseTableCell:(YT_SearchBaseTabelCell *)cell editButtonClicked:(BOOL)isZiXuan;

@end

extern NSString *const kCellID_YT_SearchBaseTabelCell; ///> Cell Identifier

@interface YT_SearchBaseTabelCell: UITableViewCell

@property (nonatomic, weak) id<YT_SearchBaseTabelCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;

- (void)configData:(id<YT_SearchBaseTabelCellAssignable> )data;

@end
