//
//  FWAccountVC.m
//  FaceWarrant
//
//  Created by LHKH on 2018/7/2.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWAccountVC.h"
#import "FWModifyPwdVC.h"
#import "FWPhoneNoVC.h"
#import "FWMeSubItemCell.h"
#import "FWLoginManager.h"
#import "FWModifyHeaderCell.h"

@interface FWAccountVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;

@end

@implementation FWAccountVC

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section == 1) {
//        return 1;
//    }else{
//        return 2;
//    }
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWMeSubItemCell *cell = [FWMeSubItemCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithIndexPath:indexPath item:@"" vcType:@"账户与安全"];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FWMeSubItemCell cellHeight];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[FWPhoneNoVC new] animated:YES];
        }else if (indexPath.row == 1){
           [self.navigationController pushViewController:[FWModifyPwdVC new] animated:YES];
        }
    }
//    else if (indexPath.section == 1){
//        if (indexPath.row == 0) {
//            [MBProgressHUD showTips:@"开发中,敬请期待"];
//        }
//    }
}



#pragma mark - Custom Delegate




#pragma mark - Event Response



#pragma mark - Network requests



#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setNav
{
    self.navigationItem.title = @"账号与安全";
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


#pragma mark - Setters




#pragma mark - Getters




@end
