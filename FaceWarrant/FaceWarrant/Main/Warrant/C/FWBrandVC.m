//
//  FWBrandVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBrandVC.h"
#import "FWGoodsBrandCell.h"
#import "LGUIView.h"
#import "FWBrandModel.h"
#import "FWBrandBigClassModel.h"
#import "FWBrandSmallClassModel.h"
#import "FWBrandGoodsModel.h"
#import "FWBrandDetailVC.h"
#import "FWSearchView.h"
#import "FWVoiceView.h"
#import "FWWarrantManager.h"
#import "FWHomeManager.h"
@interface FWBrandVC ()<UITableViewDelegate, UITableViewDataSource,FWSearchViewDelegate,FWVoiceViewDelegate>
{
    NSDictionary *_tempDic;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *keyArr;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) LGUIView *syView;
@property (strong, nonatomic) FWSearchView *searchView;
@property (strong, nonatomic) FWVoiceView *voiceView;

@end

@implementation FWBrandVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setTableView];
    [self setSubView];
    
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
    if ([self.vcType isEqualToString:@"FWWarrantInfoVC"]) {
        self.dataArr = [FWBrandModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[section+1]]];
    }else if ([self.vcType isEqualToString:@"1"]) {
        self.dataArr = [FWBrandBigClassModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[section+1]]];
    }else if ([self.vcType isEqualToString:@"2"]) {
        self.dataArr = [FWBrandSmallClassModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[section+1]]];
    }else if ([self.vcType isEqualToString:@"3"]) {
        self.dataArr = [FWBrandGoodsModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[section+1]]];
    }else{
        self.dataArr = [FWBrandModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[section+1]]];
    }
    
    return self.dataArr.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWGoodsBrandCell *cell = [FWGoodsBrandCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([self.vcType isEqualToString:@"FWWarrantInfoVC"]) {
        self.dataArr = [FWBrandModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
        FWBrandModel *model = self.dataArr[indexPath.row];
        [cell configCellWithName:model.brandName indexPath:indexPath];
    }else if ([self.vcType isEqualToString:@"1"]) {
        self.dataArr = [FWBrandBigClassModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
        FWBrandBigClassModel *model = self.dataArr[indexPath.row];
         [cell configCellWithName:model.btypeName indexPath:indexPath];
    }else if ([self.vcType isEqualToString:@"2"]) {
        self.dataArr = [FWBrandSmallClassModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
        FWBrandSmallClassModel *model = self.dataArr[indexPath.row];
         [cell configCellWithName:model.stypeName indexPath:indexPath];
    }else if ([self.vcType isEqualToString:@"3"]) {
        self.dataArr = [FWBrandGoodsModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
        FWBrandGoodsModel *model = self.dataArr[indexPath.row];
         [cell configCellWithName:model.goodName indexPath:indexPath];
    }else{
        self.dataArr = [FWBrandModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
        FWBrandModel *model = self.dataArr[indexPath.row];
        [cell configCellWithName:model.brandName indexPath:indexPath];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FWGoodsBrandCell cellHeight];
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
    if ([self.vcType isEqualToString:@"FWWarrantInfoVC"]) {
        self.dataArr = [FWBrandModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
        FWBrandModel *model = self.dataArr[indexPath.row];
        if (self.block) {
            self.block(model.brandName, model.brandId);
        }
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if ([self.vcType isEqualToString:@"1"]) {
        self.dataArr = [FWBrandBigClassModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
        FWBrandBigClassModel *model = self.dataArr[indexPath.row];
        if (self.block) {
            self.block(model.btypeName, model.btypeId);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([self.vcType isEqualToString:@"2"]) {
        self.dataArr = [FWBrandSmallClassModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
        FWBrandSmallClassModel *model = self.dataArr[indexPath.row];
        if (self.block) {
            self.block(model.stypeName, model.stypeId);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else if ([self.vcType isEqualToString:@"3"]) {
        self.dataArr = [FWBrandGoodsModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
        FWBrandGoodsModel *model = self.dataArr[indexPath.row];
        if (self.block) {
            self.block(model.goodName, model.goodsId);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        self.dataArr = [FWBrandModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
        FWBrandModel *model = self.dataArr[indexPath.row];
        FWBrandDetailVC *vc = [FWBrandDetailVC new];
        vc.brandId = model.brandId;
        vc.faceId = self.faceId;
        vc.searchCondition = self.searchCondition;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing: YES];
    self.voiceView.hidden = YES;
}

#pragma mark - Custom Delegate
#pragma mark - FWSearchViewDelegate
- (void)FWSearchViewDelegateWithText:(NSString *)text
{
    DLog(@"----text==%@",text);
    [self loadAllBrand:text];
}

- (void)FWSearchViewDelegateVoiceClick
{
    [self.searchView.searchText resignFirstResponder];
    self.voiceView.hidden = NO;
}

- (void)FWSearchViewDelegateWithTextViewBeginEditing
{
    self.voiceView.hidden = YES;
}

#pragma mark - FWVoiceViewDelegate
- (void)FWVoiceViewDelegateWithText:(NSString *)text
{
    self.searchView.searchText.text = text;
    self.voiceView.hidden = YES;
    [self loadAllBrand:text];
}

#pragma mark - Event Response


#pragma mark - Network Requests
- (void)loadData:(NSString*)searchCondition
{
    NSDictionary *param = @{
                            @"faceId":self.faceId,
                            @"searchCondition":searchCondition?:@""
                            };
    [FWHomeManager loadGoodsBrandWithParameters:param result:^(id response) {
        
        self->_tempDic = response[@"result"];
        NSArray *tempArr = response[@"result"];
        if (tempArr.count == 0) {
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoSearchResult toView:self.tableView];
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.tableView];
        }
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
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadAllBrand:(NSString*)searchCondition
{
    if (self.syView) {
        UIView *view = [self.view viewWithTag:100008];
        [view removeFromSuperview];
    }
    
    NSDictionary *param = @{
                            @"searchCondition":searchCondition
                            };
    [FWWarrantManager loadAllBrandListWithParameters:param result:^(id response) {
        self->_tempDic = response[@"result"];
        NSArray *tempArr = response[@"result"];
        if (tempArr.count == 0) {
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoSearchResult toView:self.tableView];
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.tableView];
        }
        
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
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadBrandBigClass
{
    NSDictionary *param = @{
                            @"flag":@"0",
                            @"brandId":self.brandId
                            };
    [FWWarrantManager loadBrandBigClassListWithParameters:param result:^(id response) {
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
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadBrandsmallClass
{
    NSDictionary *param = @{
                            @"flag":@"1",
                            @"brandId":self.brandId,
                            @"btypeId":self.bigClassId
                            };
    [FWWarrantManager loadBrandSmallClassListWithParameters:param result:^(id response) {
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
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadBrandgoodsClass
{
    NSDictionary *param = @{
                            @"flag":@"2",
                            @"brandId":self.brandId,
                            @"btypeId":self.bigClassId,
                            @"stypeId":self.smallClassId
                            };
    [FWWarrantManager loadBrandGoodsListWithParameters:param result:^(id response) {
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
        [self.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.title = @"全部品牌";
    if ([self.vcType isEqualToString:@"FWWarrantInfoVC"]) {
        [self.view addSubview:self.searchView];
    }
    if ([self.vcType isEqualToString:@"FWWarrantInfoVC"]) {
        [self loadAllBrand:@""];
    }else if ([self.vcType isEqualToString:@"1"]) {
        [self loadBrandBigClass];
    }else if ([self.vcType isEqualToString:@"2"]) {
        [self loadBrandsmallClass];
    }else if ([self.vcType isEqualToString:@"3"]) {
        [self loadBrandgoodsClass];
    }else{
        [self loadData:@""];
    }
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
        if ([self.vcType isEqualToString:@"FWWarrantInfoVC"]) {
            make.top.mas_equalTo(self.view).offset(NavigationBar_H+50);
        }else{
            make.top.mas_equalTo(self.view);
        }
        make.bottom.mas_equalTo(self.view);
    }];
    
//    LhkhWeakSelf(self);
//    self.tableView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
//
//    }];
//    [self.tableView.mj_header beginRefreshing];
}

- (void)setSYView
{
    self.syView = [[LGUIView alloc] initWithFrame:CGRectMake(Screen_W-40, (Screen_H-15*(self.keyArr.count+1))/2, 40, 15*(self.keyArr.count+1)) indexArray:self.keyArr];
    self.syView.tag = 100008;
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

- (void)setSubView
{
    self.voiceView.hidden = YES;
    [self.view addSubview:self.voiceView];
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(200);
        make.left.right.bottom.equalTo(self.view);
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

- (FWSearchView*)searchView
{
    if (_searchView == nil) {
        _searchView = [[FWSearchView alloc] initWithFrame:CGRectMake(10, NavigationBar_H+10, Screen_W-20, 30)];
        _searchView.delegate = self;
        _searchView.vcStr = @"FWBrandVC";
        _searchView.searchText.placeholder = @"请输入品牌名称";
        _searchView.clickBtn.hidden = YES;
        
    }
    return _searchView;
}

- (FWVoiceView*)voiceView
{
    if (_voiceView == nil) {
        _voiceView = [[FWVoiceView alloc] initWithFrame:CGRectMake(0, Screen_H-300, Screen_W, 300)];
        _voiceView.backgroundColor = Color_MainBg;
        _voiceView.delegate = self;
        _voiceView.vctype = @"0";
    }
    return _voiceView;
}

#pragma mark - Getters


@end
