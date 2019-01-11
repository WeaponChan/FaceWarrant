//
//  FWSearchVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWSearchVC.h"
#import "FWSearchView.h"
#import "FWSearchCell.h"
#import "LhkhTagView.h"
#import "LhkhTag.h"
#import "FWSearchManager.h"
#import "FWFaceCell.h"
#import "FWPersonalHomePageVC.h"
#import "FWVoiceView.h"
#import "FWSearchFaceModel.h"
#import "FWSearchFaceCell.h"
#import "FWFaceLibrarySearchVC.h"
#import "FWWindowManager.h"
static int page = 1;
@interface FWSearchVC ()<UITableViewDelegate,UITableViewDataSource,FWSearchCellDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,FWSearchViewDelegate,FWVoiceViewDelegate>
{
    NSString *_searchText;
    
}
@property (strong, nonatomic) FWSearchView *searchView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UITableView *searchTableView;
@property (strong, nonatomic) LhkhTagView *historyTagView;
@property (strong, nonatomic) LhkhTagView *hotTagView;
@property (strong, nonatomic) NSMutableArray *historyDataSource;
@property (strong, nonatomic) NSMutableArray *hotDataSource;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) FWVoiceView *voiceView;
@property (strong, nonatomic) NSDictionary *searchDic;
@property (strong, nonatomic) NSMutableArray *keyList;
@property (strong, nonatomic) NSMutableArray *dataList;
@end

@implementation FWSearchVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setNav];
    [self setTableView];
    [self setSearchTableView];
    [self setCollectionView];
    [self setSubView];
    if ([self.yuyinType isEqualToString:@"1"]) {
        self.voiceView.hidden = NO;
    }else{
        [self.searchView.searchText becomeFirstResponder];
    }   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadHistoryAndHotData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码


#pragma mark - System Delegate

#pragma mark - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView == self.searchTableView) {
        return self.keyList.count;
    }else{
        if (self.historyDataSource.count>0) {
            return 2;
        }
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchTableView) {
        FWSearchFaceCell *cell = [FWSearchFaceCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithData:self.dataList indexPath:indexPath];
        return cell;
    }else{
        FWSearchCell *cell = [FWSearchCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if (self.historyDataSource.count>0) {
            if (indexPath.section == 0) {
                [cell configCellWithData:self.historyDataSource indexPath:indexPath type:@"0"];
            }else{
                [cell configCellWithData:self.hotDataSource indexPath:indexPath type:@"0"];
            }
        }else{
            [cell configCellWithData:self.hotDataSource indexPath:indexPath type:@"1"];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchTableView) {
        FWSearchFaceCell *cell = [FWSearchFaceCell cellWithTableView:tableView];
        return [cell configCellHeightWithData:self.dataList indexPath:indexPath];
    }else{
        FWSearchCell *cell = [FWSearchCell cellWithTableView:tableView];
        if (self.historyDataSource.count>0) {
            if (indexPath.section == 0) {
                return [cell configCellHeightWithData:self.historyDataSource indexPath:indexPath type:@"0"];
            }else{
                return [cell configCellHeightWithData:self.hotDataSource indexPath:indexPath type:@"0"];
            }
        }else{
            return [cell configCellHeightWithData:self.hotDataSource indexPath:indexPath type:@"1"];
        }
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchTableView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 44)];
        UIView *redView = [[UIView alloc]initWithFrame:CGRectMake(10, 12, 3, 20)];
        redView.backgroundColor = Color_Theme_Pink;
        [view addSubview:redView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, 0, Screen_W-18, 44)];
        view.backgroundColor = [UIColor clearColor];
        label.text = self.keyList[section];
        
        label.font = systemFont(16);
        label.textColor = Color_Black;
        [view addSubview:label];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.searchTableView) {
        return 44;
    }
    return 0;
}


- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

