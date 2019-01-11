//
//  FWAddAttentionMoreVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/11.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWAddAttentionMoreVC.h"
#import "FWAddAttenMoreCell.h"
#import "FWSearchView.h"
#import "FWFaceLibraryManager.h"
#import "FWAddMoreFaceModel.h"
#import "FWContactModel.h"
#import "LGUIView.h"
@interface FWAddAttentionMoreVC ()<FWSearchViewDelegate,UITableViewDelegate,UITableViewDataSource,FWAddAttenMoreCellDelegate>
{
    NSString *_dataType;//0 表示搜索数据   1表示更多数据
    NSDictionary *_tempDic;
    BOOL _isAdd;
    BOOL _isInvite;
    NSIndexPath *_selectIndexPath;
}
@property (strong, nonatomic) FWSearchView *searchView;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *searchList;
@property (strong, nonatomic) NSMutableArray *keyArr;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *selectModelArr;
@property (strong, nonatomic) LGUIView *syView;
@end

@implementation FWAddAttentionMoreVC

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
    if ([self.type isEqualToString:@"0"] || [_dataType isEqualToString:@"0"]) {
        return 1;
    }else{
        return self.keyArr.count-1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.type isEqualToString:@"0"] || [_dataType isEqualToString:@"0"]) {
        return self.searchList.count;
    }else{
        self.dataArr = [FWAddMoreFaceModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[section+1]]];
        return self.dataArr.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWAddAttenMoreCell *cell = [FWAddAttenMoreCell cellWithTableView:tableView];
    cell.delegate = self;
    if ([self.type isEqualToString:@"0"] || [_dataType isEqualToString:@"0"]) {
        if ([self.moreType isEqualToString:@"2"]) {
            if (self.selectModelArr.count == 0) {
                FWContactModel *model = self.searchList[indexPath.row];
                [cell configCellWithModel:nil cmodel:model type:self.moreType indexPath:indexPath];
            }else{
                for (FWContactModel *cmodel in self.selectModelArr) {
                    if (cmodel.isAdd == YES && cmodel.indexPath == indexPath && [cmodel.isRegistered isEqualToString:@"1"]) {
                        [cell configCellWithModel:nil cmodel:cmodel type:self.moreType indexPath:indexPath];
                        break;
                    }else if (cmodel.isInvited == YES && cmodel.indexPath == indexPath){
                        [cell configCellWithModel:nil cmodel:cmodel type:self.moreType indexPath:indexPath];
                        break;
                    }else{
                        FWContactModel *model = self.searchList[indexPath.row];
                        [cell configCellWithModel:nil cmodel:model type:self.moreType indexPath:indexPath];
                    }
                }
            }
//            FWContactModel *model = self.searchList[indexPath.row];
//            if (_isInvite == YES && indexPath == _selectIndexPath) {
//                _isInvite = NO;
//                model.isInvited = YES;
//            }
//            if (_isAdd == YES && indexPath == _selectIndexPath && [model.isRegistered isEqualToString:@"1"]) {
//                _isAdd = NO;
//                model.isInvited = YES;
//            }
//            [cell configCellWithModel:nil cmodel:model type:self.moreType indexPath:indexPath];
            
        }else{
            
            if (self.selectModelArr.count == 0) {
                FWAddMoreFaceModel *model = self.searchList[indexPath.row];
                [cell configCellWithModel:model cmodel:nil type:self.moreType indexPath:indexPath];
            }else{
                for (FWAddMoreFaceModel *fmodel in self.selectModelArr) {
                    if (fmodel.isAdd == YES && fmodel.indexPath == indexPath) {
                        [cell configCellWithModel:fmodel cmodel:nil type:self.moreType indexPath:indexPath];
                        break;
                    }else{
                        FWAddMoreFaceModel *model = self.searchList[indexPath.row];
                        [cell configCellWithModel:model cmodel:nil type:self.moreType indexPath:indexPath];
                    }
                }
            }
            
//            FWAddMoreFaceModel *model = self.searchList[indexPath.row];
//            if (_isAdd == YES && indexPath == _selectIndexPath) {
//                _isAdd = NO;
//                model.isAdd = YES;
//            }
//            [cell configCellWithModel:model cmodel:nil type:self.moreType indexPath:indexPath];
        }
    }else{
        if ([self.moreType isEqualToString:@"2"]) {
            if (self.selectModelArr.count == 0) {
                self.dataArr = [FWContactModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
                FWContactModel *model = self.dataArr[indexPath.row];
                [cell configCellWithModel:nil cmodel:model type:self.moreType indexPath:indexPath];
            }else{
                for (FWContactModel *cmodel in self.selectModelArr) {
                    if (cmodel.isAdd == YES && cmodel.indexPath == indexPath && [cmodel.isRegistered isEqualToString:@"1"]) {
                        [cell configCellWithModel:nil cmodel:cmodel type:self.moreType indexPath:indexPath];
                        break;
                    }else if (cmodel.isInvited == YES && cmodel.indexPath == indexPath){
                        [cell configCellWithModel:nil cmodel:cmodel type:self.moreType indexPath:indexPath];
                        break;
                    }else{
                        self.dataArr = [FWContactModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
                        FWContactModel *model = self.dataArr[indexPath.row];
                        [cell configCellWithModel:nil cmodel:model type:self.moreType indexPath:indexPath];
                    }
                }
            }
            
            
//            self.dataArr = [FWContactModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
//            FWContactModel *model = self.dataArr[indexPath.row];
//            if (_isInvite == YES && indexPath == _selectIndexPath) {
//                _isInvite = NO;
//                model.isInvited = YES;
//            }
//            if (_isAdd == YES && indexPath == _selectIndexPath && [model.isRegistered isEqualToString:@"1"]) {
//                _isAdd = NO;
//                model.isInvited = YES;
//            }
//            [cell configCellWithModel:nil cmodel:model type:self.moreType indexPath:indexPath];
        }else{
            
            
            if (self.selectModelArr.count == 0) {
                self.dataArr = [FWAddMoreFaceModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
                FWAddMoreFaceModel *model = self.dataArr[indexPath.row];
                [cell configCellWithModel:model cmodel:nil type:self.moreType indexPath:indexPath];
            }else{
                for (FWAddMoreFaceModel *fmodel in self.selectModelArr) {
                    if (fmodel.isAdd == YES && fmodel.indexPath == indexPath) {
                        [cell configCellWithModel:fmodel cmodel:nil type:self.moreType indexPath:indexPath];
                        break;
                    }else{
                        self.dataArr = [FWAddMoreFaceModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
                        FWAddMoreFaceModel *model = self.dataArr[indexPath.row];
                        [cell configCellWithModel:model cmodel:nil type:self.moreType indexPath:indexPath];
                    }
                }
            }
            
//            self.dataArr = [FWAddMoreFaceModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
//            FWAddMoreFaceModel *model = self.dataArr[indexPath.row];
//            if (_isAdd == YES && indexPath == _selectIndexPath) {
//                _isAdd = NO;
//                model.isAdd = YES;
//            }
//            [cell configCellWithModel:model cmodel:nil type:self.moreType indexPath:indexPath];
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.type isEqualToString:@"0"]  || [_dataType isEqualToString:@"0"]) {
        return [UIView new];
    }else{
        UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 40)];
        view.backgroundColor = Color_MainBg;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Screen_W-10, 40)];
        label.text = self.keyArr[section+1];
        label.textColor = Color_Black;
        label.font = systemFont(14);
        [view addSubview:label];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.type isEqualToString:@"0"]  || [_dataType isEqualToString:@"0"]) {
        return 10;
    }else{
        return 40;
    }
}

