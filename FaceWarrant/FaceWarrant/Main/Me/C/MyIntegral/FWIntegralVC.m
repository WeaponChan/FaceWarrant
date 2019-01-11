//
//  FWIntegralVC.m
//  FaceWarrant
//
//  Created by LHKH on 2018/7/2.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWIntegralVC.h"
#import "FWIntgralHeaderCell.h"
#import "FWIntegralCell.h"
#import "FWIntegralConversionVC.h"
#import "FWMeManager.h"
#import "FWIntegralModel.h"
@interface FWIntegralVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UILabel *integralLab;
@property (strong, nonatomic) FWIntegralModel *model;
@property (strong, nonatomic) NSMutableArray *integralList;

@end
static int page = 1;
@implementation FWIntegralVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setNav];
    [self setTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码


#pragma mark - System Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    return self.integralList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FWIntgralHeaderCell *cell = [FWIntgralHeaderCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithModel:self.model indexPath:indexPath];
        return cell;
    }else{
        FWIntegralCell *cell = [FWIntegralCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        FWPointsDetailListModel *model = self.integralList[indexPath.row];
        [cell configCellWithModel:model indexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [FWIntgralHeaderCell cellHeight];
    }
    return [FWIntegralCell cellHeight];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else{
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 44)];
        headView.backgroundColor = Color_MainBg;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, Screen_W-20, 34)];
        label.text = @"积分明细";
        label.font = systemFont(14);
        label.textColor = Color_SubText;
        [headView addSubview:label];
        return headView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}


#pragma mark - Custom Delegate




#pragma mark - Event Response

//- (void)integralDetailClick
//{
//
//}

- (void)duihuanClick
{

    [self.navigationController pushViewController:[FWIntegralConversionVC new] animated:NO];
}

#pragma mark - Network requests

- (void)loadData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"page":@"1",
                            @"rows":pageSize
                            };
    [FWMeManager loadIntegralListWithParameters:param result:^(FWIntegralModel *model, NSArray <FWPointsDetailListModel *> *mModel) {
        self.model = model;
        [self.integralList removeAllObjects];
        [self.integralList addObjectsFromArray:mModel];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (mModel.count<pageSize.floatValue) {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        page = 1;
    }];
}

- (void)loadMoreData
{
    page++;
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":pageSize
                            };
    [FWMeManager loadIntegralListWithParameters:param result:^(FWIntegralModel *model, NSArray <FWPointsDetailListModel *> *mModel) {
        self.model = model;
        [self.integralList addObjectsFromArray:mModel];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        if (mModel.count<pageSize.floatValue) {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
    }];
}

#pragma mark - Public Methods




#pragma mark - Private Methods

//- (void)setNav
//{
//    self.navigationItem.title = @"我的积分";
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem js_itemWithTitle:@"积分规则" target:self action:@selector(integralDetailClick)];
//}

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
        make.top.mas_equalTo(self.view).offset(-StatusBar_H);
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
- (NSMutableArray*)integralList
{
    if (_integralList == nil) {
        _integralList = [NSMutableArray array];
    }
    return _integralList;
}


#pragma mark - Getters




@end
