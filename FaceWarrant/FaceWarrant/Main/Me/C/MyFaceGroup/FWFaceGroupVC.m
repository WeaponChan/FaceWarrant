//
//  FWFaceGroupVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/20.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFaceGroupVC.h"
#import "FWFaceGroupEditVC.h"
#import "FWGroupItemCell.h"
#import "FWFaceLibraryManager.h"
#import "FWFaceLibraryClassifyModel.h"
#import "FWMeManager.h"
#import "FWAlertTextView.h"
@interface FWFaceGroupVC ()<UITableViewDelegate, UITableViewDataSource,FWGroupItemCellDelegate,FWAlertTextViewDelegate>
{
    NSString *_alertText;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *faceLibraryClassArr;
@property (strong, nonatomic) UIView *maskView;
@property (strong, nonatomic) FWAlertTextView *alertView;
@end

@implementation FWFaceGroupVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.faceLibraryClassArr.count;
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWFaceLibraryClassifyModel *model = self.faceLibraryClassArr[indexPath.row];
    FWGroupItemCell *cell = [FWGroupItemCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithModel:model indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FWGroupItemCell cellHeight];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWFaceLibraryClassifyModel *model = self.faceLibraryClassArr[indexPath.row];
    FWFaceGroupEditVC *vc = [FWFaceGroupEditVC new];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:NO];
}

/*
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWFaceLibraryClassifyModel *model = self.faceLibraryClassArr[indexPath.row];
    UITableViewRowAction *rowAction1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                          title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              DLog(@"删除");
                                                                              [self deleFaceGroupWithId:model.groupsId];
                                                                          }];
    
    UITableViewRowAction *rowAction2 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                          title:@"编辑" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                              DLog(@"编辑");
                                                                              FWFaceGroupEditVC *vc = [FWFaceGroupEditVC new];
                                                                              vc.model = model;
                                                                              [self.navigationController pushViewController:vc animated:NO];
                                                                          }];
    
    if (indexPath.row == 0 || indexPath.row == 1) {
        NSArray *arr = @[rowAction2];
        return arr;
    }else{
        NSArray *arr = @[rowAction1,rowAction2];
        return arr;
    }
}*/

#pragma mark - Custom Delegate

#pragma mark FWAlertTextViewDelegate

- (void)FWAlertTextViewDidClickCancelButton:(FWAlertTextView *)view
{
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 0;
        [self.alertView removeFromSuperview];
        self.alertView = nil;
    }];
    [self.view endEditing:YES];
}


- (void)FWAlertTextView:(FWAlertTextView *)view didClickConfirmButtonWithLabel:(NSString *)labelStr
{
    DLog(@"---->%@",labelStr);
    [UIView animateWithDuration:0.2 animations:^{
        self.maskView.alpha = 0;
        [self.alertView removeFromSuperview];
        self.alertView = nil;
    }];
    [self.view endEditing:YES];
    
    [self addGroups:labelStr];
}


#pragma mark - FWGroupItemCellDelegate
-(void)FWGroupItemCellDelegateClickWithModel:(FWFaceLibraryClassifyModel *)model tag:(NSInteger)tag
{
    if (tag == 0) {
        [self deleFaceGroupWithId:model.groupsId];
    }else{
        FWFaceGroupEditVC *vc = [FWFaceGroupEditVC new];
        vc.model = model;
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - Event Response
- (void)deleFaceGroupWithId:(NSString*)Id
{
    [UIAlertController js_alertAviewWithTarget:self andAlertTitle:@"确认删除该群组？" andMessage:nil andDefaultActionTitle:@"确认" dHandler:^(UIAlertAction *action) {
        [self deleteGroups:Id];
    } andCancelActionTitle:@"取消" cHandler:^(UIAlertAction *action) {
        DLog(@"取消");
    } completion:nil];
}

- (void)addFaceGroup
{
    [UIView animateWithDuration:0.3 animations:^{
        self.maskView.alpha = 1;
        [self.maskView addSubview:self.alertView];
    }];
    self.alertView.center = self.maskView.center;
}

#pragma mark - Network Requests
- (void)loadData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID]
                            };
    [FWFaceLibraryManager loadFaceLibraryClassifyWithParameters:param result:^(NSArray<FWFaceLibraryClassifyModel *> *model) {
        [self.faceLibraryClassArr removeAllObjects];
        [self.faceLibraryClassArr addObjectsFromArray:model];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)deleteGroups:(NSString *)groupId
{
    
    NSDictionary *param = @{
                            @"groupsId":groupId,
                            };
    [FWMeManager deleteGroupsWithParameters:param result:^(id response) {
        [MBProgressHUD showTips:response[@"resultDesc"]];
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [USER_DEFAULTS setObject:@"1" forKey:UD_FaceLibraryChange];
            [self loadData];
        }
    }];
}

- (void)addGroups:(NSString *)groupId
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"groupsName":groupId
                            };
    [FWMeManager addGroupWithParameters:param result:^(id response) {
        [MBProgressHUD showTips:response[@"resultDesc"]];
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [USER_DEFAULTS setObject:@"1" forKey:UD_FaceLibraryChange];
            [self loadData];
        }
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.title = @"Face群管理";
    [self.navigationController.view addSubview:self.maskView];
    [self.maskView addSubview:self.alertView];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem js_itemWithImage:@"me_faceAdd" highImage:@"me_faceAdd" target:self action:@selector(addFaceGroup)];
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
}

#pragma mark - Setters
- (NSMutableArray*)faceLibraryClassArr
{
    if (!_faceLibraryClassArr) {
        _faceLibraryClassArr = [NSMutableArray array];
    }
    return _faceLibraryClassArr;
}

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, Screen_H)];
        _maskView.backgroundColor = [Color_Black colorWithAlphaComponent:0.3];
        _maskView.alpha = 0;
    }
    return _maskView;
}


- (FWAlertTextView *)alertView
{
    if (!_alertView) {
        _alertView = [FWAlertTextView defaultView];
        _alertView.delegate = self;
    }
    return _alertView;
}

#pragma mark - Getters


@end
