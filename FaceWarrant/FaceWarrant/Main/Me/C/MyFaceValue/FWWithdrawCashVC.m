//
//  FWWithdrawCashVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWithdrawCashVC.h"
#import "FWMeItemCell.h"
#import "FWApplyCashVC.h"
@interface FWWithdrawCashVC ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation FWWithdrawCashVC

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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWMeItemCell *cell = [FWMeItemCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithIndexPath:indexPath item:@"" vcType:@"我要提现"];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 15;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWApplyCashVC *vc = [FWApplyCashVC new];
    if (indexPath.section == 0) {
        vc.itemType = @"支付宝";
    }else{
        vc.itemType = @"银行卡";
    }
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - Custom Delegate


#pragma mark - Event Response


#pragma mark - Network Requests


#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.title = @"我要提现";
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
}

#pragma mark - Setters


#pragma mark - Getters


@end
