//
//  YT_SearchBaseViewController.h
//  Keyboard
//
//  Created by laijihua on 16/8/17.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YT_KeyBoardView.h"
#import "YT_KeyBoardAccessoryView.h"
#import "UITextField+YT_KeyBoard.h"
#import "YT_SearchBlankView.h"
#import "YT_SearchBaseTabelCell.h"
#import "YT_SearchBaseBar.h"

@interface YT_SearchBaseViewController: UIViewController <YT_KeyBoardViewDelegate, UITableViewDelegate, UITableViewDataSource>

/**
 *  搜索历史管理，默认为空 
 */
@property (nonatomic, strong) NSMutableArray *keyBoardResultArray; //搜索结果

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) YT_SearchBlankView *blankView;

@property (nonatomic, strong) YT_SearchBaseBar *searchBar_;

#pragma mark - 供子类使用的功能
- (void)yt_resignFirstResponder;
- (void)yt_becomeFirstResponder;
- (void)reloadTableView;

#pragma mark - 功能子类继承重写
//  ------- 界面相关
/**
 *  需要复用的cell， 由子类完成，默认是YT_SearchBaseTabelCell
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return 返回YT_SearchBaseTabelCell
 */
- (YT_SearchBaseTabelCell *)yt_tableView:(UITableView *)tableView cellForRowAtIndex:(NSIndexPath *)indexPath;

/**
 *  Cell的点击事件
 *
 *  @param indexPath selected indexPath
 */
- (void)yt_cellDidSelectedAtIndexPath:(NSIndexPath *)indexPath;

/**
 *  cell的编辑按钮的点击事件
 *
 *  @param cell     YT_SearchBaseTabelCell
 *  @param isZiXuan editbtn的状态
 */
- (void)yt_cell:(YT_SearchBaseTabelCell *)cell exitButtonClicked:(BOOL)isZiXuan;


// ================ 历史数据相关
/**
 *  加载历史
 *
 *  @return 历史
 */
- (NSArray *)yt_loadHistory;

/**
 *  清空历史
 */
- (void)yt_clearHistory;

// ================= 搜索相关
/**
 *  返回搜索结果， 搜索逻辑子类完成， 默认为@[]
 *
 *  @param searchText 要搜索的关键字
 *
 *  @return 返回搜索的结果
 */
- (NSArray *)yt_localSearchWithText:(NSString *)searchText;


/**
 *  本地没有搜索到结果， 子类重写这个方法实现 网上实现搜索逻辑
 *
 *  @param searchText 搜索关键字
 */
- (void)yt_handleLocalNotSearchData:(NSString *)searchText;


/**
 *  搜索结束时的操作
 *
 *  @param searchText 搜索关键字
 */
- (void)yt_didEndSearchText:(NSString *)searchText;



@end