#pragma mark - CollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWFaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FWFaceCell class]) forIndexPath:indexPath];
    FWFaceModel *model = self.dataList[indexPath.row];
    [cell configCellWithData:model indexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [FWFaceCell cellSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWFaceModel *model = self.dataList[indexPath.row];
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.faceId = model.userId;
    vc.searchText = _searchText;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - Custom Delegate

#pragma mark - FWSearchCellDelegate
- (void)FWSearchCellDelegateClearAction
{
    [UIAlertController js_alertAviewWithTarget:self andAlertTitle:@"确认清除历史搜索记录吗？" andMessage:@"" andDefaultActionTitle:@"确定" dHandler:^(UIAlertAction *action) {
        [self clearHistory];
    } andCancelActionTitle:@"取消" cHandler:nil completion:nil];
    
}

- (void)FWSearchCellDelegateItemClick:(NSString *)item
{
    [self.view endEditing: YES];
    self.voiceView.hidden = YES;
    self.searchView.searchText.text = item;
    _searchText = item;
    [self loadData:item];
}

#pragma mark - FWSearchViewDelegate

- (void)FWSearchViewDelegateWithTextViewBeginEditing
{
    self.voiceView.hidden = YES;
}

- (void)FWSearchViewDelegateWithText:(NSString *)text
{
    DLog(@"------->%@",text);
    [self.searchView.searchText resignFirstResponder];
    if (text.length == 0 || [text isEqualToString:@""] || text == nil || [text isKindOfClass:[NSNull class]]) {
        self.tableView.hidden = NO;
        self.collectionView.hidden = self.searchTableView.hidden = YES;
    }else{
        _searchText = text;
        [self loadData:text];
    }
}

- (void)FWSearchViewDelegateVoiceClick
{
    [self.searchView.searchText resignFirstResponder];
    self.voiceView.hidden = NO;
    
}

#pragma mark - FWVoiceViewDelegate
-(void)FWVoiceViewDelegateWithText:(NSString *)text
{
    self.searchView.searchText.text = text;
    self.voiceView.hidden = YES;
    _searchText = text;
    [self loadData:text];
}

#pragma mark - Event Response

- (void)cancelAction
{
//    [self.navigationController popToRootViewControllerAnimated:NO];
    [[FWWindowManager sharedWindow] showTabbarViewAgain:self.index];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchView.searchText resignFirstResponder];
}

#pragma mark - Network requests

- (void)loadData:(NSString*)searchText
{
    if ([self.typeStr isEqualToString:@"FWFaceLibraryVC"]) {
        NSDictionary *param = @{
                                @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                                @"searchCondition":searchText,
                                @"requestType":@"0"
                                };
        [FWSearchManager loadFaceLibrarySearchDataWithParameters:param result:^(FWFacelibrarySearchModel *model) {
            FWFaceLibrarySearchVC *vc = [FWFaceLibrarySearchVC new];
            vc.searchText = searchText;
            vc.model = model;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    }else{
        
        NSDictionary *param = @{
                                @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                                @"searchType":@"H",
                                @"condition":searchText?:@"",
                                @"page":@"1",
                                @"rows":pageSize
                                };
        [FWSearchManager loadSearchDataWithParameters:param result:^(NSArray<FWFaceModel *> *model) {
            [self.collectionView.mj_footer setState:MJRefreshStateIdle];
            [self.searchView.searchText resignFirstResponder];
            self.collectionView.hidden = NO;
            self.searchTableView.hidden = self.tableView.hidden  = !self.collectionView.hidden;
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:model];
            [self.collectionView reloadData];
            [self loadHistoryAndHotData];
            if (model.count < pageSize.floatValue) {
                [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
            }
            if (self.dataList.count == 0) {
                [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoSearchResult toView:self.collectionView];
            }else{
                [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.collectionView];
            }
            page = 1;
        }];
    }
}

- (void)loadNextPageData
{
    page++;
    NSDictionary *param = @{
                            @"searchType":@"H",
                            @"condition":_searchText?:@"",
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":pageSize
                            };
    [FWSearchManager loadSearchDataWithParameters:param result:^(NSArray<FWFaceModel *> *model) {
        [self.collectionView.mj_footer endRefreshing];
        [self.dataList addObjectsFromArray:model];
        [self.collectionView reloadData];
        if (model.count < pageSize.floatValue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
                });
            });
        }
    }];
}

- (void)loadHistoryAndHotData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID]
                            };
    
    [FWSearchManager loadSearchHistoryDataWithParameters:param result:^(NSArray<FWSearchHotModel *> *hotModel, NSArray<FWSearchHistoryModel *> *historyModel) {
        [self.historyDataSource removeAllObjects];
        [self.hotDataSource removeAllObjects];
        [self.hotDataSource addObjectsFromArray:hotModel];
        [self.historyDataSource addObjectsFromArray:historyModel];
        [self.tableView reloadData];
    }];
}

- (void)clearHistory
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID]
                            };
    
    [FWSearchManager clearSearchHistoryDataWithParameters:param result:^(id response) {
        [self loadHistoryAndHotData];
    }];
}

