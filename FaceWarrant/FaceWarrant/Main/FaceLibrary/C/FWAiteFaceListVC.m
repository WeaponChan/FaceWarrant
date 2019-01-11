//
//  FWAiteFaceListVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWAiteFaceListVC.h"
#import "FWAiteFaceCell.h"
#import "FWFaceLibraryManager.h"
#import "LGUIView.h"
#import "FWAiteFaceModel.h"
@interface FWAiteFaceListVC ()<UITableViewDelegate, UITableViewDataSource,FWAiteFaceCellDelegate>
{
    NSDictionary *_tempDic;
}
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *dataArr;
@property (strong, nonatomic)NSMutableArray *keyArr;
@property (strong, nonatomic)NSMutableArray *commonArr;
@property (strong, nonatomic)NSMutableArray *groupIds;
@property (strong, nonatomic)NSMutableArray *faceIds;
@property (strong, nonatomic)NSMutableArray *groupNames;
@property (strong, nonatomic)NSMutableArray *faceNames;
@property (strong, nonatomic)NSMutableArray *groupModelArr;
@property (strong, nonatomic)NSMutableArray *faceModelArr;
@property (strong, nonatomic)LGUIView *syView;
@property (strong, nonatomic)FWAiteFaceModel *model;
@end

@implementation FWAiteFaceListVC

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
    return self.keyArr.count+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.model.groupsList.count;
    }else{
        self.dataArr = [FWAiteFacesListModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[section-1]]];
        return self.dataArr.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWAiteFaceCell *cell = [FWAiteFaceCell cellWithTableView:tableView] ;
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        if (self.groupModelArr.count == 0) {
            FWAiteGroupsListModel *gmodel = self.commonArr[indexPath.row];
            [cell configCellWithModel:gmodel fmodel:nil indexPath:indexPath];
        }else{
            for (FWAiteGroupsListModel *gmodel in self.groupModelArr) {
                if (gmodel.isSelect == YES && gmodel.indexPath == indexPath) {
                    [cell configCellWithModel:gmodel fmodel:nil indexPath:indexPath];
                    break;
                }else{
                    FWAiteGroupsListModel *gmodel = self.commonArr[indexPath.row];
                    [cell configCellWithModel:gmodel fmodel:nil indexPath:indexPath];
                }
            }
        }
    }else{
        if (self.faceModelArr.count == 0) {
            self.dataArr = [FWAiteFacesListModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section-1]]];
            FWAiteFacesListModel *fmodel = self.dataArr[indexPath.row];
            [cell configCellWithModel:nil fmodel:fmodel indexPath:indexPath];
        }else{
            for (FWAiteFacesListModel *fmodel in self.faceModelArr) {
                if (fmodel.isSelect == YES && fmodel.indexPath == indexPath) {
                    [cell configCellWithModel:nil fmodel:fmodel indexPath:indexPath];
                    break;
                }else{
                    self.dataArr = [FWAiteFacesListModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section-1]]];
                    FWAiteFacesListModel *fmodel = self.dataArr[indexPath.row];
                    [cell configCellWithModel:nil fmodel:fmodel indexPath:indexPath];
                }
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FWAiteFaceCell cellHeight];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 40)];
    view.backgroundColor = Color_MainBg;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Screen_W-10, 40)];
    
    label.textColor = Color_Black;
    label.font = systemFont(14);
    [view addSubview:label];
    if (section == 0) {
        label.text = @"我的群组";
    }else{
        label.text = self.keyArr[section-1];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Custom Delegate
#pragma mark - FWAiteFaceCellDelegate
- (void)FWAiteFaceCellDelegateClick:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FWAiteGroupsListModel *gmodel = self.commonArr[indexPath.row];
        gmodel.indexPath = indexPath;
        if ([gmodel.faceNum isEqualToString:@"0"]) {
            [MBProgressHUD showTips:@"该群组还没有Face额~"];
        }else{
            gmodel.isSelect = !gmodel.isSelect;
            
            if (gmodel.isSelect) {
                [self.groupIds addObject:gmodel.groupsId];
                [self.groupNames addObject:gmodel.groupsName];
                [self.groupModelArr addObject:gmodel];
            }else{
                [self.groupIds removeObject:gmodel.groupsId];
                [self.groupNames removeObject:gmodel.groupsName];
                [self.groupModelArr removeObject:gmodel];
            }
            NSArray *arr = @[indexPath];
            [self.tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }else{
        self.dataArr = [FWAiteFacesListModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section-1]]];
        FWAiteFacesListModel *selectfmodel = self.dataArr[indexPath.row];
        selectfmodel.indexPath = indexPath;
        
        if ([self.faceIds containsObject:selectfmodel.faceId]) {
            selectfmodel.isSelect = NO;
        }else{
            selectfmodel.isSelect = YES;
        }
        if (selectfmodel.isSelect) {
            [self.faceIds addObject:selectfmodel.faceId];
            [self.faceNames addObject:selectfmodel.faceName];
            [self.faceModelArr addObject:selectfmodel];
        }else{
            [self.faceIds removeObject:selectfmodel.faceId];
            [self.faceNames removeObject:selectfmodel.faceName];
//            for (FWAiteFacesListModel *model in self.faceModelArr) {
//                if (model.faceId == selectfmodel.faceId) {
//                    [self.faceModelArr removeObject:model];
//                }
//            }Collection <__NSArrayM: 0x281ca6f70> was mutated while being enumerated.当程序出现这个提示的时候，是因为你一边便利数组，又同时修改这个数组里面的内容，导致崩溃
            
            [self.faceModelArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                FWAiteFacesListModel *model = (FWAiteFacesListModel*)obj;
                if ([model.faceId isEqualToString:selectfmodel.faceId]) {
                    *stop = YES;
                    if (*stop == YES) {
                        [self.faceModelArr removeObject:obj];
                    }
                }
            }];
        }
        NSArray *arr = @[indexPath];
        [self.tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

#pragma mark - Event Response
- (void)sureClick
{
    if (self.groupIds.count == 0 && self.faceIds.count == 0) {
        [MBProgressHUD showTips:@"请选择您要@的人或者群"];
        return;
    }
    if (self.aitefaceblock) {
        self.aitefaceblock(self.groupIds, self.faceIds,self.groupNames,self.faceNames);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - Network Requests

- (void)loadData
{
    if (self.syView) {
        UIView *view = [self.view viewWithTag:123456];
        [view removeFromSuperview];
    }
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID]
                            };
    [FWFaceLibraryManager loadAiteFaceAndGroupsWithParameters:param result:^(FWAiteFaceModel* model) {
        self.model = model;
        self->_tempDic = model.facesList;
        NSArray *tempArr = (NSArray*)self->_tempDic;
        [self.keyArr removeAllObjects];
        [self.dataArr removeAllObjects];
        [self.commonArr removeAllObjects];
        
        self.commonArr  = [FWAiteGroupsListModel mj_objectArrayWithKeyValuesArray:model.groupsList];
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *key in tempArr) {
            [arr addObject:key];
        }
        for (id _obj in [arr sortedArrayUsingSelector:@selector(compare:)]) {
            [self.keyArr addObject:_obj];
        }
        [self.tableView reloadData];
        [self setSYView];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods

- (void)setNav
{
    self.navigationItem.title = @"我的关注";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem js_itemWithTitle:@"确定" target:self action:@selector(sureClick)];
    [self.groupIds removeAllObjects];
    [self.faceIds removeAllObjects];
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
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
}

- (void)setSYView
{
    NSMutableArray *tempArr = [NSMutableArray array];
    [tempArr removeAllObjects];
    [tempArr addObjectsFromArray:self.keyArr];
    [tempArr insertObject:@"↑" atIndex:0];
    self.syView = [[LGUIView alloc] initWithFrame:CGRectMake(Screen_W-40, (Screen_H-15*tempArr.count + 80)/2, 40, 15*tempArr.count) indexArray:tempArr];
    self.syView.tag = 123456;
    [self.view addSubview:self.syView];
    
    [self.syView selectIndexBlock:^(NSInteger section)
     {
         [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                                     animated:NO
                               scrollPosition:UITableViewScrollPositionTop];
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

- (NSMutableArray*)commonArr
{
    if (_commonArr == nil) {
        _commonArr = [NSMutableArray array];
    }
    return _commonArr;
}

- (NSMutableArray*)groupIds
{
    if (_groupIds == nil) {
        _groupIds = [NSMutableArray array];
    }
    return _groupIds;
}

- (NSMutableArray*)faceIds
{
    if (_faceIds == nil) {
        _faceIds = [NSMutableArray array];
    }
    return _faceIds;
}

- (NSMutableArray*)groupNames
{
    if (_groupNames == nil) {
        _groupNames = [NSMutableArray array];
    }
    return _groupNames;
}

- (NSMutableArray*)faceNames
{
    if (_faceNames == nil) {
        _faceNames = [NSMutableArray array];
    }
    return _faceNames;
}

- (NSMutableArray*)groupModelArr
{
    if (_groupModelArr == nil) {
        _groupModelArr = [NSMutableArray array];
    }
    return _groupModelArr;
}

- (NSMutableArray*)faceModelArr
{
    if (_faceModelArr == nil) {
        _faceModelArr = [NSMutableArray array];
    }
    return _faceModelArr;
}

#pragma mark - Getters


@end