#pragma mark - Custom Delegate
#pragma mark - FWSearchViewDelegate
- (void)FWSearchViewDelegateWithText:(NSString *)text
{
    if (text == nil || [text isEqualToString:@""] || text.length == 0) {
//        _dataType = @"1";
//        self.type = @"1";
//        [self.tableView.mj_header beginRefreshing];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showKeyboard" object:nil userInfo:@{@"type":@"0"}];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        _dataType = @"0";
        UIView *view = [self.view viewWithTag:10000];
        [view removeFromSuperview];
        [self loadSearchData:text];
    }
    [self.view endEditing:YES];
}

- (void)FWSearchViewDelegateVoiceClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showKeyboard" object:nil userInfo:@{@"type":@"1"}];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - FWAddAttenMoreCellDelegate

- (void)FWAddAttenMoreCellDelegateInviteClick:(FWContactModel *)cmodel indexPath:(NSIndexPath *)indexPath
{
    [self inviteFace:cmodel indexPath:indexPath];
}

- (void)FWAddAttenMoreCellDelegateAddClick:(FWAddMoreFaceModel *)fmodel cmodel:(FWContactModel *)cmodel indexPath:(NSIndexPath *)indexPath
{
    [self addAttention:fmodel cmodel:cmodel indexPath:indexPath];
}



