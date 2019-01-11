//
//  FWWithdrawCashNoteVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWithdrawCashNoteVC.h"
#import "FWTXNoteCell.h"
#import "FWMeManager.h"
#import "FWFaceValueNoteModel.h"
#import "FWFaceValueCashDetailVC.h"
@interface FWWithdrawCashNoteVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;

@end
static int page = 1;
@implementation FWWithdrawCashNoteVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setTableView];
    [self loadData];
}


#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码


#pragma mark - System Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FWFaceValueNoteModel *model = self.dataList[section];
    return model.accountExpendList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWFaceValueNoteModel *model = self.dataList[indexPath.section];
    FWTXNoteCell *cell = [FWTXNoteCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithModel:model indexPath:indexPath];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FWTXNoteCell cellHeight];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FWFaceValueNoteModel *model = self.dataList[section];
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 44)];
    headView.backgroundColor = Color_MainBg;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, Screen_W-20, 34)];
    label.text = model.dateYearMonth;
    label.font = systemFont(14);
    label.textColor = Color_SubText;
    [headView addSubview:label];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWFaceValueNoteModel *model = self.dataList[indexPath.section];
    FWAccountExpendListModel *mModel = [FWAccountExpendListModel mj_objectWithKeyValues:model.accountExpendList[indexPath.row]];
    FWFaceValueCashDetailVC *vc = [FWFaceValueCashDetailVC new];
    vc.vcType = @"FWWithdrawCashNoteVC";
    vc.accountExpend = mModel.accountExpend;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Custom Delegate


#pragma mark - Event Response


#pragma mark - Network Requests
- (void)loadData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"page":@"1",
                            @"rows":pageSize
                            };
    [FWMeManager loadFaceValueCashNoteWithParameters:param result:^(NSArray <FWFaceValueNoteModel*> *model) {
        [self.tableView.mj_footer setState:MJRefreshStateIdle];
        [self.dataList removeAllObjects];
        [self.dataList addObjectsFromArray:model];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (model.count == 0) {
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.tableView];
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.tableView];
        }
        if (model.count < pageSize.floatValue) {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        page = 1;
    }];
}

- (void)loadMoreData
{
    page ++;
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":pageSize
                            };
    [FWMeManager loadFaceValueCashNoteWithParameters:param result:^(NSArray <FWFaceValueNoteModel*> *model) {
        [self.dataList addObjectsFromArray:model];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (model.count < pageSize.floatValue) {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.title = @"提现记录";
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
        if (iOS11Later) {
            make.top.mas_equalTo(self.view).offset(NavigationBar_H);
        }else{
            make.top.mas_equalTo(self.view);
        }
        make.bottom.mas_equalTo(self.view);
    }];
    LhkhWeakSelf(self);
    self.tableView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    
    self.tableView.mj_footer = [RefreshCatGifFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
}

#pragma mark - Setters

- (NSMutableArray*)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

#pragma mark - Getters


@end
