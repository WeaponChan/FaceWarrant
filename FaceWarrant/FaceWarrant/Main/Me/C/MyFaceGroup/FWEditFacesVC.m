//
//  FWEditFacesVC.m
//  FaceWarrant
//
//  Created by FW on 2018/8/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWEditFacesVC.h"
#import "FWEditFacesCell.h"
#import "FWMeManager.h"
#import "FWAttentionModel.h"
#import "LGUIView.h"

@interface FWEditFacesVC ()<UITableViewDelegate,UITableViewDataSource,FWEditFacesCellDelegate>
{
    NSDictionary *_tempDic;
}
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)UIView *groupView;
@property (strong, nonatomic)UILabel *groupLab;
@property (strong, nonatomic)LhkhTextField *groupText;
@property (strong, nonatomic) NSMutableArray *keyArr;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) NSMutableArray *deleteArr;
@property (strong, nonatomic) NSMutableArray *deleteModelArr;
@property (strong, nonatomic) LGUIView *syView;
@end

@implementation FWEditFacesVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    if ([self.type isEqualToString:@"1"]) {
        [self setSubView];
    }else{
        [self setTableView];
        [self loadData];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    FWEditFacesCell *cell = [FWEditFacesCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.deleteModelArr.count == 0) {
        self.dataArr = [FWAttentionModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
        FWAttentionModel *model = self.dataArr[indexPath.row];
        [cell configCellWithModel:model indexPath:indexPath];
    }else{
        for (FWAttentionModel *model in self.deleteModelArr) {
            if (model.isSelect == YES && model.indexPath == indexPath) {
                [cell configCellWithModel:model indexPath:indexPath];
                break;
            }else{
                self.dataArr = [FWAttentionModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
                FWAttentionModel *model = self.dataArr[indexPath.row];
                [cell configCellWithModel:model indexPath:indexPath];
            }
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FWEditFacesCell cellHeight];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    FWEditFacesCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    [cell selectAction];
//    self.dataArr = [FWAttentionModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
//    FWAttentionModel *model = self.dataArr[indexPath.row];
//    [self.deleteArr addObject:model.faceId];
    
}

#pragma mark - Custom Delegate
#pragma mark - FWEditFacesCellDelegate

- (void)FWEditFacesCellDelegateClick:(NSIndexPath *)indexPath
{
    self.dataArr = [FWAttentionModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section+1]]];
    FWAttentionModel *selectModel = self.dataArr[indexPath.row];
    selectModel.indexPath = indexPath;
    
    
    if ([self.deleteArr containsObject:selectModel.faceId]) {
        
        selectModel.isSelect = NO;
    }else{
        
        selectModel.isSelect = YES;
    }
    
    if (selectModel.isSelect) {
        [self.deleteArr addObject:selectModel.faceId];
        [self.deleteModelArr addObject:selectModel];
    }else{
        [self.deleteArr removeObject:selectModel.faceId];
        
//        for (FWAttentionModel *model in self.deleteModelArr) {
//            if (model.faceId == selectModel.faceId) {
//                [self.deleteModelArr removeObject:model];
//            }
//        }Collection <__NSArrayM: 0x281ca6f70> was mutated while being enumerated.当程序出现这个提示的时候，是因为你一边便利数组，又同时修改这个数组里面的内容，导致崩溃
        
        [self.deleteModelArr enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            FWAttentionModel *amodel = (FWAttentionModel*)obj;
            if ([amodel.faceId isEqualToString:selectModel.faceId]) {
                *stop = YES;
                if (*stop == YES) {
                    [self.deleteModelArr removeObject:obj];
                }
            }
        }];
    }
    NSArray *arr = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Event Response
- (void)deleteClick
{
    if (self.deleteArr.count == 0) {
        [MBProgressHUD showTips:@"请选择要删除的Face"];
        return;
    }
    [UIAlertController js_alertAviewWithTarget:self andAlertTitle:nil andMessage:@"确认移除？" andDefaultActionTitle:@"确认" dHandler:^(UIAlertAction *action) {
        NSString *tempStr = [self.deleteArr componentsJoinedByString:@","];
//        for (NSString *faceId in self.deleteArr) {
//
//            if ([tempStr isEqualToString:@""]) {
//                tempStr = faceId;
//            }else{
//                tempStr  = [NSString stringWithFormat:@"%@,%@",tempStr,faceId];
//            }
//        }
        [self deleteFace:tempStr];
    } andCancelActionTitle:@"取消" cHandler:^(UIAlertAction *action) {
        
    } completion:nil];
}

- (void)saveClick
{
    if (self.groupText.text == nil || [self.groupText.text isEqualToString:@""]) {
        [MBProgressHUD showTips:@"请正确填写群组名称"];
    }else{
        [self editGroupsName:self.groupText.text];
    }
}


#pragma mark - Network Requests
- (void)loadData
{
    if (self.syView) {
        UIView *view = [self.view viewWithTag:12345];
        [view removeFromSuperview];
    }
    NSDictionary *param = @{
                            @"groupsId":self.model.groupsId,
                            @"requestType":@"2"
                            };
    [FWMeManager loadGroupsFaceDeleteListWithParameters:param result:^(id response) {
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

- (void)deleteFace:(NSString *)faceIds
{
    
    NSDictionary *param = @{
                            @"groupsId":self.model.groupsId,
                            @"groupsFaceIds":faceIds,
                            @"groupsType":self.model.groupsType,
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID]
                            };
    [FWMeManager deleteGroupFacesWithParameters:param result:^(id response) {
        [MBProgressHUD showTips:response[@"resultDesc"]];
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self.deleteArr removeAllObjects];
            [self.deleteModelArr removeAllObjects];
            [USER_DEFAULTS setObject:@"1" forKey:UD_FaceLibraryChange];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

- (void)editGroupsName:(NSString*)text
{
    NSDictionary *param = @{
                            @"groupsId":self.model.groupsId,
                            @"groupsName":text
                            };
    [FWMeManager editGroupsNameWithParameters:param result:^(id response) {
        [MBProgressHUD showTips:response[@"resultDesc"]];
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [USER_DEFAULTS setObject:@"1" forKey:UD_FaceLibraryChange];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.groupblock) {
                    self.groupblock(text);
                }
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setSubView
{
    self.groupView = [[UIView alloc] initWithFrame:CGRectZero];
    self.groupView.backgroundColor = Color_White;
    [self.view addSubview:self.groupView];
    [self.groupView addSubview:self.groupLab];
    [self.groupView addSubview:self.groupText];
    [self.groupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.top.equalTo(self.view).offset(NavigationBar_H+10);
        make.left.right.equalTo(self.view);
    }];
    
    [self.groupLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.groupView).offset(10);
        make.width.offset(80);
        make.top.bottom.equalTo(self.groupView);
    }];
    
    [self.groupText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.groupLab.mas_right).offset(10);
        make.top.bottom.equalTo(self.groupView);
        make.right.equalTo(self.groupView).offset(-10);
    }];
}

- (void)setNav
{
    
    if ([self.type isEqualToString:@"1"]) {
        self.navigationItem.title = @"修改Face群名称";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem js_itemWithTitle:@"保存" target:self action:@selector(saveClick)];
    }else{
        self.navigationItem.title = @"选择Face";
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem js_itemWithTitle:@"删除" target:self action:@selector(deleteClick)];
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
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(NavigationBar_H);
        make.bottom.mas_equalTo(self.view);
    }];
    
    LhkhWeakSelf(self);
    self.tableView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
}