//- (void)FWAddAttenMoreCellDelegateInviteClick:(NSString *)phoneNum countryCode:(NSString *)code indexPath:(NSIndexPath *)indexPath
//{
//    [self inviteFace:phoneNum code:code indexPath:indexPath];
//}
//
//- (void)FWAddAttenMoreCellDelegateAddClick:(NSString *)faceId indexPath:(NSIndexPath *)indexPath
//{
//    [self addAttention:faceId indexPath:indexPath];
//}

#pragma mark - Event Response


#pragma mark - Network Requests

- (void)loadData
{
    if (self.syView) {
        UIView *view = [self.view viewWithTag:10000];
        [view removeFromSuperview];
    }
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"groupsId":self.model.groupsId,
                            @"groupsType":self.model.groupsType,
                            @"requestType":@"1",
                            @"phoneInfo":self.contactStr?:@"",
                            @"moreType":self.moreType?:@"",
                            @"isoCode":[USER_DEFAULTS objectForKey:UD_ISO]?:@""
                            };
    [FWFaceLibraryManager loadFaceHomeOtherFaceWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            self->_tempDic = response[@"result"];
            NSArray *tempArr = response[@"result"];
            [self.keyArr removeAllObjects];
            [self.dataArr removeAllObjects];
            [self.selectModelArr removeAllObjects];
            
            NSMutableArray *arr = [NSMutableArray array];
            for (NSString *key in tempArr) {
                [arr addObject:key];
            }
            for (id _obj in [arr sortedArrayUsingSelector:@selector(compare:)]) {
                [self.keyArr addObject:_obj];
            }
            [self.keyArr insertObject:@"↑" atIndex:0];
            [self.tableView reloadData];
            
            if (tempArr.count == 0) {
                [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.tableView];
            }else{
                [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.tableView];
                [self setSYView];
            }
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.tableView];
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadSearchData:(NSString*)searchStr
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"groupsId":self.model.groupsId,
                            @"groupsType":self.model.groupsType,
                            @"searchCondition":searchStr,
                            @"searchType":self.searchType,
                            @"phoneInfo":self.contactStr?:@"",
                            @"isoCode":[USER_DEFAULTS objectForKey:UD_ISO]?:@""
                            };
    [FWFaceLibraryManager loadSearchFaceWithParameters:param result:^(id response) {
        if (response[@"result"] && response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self.searchList removeAllObjects];
            [self.selectModelArr removeAllObjects];
            if ([self.type isEqualToString:@"0"]) {
                self.searchList = [FWContactModel mj_objectArrayWithKeyValuesArray:response[@"result"]];
            }else{
                if ([self.moreType isEqualToString:@"2"]) {
                    self.searchList = [FWContactModel mj_objectArrayWithKeyValuesArray:response[@"result"]];
                }else{
                    self.searchList = [FWAddMoreFaceModel mj_objectArrayWithKeyValuesArray:response[@"result"]];
                }
            }
            
            [self.tableView reloadData];
            if (self.searchList.count == 0) {
                [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.tableView];
            }else{
                [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.tableView];
            }
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.tableView];
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)addAttention:(FWAddMoreFaceModel*)fmodel cmodel:(FWContactModel*)cmodel indexPath:(NSIndexPath *)indexPath
{
    NSString *faceId = @"";
    if (fmodel) {
        faceId = fmodel.faceId;
    }else if(cmodel){
        faceId = cmodel.faceId;
    }
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"groupsId":self.model.groupsId,
                            @"groupsType":self.model.groupsType,
                            @"faceId":faceId
                            };
    [FWFaceLibraryManager addFaceToGroupWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [USER_DEFAULTS setObject:@"1" forKey:UD_FaceLibraryChange];
            [MBProgressHUD showSuccess:response[@"resultDesc"]];
//            self->_isAdd = YES;
//            self->_selectIndexPath = indexPath;
            
            if (fmodel) {
                fmodel.isAdd = YES;
                fmodel.indexPath = indexPath;
                [self.selectModelArr addObject:fmodel];
            }else if(cmodel){
                cmodel.isAdd = YES;
                cmodel.indexPath = indexPath;
                [self.selectModelArr addObject:cmodel];
            }
            NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}


