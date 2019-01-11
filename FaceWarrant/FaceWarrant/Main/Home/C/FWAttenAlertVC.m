//
//  FWAttenAlertVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/14.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWAttenAlertVC.h"
#import "FWSelectGroupCell.h"
#import "FWBuildGroupCell.h"
#import "FWFaceLibraryManager.h"
#import "FWMeManager.h"
#import "FWFaceLibraryClassifyModel.h"
#import "FWAlertTextView.h"
#import "FWWarrantManager.h"
@interface FWAttenAlertVC ()<UITableViewDelegate, UITableViewDataSource,FWAlertTextViewDelegate>
@property (strong, nonatomic)NSMutableArray *faceLibraryClassArr;
@property (strong, nonatomic)NSMutableArray *faceLibraryClassIDArr;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewH;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewH;
@property (strong, nonatomic) FWAlertTextView *alertView;
@end

@implementation FWAttenAlertVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSubView];
    [self setTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - Layout SubViews


#pragma mark - System Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.faceLibraryClassArr.count == 4) {
        return self.faceLibraryClassArr.count;
    }else{
        return self.faceLibraryClassArr.count+1;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.faceLibraryClassArr.count == 4) {
        FWSelectGroupCell *cell = [FWSelectGroupCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        FWFaceLibraryClassifyModel *model = self.faceLibraryClassArr[indexPath.row];
        cell.model = model;
        cell.selectblock = ^(BOOL isSelect) {
            if (isSelect == YES) {
                [self.faceLibraryClassIDArr addObject:model.groupsId];
            }else{
                [self.faceLibraryClassIDArr removeObject:model.groupsId];
            }
        };
        return cell;
    }else{
        if (indexPath.row == self.faceLibraryClassArr.count) {
            FWBuildGroupCell *cell = [FWBuildGroupCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            FWSelectGroupCell *cell = [FWSelectGroupCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            FWFaceLibraryClassifyModel *model = self.faceLibraryClassArr[indexPath.row];
            cell.model = model;
            cell.selectblock = ^(BOOL isSelect) {
                if (isSelect == YES) {
                    [self.faceLibraryClassIDArr addObject:model.groupsId];
                }else{
                    [self.faceLibraryClassIDArr removeObject:model.groupsId];
                }
            };
            return cell;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.faceLibraryClassArr.count<4 && indexPath.row == self.faceLibraryClassArr.count) {
        self.bgView.hidden = YES;
        [self addFaceGroup];
    }
}

#pragma mark - Custom Delegate
#pragma mark FWAlertTextViewDelegate

- (void)FWAlertTextViewDidClickCancelButton:(FWAlertTextView *)view
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alertView.alpha = 0;
        [self.alertView removeFromSuperview];
        self.alertView = nil;
    }];
    [self.view endEditing:YES];
    self.bgView.hidden = NO;
}


- (void)FWAlertTextView:(FWAlertTextView *)view didClickConfirmButtonWithLabel:(NSString *)labelStr
{
    DLog(@"---->%@",labelStr);
    if ([labelStr isEqualToString:@"大Face"] || [labelStr isEqualToString:@"大face"]  || [labelStr isEqualToString:@"亲友Face"]  || [labelStr isEqualToString:@"亲友face"]) {
        [MBProgressHUD showTips:@"不能创建以此名字的群组"];
    }else{
        
        [UIView animateWithDuration:0.3 animations:^{
            self.alertView.alpha = 0;
            [self.alertView removeFromSuperview];
            self.alertView = nil;
        }];
        [self.view endEditing:YES];
        
        [self addGroups:labelStr];
    }
}

#pragma mark - Event Response

- (IBAction)cancelClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)sureClick:(id)sender {
    if (self.faceLibraryClassIDArr.count>0) {
        NSString *groupsId = [self.faceLibraryClassIDArr componentsJoinedByString:@","];
        [self addFaceToGroup:groupsId];
    }else{
        [MBProgressHUD showTips:@"请选择群"];
    }
}

- (void)addFaceGroup
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alertView.alpha = 1;
        [self.view addSubview:self.alertView];
    }];
    self.alertView.center = self.view.center;
}
#pragma mark - Network Requests

- (void)loadData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID]
                            };
    [FWFaceLibraryManager loadFaceLibraryClassifyWithParameters:param result:^(NSArray<FWFaceLibraryClassifyModel *> *model) {
        [self.faceLibraryClassArr removeAllObjects];
        for (FWFaceLibraryClassifyModel *mModel in model) {
            if (![mModel.groupsName isEqualToString:@"大Face"]) {
                [self.faceLibraryClassArr addObject:mModel];
            }
        }
        
        if (self.faceLibraryClassArr.count == 4) {
            self.viewH.constant = 300;
            self.tableViewH.constant = 44*self.faceLibraryClassArr.count;
        }else{
            self.viewH.constant = 300-(3-self.faceLibraryClassArr.count)*44;
            self.tableViewH.constant = 44*(self.faceLibraryClassArr.count+1);
        }
        
        [self.tableView reloadData];
    }];
}

- (void)addGroups:(NSString *)groupId
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"groupsName":groupId
                            };
    [FWMeManager addGroupWithParameters:param result:^(id response) {
//        [MBProgressHUD showTips:response[@"resultDesc"]];
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self loadData];
            self.bgView.hidden = NO;
        }else{
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }
        
    }];
}

- (void)addFaceToGroup:(NSString*)groupsId
{
    NSDictionary *param = @{
                            @"faceId":self.faceId,
                            @"groupsId":groupsId
                            };
    [FWWarrantManager attenFaceToGroupWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [MBProgressHUD showTips:response[@"resultDesc"]];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods

- (void)setSubView
{
    self.bgView.layer.cornerRadius = 5.f;
    self.bgView.layer.masksToBounds = YES;
    [self.view addSubview:self.alertView];
}

- (void)setTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - Setters
- (NSMutableArray*)faceLibraryClassArr
{
    if (!_faceLibraryClassArr) {
        _faceLibraryClassArr = [NSMutableArray array];
    }
    return _faceLibraryClassArr;
}

- (NSMutableArray*)faceLibraryClassIDArr
{
    if (!_faceLibraryClassIDArr) {
        _faceLibraryClassIDArr = [NSMutableArray array];
    }
    return _faceLibraryClassIDArr;
}

- (FWAlertTextView *)alertView
{
    if (!_alertView) {
        _alertView = [FWAlertTextView defaultView];
        _alertView.delegate = self;
        _alertView.alpha = 0;
    }
    return _alertView;
}

#pragma mark - Getters


@end
