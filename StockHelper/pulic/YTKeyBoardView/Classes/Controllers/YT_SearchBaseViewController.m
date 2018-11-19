//
//  YT_SearchBaseViewController.m
//  Keyboarde
//
//  Created by laijihua on 16/8/17.
//  Copyright © 2016年 laijihua. All rights reserved.
//

#import "YT_SearchBaseViewController.h"
#import "YT_SearchClearHistoryCell.h"
#import "YT_SearchBaseTabelCell.h"
@interface YT_SearchBaseViewController ()<UITextFieldDelegate, YT_SearchBaseTabelCellDelegate>

@property (nonatomic, assign) BOOL isNeedClearHistoryShow;
@end

@implementation YT_SearchBaseViewController

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.keyBoardResultArray = [NSMutableArray array];
    [self systomeCompatibilityHandle];
    [self yt_addSubView];
    [self yt_becomeFirstResponder];
    [self loadHistory];
    self.view.backgroundColor = [UIColor blueColor];
}

// 让搜索框成为第一响应者
- (void)yt_becomeFirstResponder {
    [self.searchBar_.searchTextField becomeFirstResponder];
}

- (void)yt_resignFirstResponder {
    [self.searchBar_.searchTextField resignFirstResponder];
}


// 重新刷新表格
- (void)reloadTableView {
    if (self.keyBoardResultArray.count > 0) {
        [self.view bringSubviewToFront:self.tableView];
        [self.tableView reloadData];
    }else { // 没有数据
        [self.view bringSubviewToFront:self.blankView];
    }
}

- (NSArray *)yt_loadHistory {
    return @[];
}

// 加载历史
- (void)loadHistory {
    NSMutableArray *arrayKeyBoardHistory = [[self yt_loadHistory] mutableCopy];
    if (arrayKeyBoardHistory.count > 0) {
        self.keyBoardResultArray = arrayKeyBoardHistory;
        self.isNeedClearHistoryShow = YES;
        [self reloadTableView];
    } else {
        self.isNeedClearHistoryShow = NO;
        [self.tableView reloadData];
        
    }
}

// 加载子View
- (void)yt_addSubView {
    self.view.backgroundColor = [UIColor whiteColor];
    //[self.view addSubview:self.blankView]; // 添加空白界面
    
    self.searchBar_.searchTextField.inputView = [self getKeyBoardView];
    self.searchBar_.searchTextField.inputAccessoryView = [self getKeyBoardAccessoryView];
    
    self.navigationItem.titleView = self.searchBar_;
    self.navigationItem.hidesBackButton = YES;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerClass:[YT_SearchClearHistoryCell class] forCellReuseIdentifier:kCellID_YT_SearchClearHistoryCell];
    [self.tableView registerClass:[YT_SearchBaseTabelCell class] forCellReuseIdentifier:kCellID_YT_SearchBaseTabelCell];
    [self setSeparatorLineLeftZero];

}

- (YT_SearchBaseBar *)searchBar_ {
    if (!_searchBar_) {
        CGRect frame = CGRectMake(10, 0, CGRectGetWidth(self.view.frame) - 20, 34) ;
        _searchBar_ = [YT_SearchBaseBar searchBarWithFrame:frame rightViewTarget:self  action:@selector(cancleAction:)];
        [_searchBar_.searchTextField addTarget:self action:@selector(systenKeyboardTextChangeAction:) forControlEvents:UIControlEventEditingChanged];
        [_searchBar_.searchTextField addTarget:self action:@selector(systemKeyBoardReturnAction:) forControlEvents:UIControlEventEditingDidEndOnExit];
    }
    return _searchBar_;
}


- (YT_KeyBoardView *)getKeyBoardView {
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
    
    YT_KeyBoardView *keyboardView = [[YT_KeyBoardView alloc] initWithFrame:frame
                                                              keyBoardType:YT_KeyBoardType_NumBerCharacterSystemLeft
                                                     keyBoardFirstShowType:YT_KeyBoardShowStyle_Number
                                                                  delegate:self
                                                                 textField:self.searchBar_.searchTextField];
    return keyboardView;
    
}

- (YT_KeyBoardAccessoryView *)getKeyBoardAccessoryView {
    YT_KeyBoardAccessoryView *keyboardAccessoryView = [[YT_KeyBoardAccessoryView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44) ];
    keyboardAccessoryView.delegate = self.searchBar_.searchTextField;
    return keyboardAccessoryView;
}

#pragma mark - Action
// 取消
- (void)cancleAction:(UIButton *)sender {
    [self yt_resignFirstResponder];
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)yt_clearHistory {
    
}