- (void)inviteFace:(FWContactModel*)cmodel indexPath:(NSIndexPath *)indexPath
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"contactPhone":cmodel.mobile,
                            @"countryCode":cmodel.countryCode
                            };
    [FWFaceLibraryManager inviteFaceToGroupWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [MBProgressHUD showSuccess:response[@"resultDesc"]];
//            self->_isInvite = YES;
//            self->_selectIndexPath = indexPath;
            cmodel.isInvited = YES;
            cmodel.indexPath = indexPath;
            [self.selectModelArr addObject:cmodel];
            NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

//- (void)addAttention:(NSString*)faceId indexPath:(NSIndexPath *)indexPath
//{
//
//    NSDictionary *param = @{
//                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
//                            @"groupsId":self.model.groupsId,
//                            @"groupsType":self.model.groupsType,
//                            @"faceId":faceId
//                            };
//    [FWFaceLibraryManager addFaceToGroupWithParameters:param result:^(id response) {
//        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
//            [MBProgressHUD showSuccess:response[@"resultDesc"]];
//            self->_isAdd = YES;
//            self->_selectIndexPath = indexPath;
//            NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
//            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
//        }else{
//            [MBProgressHUD showError:response[@"resultDesc"]];
//        }
//    }];
//}


//- (void)inviteFace:(NSString*)phone code:(NSString*)code indexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *param = @{
//                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
//                            @"contactPhone":phone,
//                            @"countryCode":code
//                            };
//    [FWFaceLibraryManager inviteFaceToGroupWithParameters:param result:^(id response) {
//        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
//            [MBProgressHUD showSuccess:response[@"resultDesc"]];
//            self->_isInvite = YES;
//            self->_selectIndexPath = indexPath;
//            NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
//            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
//        }else{
//            [MBProgressHUD showError:response[@"resultDesc"]];
//        }
//    }];
//}

#pragma mark - Public Methods


#pragma mark - Private Methods

- (void)setNav
{
    self.navigationItem.title = @"添加Face";
    [self.view addSubview:self.searchView];
    _isAdd = NO;
    _isInvite = NO;
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
        make.top.mas_equalTo(self.view).offset(NavigationBar_H+50);
        make.bottom.mas_equalTo(self.view);
    }];
    
    LhkhWeakSelf(self);
    self.tableView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        if ([self.type isEqualToString:@"0"]) {
            [self loadSearchData:self.searchText];
        }else{
            self->_dataType = @"1";
            self.searchView.searchText.text = @"";
            [weakself loadData];
        }
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setSYView
{
    self.syView = [[LGUIView alloc] initWithFrame:CGRectMake(Screen_W-20, (Screen_H-15*(self.keyArr.count+1))/2, 20, 15*(self.keyArr.count+1)) indexArray:self.keyArr];
    self.syView.tag = 10000;
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

- (FWSearchView*)searchView
{
    if (_searchView == nil) {
        _searchView = [[FWSearchView alloc] initWithFrame:CGRectMake(10, NavigationBar_H+10, Screen_W-20, 30)];
        _searchView.vcStr = @"FWAddAttentionVC";
        _searchView.delegate = self;
        _searchView.searchText.placeholder = @"请输入Face名称";
        _searchView.searchText.text = self.searchText;
        
        _searchView.clickBtn.hidden = YES;
        
    }
    return _searchView;
}

- (NSMutableArray*)searchList
{
    if (_searchList == nil) {
        _searchList = [NSMutableArray array];
    }
    return _searchList;
}

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


- (NSMutableArray*)selectModelArr
{
    if (_selectModelArr == nil) {
        _selectModelArr = [NSMutableArray array];
    }
    return _selectModelArr;
}

#pragma mark - Getters


@end