- (void)setSYView
{
    self.syView = [[LGUIView alloc] initWithFrame:CGRectMake(Screen_W-40, (Screen_H-15*(self.keyArr.count+1))/2, 40, 15*(self.keyArr.count+1)) indexArray:self.keyArr];
    self.syView.tag = 12345;
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

- (UILabel*)groupLab
{
    if (_groupLab == nil) {
        _groupLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _groupLab.text = @"群名称丨";
        _groupLab.font = systemFont(14);
        _groupLab.textColor = Color_SubText;
    }
    return _groupLab;
}

- (LhkhTextField*)groupText
{
    if (_groupText == nil) {
        _groupText = [[LhkhTextField alloc] initWithFrame:CGRectZero];
        _groupText.text = self.model.groupsName?:@"";
        _groupText.textColor = Color_MainText;
        _groupText.font = systemFont(16);
        _groupText.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _groupText;
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

- (NSMutableArray*)deleteArr
{
    if (_deleteArr == nil) {
        _deleteArr = [NSMutableArray array];
    }
    return _deleteArr;
}

- (NSMutableArray*)deleteModelArr
{
    if (_deleteModelArr == nil) {
        _deleteModelArr = [NSMutableArray array];
    }
    return _deleteModelArr;
}

#pragma mark - Getters


@end
