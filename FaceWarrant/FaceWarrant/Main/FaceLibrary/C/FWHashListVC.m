//
//  FWHashListVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWHashListVC.h"
#import "FWSearchView.h"
#import "FWQuestionManager.h"
#import "FWFaceLibraryManager.h"
#import "FWHashCell.h"
#import "FWVoiceView.h"
@interface FWHashListVC ()<UITableViewDataSource,UITableViewDelegate,FWSearchViewDelegate,FWVoiceViewDelegate>
{
    NSString *_searchText;
    BOOL isSearch;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FWSearchView *searchView;
@property (strong, nonatomic) FWVoiceView *voiceView;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;//毛玻璃视图
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation FWHashListVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];
    [self setNav];
    [self setTableView];
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FWHashCell *cell = [FWHashCell cellWithTableView:tableView] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithitem:self.dataArr[indexPath.row] isSearch:isSearch indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FWHashCell cellHeight];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 40)];
    view.backgroundColor = Color_MainBg;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Screen_W-10, 40)];
    
    label.textColor = Color_Black;
    label.font = systemFont(14);
    [view addSubview:label];
    label.text = @"推荐话题";
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *hash = self.dataArr[indexPath.row];
    if (self.hashblock) {
        self.hashblock(hash);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Custom Delegate
#pragma mark - FWSearchViewDelegate
- (void)FWSearchViewDelegateWithText:(NSString *)text
{
    if (text.length>0 && ![text isEqualToString:@""]) {
        isSearch = YES;
        [self loadSearchHash:text];
    }else{
        [self loadData];
    }
}

- (void)FWSearchViewDelegateWithTextViewBeginEditing
{
    self.voiceView.hidden = YES;
}

- (void)FWSearchViewDelegateVoiceClick
{
    [self.view endEditing:YES];
    self.voiceView.hidden = self.visualEffectView.hidden = NO;
}

#pragma mark - FWVoiceViewDelegate

- (void)FWVoiceViewDelegateWithText:(NSString *)text
{
    if (text.length>0 && ![text isEqualToString:@""]) {
         isSearch = YES;
        self.searchView.searchText.text = text;
        [self loadSearchHash:text];
    }else{
        [self loadData];
    }
}

#pragma mark - Event Response

- (void)singleTapDetected
{
    self.voiceView.hidden = self.visualEffectView.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Network Requests

- (void)loadData
{
    isSearch = NO;
    NSDictionary *param = @{
                            @"flag":@"1"
                            };
    [FWQuestionManager loadQuestionHotTagsWithParameters:param result:^(NSArray *arr) {
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:arr];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (arr.count == 0) {
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.tableView];
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.tableView];
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.tableView];
        }
    }];
}

- (void)loadSearchHash:(NSString*)searchText
{
    NSDictionary *param = @{
                            @"searchCondition":searchText?:@""
                            };
    [FWFaceLibraryManager loadSearchHashWithParameters:param result:^(NSArray *arr) {
        [self.view endEditing:YES];
        self.voiceView.hidden = YES;
        self.visualEffectView.hidden = YES;
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:arr];
        [self.tableView reloadData];
        if (arr.count == 0) {
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoSearchResult toView:self.tableView];
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.tableView];
        }
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.title = @"选择标签";
    [self.view addSubview:self.searchView];
    isSearch = NO;
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
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.searchView.mas_bottom).offset(10);
        make.bottom.mas_equalTo(self.view);
    }];
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    
    LhkhWeakSelf(self);
    self.tableView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    
    //实现模糊效果
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //毛玻璃视图
    self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    self.visualEffectView.frame = CGRectMake(0, 40+NavigationBar_H, Screen_W, Screen_H);
    self.visualEffectView.alpha = 0.5;
    self.visualEffectView.hidden = YES;
    [self.view addSubview:self.visualEffectView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.visualEffectView setUserInteractionEnabled:YES];
    [self.visualEffectView addGestureRecognizer:singleTap];
    
    self.voiceView.hidden = YES;
    [self.view addSubview:self.voiceView];
    
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(200);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Setters
- (FWSearchView*)searchView
{
    if (_searchView == nil) {
        _searchView = [[FWSearchView alloc] initWithFrame:CGRectMake(10, NavigationBar_H+10, Screen_W-20, 30)];
        _searchView.vcStr = @"FWHashListVC";
        _searchView.delegate = self;
        _searchView.searchText.placeholder = @"搜索话题标签";
        _searchView.clickBtn.hidden = YES;
    }
    return _searchView;
}

- (FWVoiceView*)voiceView
{
    if (_voiceView == nil) {
        _voiceView = [[FWVoiceView alloc] initWithFrame:CGRectZero];
        _voiceView.vctype = @"0";
        _voiceView.backgroundColor = Color_White;
        _voiceView.delegate = self;
    }
    return _voiceView;
}

- (NSMutableArray*)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark - Getters


@end
