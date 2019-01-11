//
//  FWAttentionVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWAttentionVC.h"
#import "FWAttentionCell.h"
#import "FWMeManager.h"
#import "FWAttentionModel.h"
#import "LGUIView.h"
#import "FWPersonalHomePageVC.h"
@interface FWAttentionVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSDictionary *_tempDic;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *keyArr;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) LGUIView *syView;
@end

@implementation FWAttentionVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setTableView];

}


#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码


#pragma mark - System Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.keyArr.count-1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    self.dataArr = [FWAttentionModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[section+1]]];
    return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.dataArr = [FWAttentionModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
    FWAttentionModel *model = self.dataArr[indexPath.row];
    FWAttentionCell *cell = [FWAttentionCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithModel:model cmodel:nil rmodel:nil indexPath:indexPath type:@"FWAttentionVC" tag:@""];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 40)];
    view.backgroundColor = Color_MainBg;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Screen_W-10, 40)];
    label.text = self.keyArr[section+1];
    label.textColor = Color_Black;
    label.font = systemFont(14);
    [view addSubview:label];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.dataArr = [FWAttentionModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
    FWAttentionModel *model = self.dataArr[indexPath.row];
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.faceId = model.faceId;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - Custom Delegate




#pragma mark - Event Response




#pragma mark - Network requests

- (void)loadData
{
    if (self.syView) {
        UIView *view = [self.view viewWithTag:40000];
        [view removeFromSuperview];
    }
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID]
                            };
    [FWMeManager loadAttentionListWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            if ([response[@"result"] count] == 0) {
                [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoAttention toView:self.tableView];
            }else{
                [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView: self.tableView];
                self->_tempDic = response[@"result"];
                NSArray *tempArr = response[@"result"];
                [self.keyArr removeAllObjects];
                [self.dataArr removeAllObjects];
                
                NSMutableArray *arr = [NSMutableArray array];
                for (NSString *key in tempArr) {
                    [arr addObject:key];
                }
                for (id _obj in [arr sortedArrayUsingSelector:@selector(compare:)]) {
                    [self.keyArr addObject:_obj];
                }
                [self.keyArr insertObject:@"↑" atIndex:0];
                [self.tableView reloadData];
                [self setSYView];
            }
        }
        [self.tableView.mj_header endRefreshing];
    }];
}


#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setNav
{
    self.navigationItem.title = self.vcTitle;
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
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    LhkhWeakSelf(self);
    self.tableView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setSYView
{
    self.syView = [[LGUIView alloc] initWithFrame:CGRectMake(Screen_W-40, (Screen_H-15*(self.keyArr.count+1))/2, 40, 15*(self.keyArr.count+1)) indexArray:self.keyArr];
    self.syView.tag = 40000;
    [self.view addSubview:self.syView];
    
    [self.syView selectIndexBlock:^(NSInteger section)
     {
         if (section == 0) {
             [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                                         animated:NO
                                   scrollPosition:UITableViewScrollPositionTop];
         }else{
             [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section-1]
                                         animated:NO
                                   scrollPosition:UITableViewScrollPositionTop];
         }
     }];
}

#pragma mark - Setters

- (NSMutableArray*)keyArr
{
    if (_keyArr == nil) {
        _keyArr = [NSMutableArray array];
    }
    return _keyArr;
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