// 清空历史
- (void)clearHistoryAction{
    [self yt_clearHistory];
    self.keyBoardResultArray = nil;
    self.isNeedClearHistoryShow = NO;
    [self.tableView reloadData];
}

// 系统键盘状态下，textField的文字变化时会调用这个方法。
- (void)systenKeyboardTextChangeAction:(UITextField *)textField {
    [self keyBoardSearhHandleWithText:textField.text];
}

- (void)systemKeyBoardReturnAction:(UITextField *)textField {
    [self yt_resignFirstResponder];
}

#pragma mark - YT_KeyBoardViewDelegate
// 搜索按钮改变的时候
- (void)keyBoardView:(YT_KeyBoardView *)keyBoardView changeText:(NSString *)text {
    [self keyBoardSearhHandleWithText:text];
}


// 确定按钮点击
- (void)keyBoardViewShouldConfirm:(YT_KeyBoardView *)keyBoardView {
    [self yt_resignFirstResponder];
}

- (NSArray *)yt_localSearchWithText:(NSString *)searchText {
    return @[];
}

#pragma mark - network  搜索逻辑
- (void)keyBoardSearhHandleWithText:(NSString *)currText {
    if (self.keyBoardResultArray.count > 0) {
        [self.keyBoardResultArray removeAllObjects];
    }
    
    if ([currText length] != 0) {
        // 需要方法
        self.keyBoardResultArray = [self yt_localSearchWithText:currText];
        
        if([self.keyBoardResultArray count] > 0) {
            [self reloadTableView];
            // 如果count == 1
        } else { // 本地查询没有数据
            [self yt_handleLocalNotSearchData:currText];
        }
        
        [self yt_didEndSearchText:currText];
    } else { // 为0的时候，使用历史
        [self loadHistory];
    }
    
}

- (void)yt_didEndSearchText:(NSString *)searchText {
    
}

- (void)yt_handleLocalNotSearchData:(NSString *)currText {
    
}

#pragma mark - setter and getter
- (UITableView *)tableView {
    if (_tableView == nil){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    
    return _tableView;
}


- (YT_SearchBlankView *)blankView {
    if (_blankView == nil) {
        _blankView = [[YT_SearchBlankView alloc] initWithFrame:self.view.bounds];
        _blankView.blankTitle = @"您输入的股票不存在";
    }
    return _blankView;
}

#pragma mark -  TableView delegate and Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.isNeedClearHistoryShow ? self.keyBoardResultArray.count + 1 : self.keyBoardResultArray.count);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}



- (YT_SearchBaseTabelCell *)yt_tableView:(UITableView *)tableView cellForRowAtIndex:(NSIndexPath *)indexPath {
    YT_SearchBaseTabelCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID_YT_SearchBaseTabelCell forIndexPath:indexPath];
    cell.delegate = self;
    cell.indexPath = indexPath;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if (row < self.keyBoardResultArray.count) {
        YT_SearchBaseTabelCell* cell= [self yt_tableView:tableView cellForRowAtIndex:indexPath];
        cell.indexPath = indexPath;
        cell.delegate = self;
        return cell;
    } else {
        YT_SearchClearHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID_YT_SearchClearHistoryCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if (row < self.keyBoardResultArray.count) {

        [self handleCellSelected:indexPath];
    } else if (row == self.keyBoardResultArray.count) { // 清空历史
        [self clearHistoryAction];
    }
    
}

#pragma mark - YT_SearchBaseTabelCellDelegate
- (void)searchBaseTableCell:(YT_SearchBaseTabelCell *)cell editButtonClicked:(BOOL)isZiXuan {
    NSIndexPath *indexPath = cell.indexPath;
    NSParameterAssert(indexPath.row < self.keyBoardResultArray.count);
    [self yt_cell:cell exitButtonClicked:isZiXuan];
}

- (void)yt_cell:(YT_SearchBaseTabelCell *)cell exitButtonClicked:(BOOL)isZiXuan {
    
}

- (void)handleCellSelected:(NSIndexPath *)indexPath {
    [self yt_cellDidSelectedAtIndexPath:indexPath];
    [self  yt_resignFirstResponder];
}

- (void)yt_cellDidSelectedAtIndexPath:(NSIndexPath *)indexPath {

}

#pragma mark - helper
- (void)setSeparatorLineLeftZero {
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 80000
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)]) {
            [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        }
    }
#endif
}

- (void)systomeCompatibilityHandle {
    //此设置必须添加，不然tableview上方有空白
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
@end