#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setNav
{
    self.navigationItem.leftBarButtonItem = nil;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
//    view.backgroundColor = [UIColor clearColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem js_itemWithTitle:@"取消" target:self action:@selector(cancelAction)];
    self.navigationItem.titleView = self.searchView;
}


- (void)setTableView
{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = Color_MainBg;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        if (iOS11Later) {
            make.top.equalTo(self.view).offset(NavigationBar_H);
        }else{
            make.top.equalTo(self.view);
        }
        make.bottom.mas_equalTo(self.view);
    }];
}

- (void)setSubView
{
    self.voiceView.hidden = YES;
    self.voiceView.delegate = self;
    [self.view addSubview:self.voiceView];
    
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(200);
        make.left.right.bottom.equalTo(self.view);
    }];
}


- (void)setSearchTableView
{
    _searchTableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = Color_MainBg;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    self.searchTableView.hidden = YES;
    self.searchTableView.estimatedRowHeight = 0;
    self.searchTableView.estimatedSectionHeaderHeight = 0;
    self.searchTableView.estimatedSectionFooterHeight = 0;
    self.searchTableView.showsVerticalScrollIndicator = NO;
    [self.searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        if (iOS11Later) {
            make.top.equalTo(self.view).offset(NavigationBar_H);
        }else{
            make.top.equalTo(self.view);
        }
        make.bottom.mas_equalTo(self.view);
    }];
}

- (void)setCollectionView
{
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);//分区内边距
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        [collectionView registerClass:[FWFaceCell class] forCellWithReuseIdentifier:NSStringFromClass([FWFaceCell class])];
        [self.view addSubview:collectionView];
        collectionView;
    });
    
    __weak typeof (self) weakself = self;
    self.collectionView.hidden = YES;
    self.collectionView.mj_footer = [RefreshCatGifFooter footerWithRefreshingBlock:^{
        [weakself loadNextPageData];
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NavigationBar_H);
    }];
}


#pragma mark - Setters

- (UICollectionView*)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero];
    }
    return _collectionView;
}


- (FWSearchView*)searchView
{
    if (_searchView == nil) {
        _searchView = [[FWSearchView alloc] initWithFrame:CGRectMake(0, 0, Screen_W-40, 30)];
        _searchView.backgroundColor = Color_MainBg;
        _searchView.delegate = self;
        _searchView.vcStr = @"FWSearchVC";
        _searchView.clickBtn.hidden = YES;
    }
    return _searchView;
}

- (FWVoiceView*)voiceView
{
    if (_voiceView == nil) {
        _voiceView = [[FWVoiceView alloc] initWithFrame:CGRectMake(0, Screen_H-300, Screen_W, 300)];
        _voiceView.vctype = @"0";
        [self.view addSubview:_voiceView];
        _voiceView.hidden = YES;
    }
    return _voiceView;
}

- (LhkhTagView*)historyTagView
{
    if (_historyTagView == nil) {
        [_historyTagView removeAllTags];
        _historyTagView = [[LhkhTagView alloc] init];
        _historyTagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
        _historyTagView.lineSpacing = 10;
        _historyTagView.interitemSpacing = 10;
        _historyTagView.preferredMaxLayoutWidth = Screen_W;
    }
    return _historyTagView;
}

- (LhkhTagView*)hotTagView
{
    if (_hotTagView == nil) {
        [_hotTagView removeAllTags];
        _hotTagView = [[LhkhTagView alloc] init];
        _hotTagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
        _hotTagView.lineSpacing = 10;
        _hotTagView.interitemSpacing = 10;
        _hotTagView.preferredMaxLayoutWidth = Screen_W;
    }
    return _hotTagView;
}


-(NSMutableArray *)historyDataSource
{
    if (_historyDataSource == nil) {
        _historyDataSource = [NSMutableArray array];
    }
    return _historyDataSource;
}

-(NSMutableArray *)hotDataSource
{
    if (_hotDataSource == nil) {
        _hotDataSource = [NSMutableArray array];
    }
    return _hotDataSource;
}

- (NSDictionary*)searchDic
{
    if (_searchDic == nil) {
        _searchDic = [NSDictionary dictionary];
    }
    return _searchDic;
}

- (NSMutableArray*)keyList
{
    if (_keyList == nil) {
        _keyList = [[NSMutableArray alloc] init];
    }
    return _keyList;
}

- (NSMutableArray*)dataList
{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

#pragma mark - Getters




@end
