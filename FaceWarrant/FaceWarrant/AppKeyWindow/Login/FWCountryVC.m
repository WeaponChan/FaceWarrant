//
//  FWCountryVC.m
//  FaceWarrant
//
//  Created by FW on 2018/8/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWCountryVC.h"
#import "FWLoginManager.h"
#import "FWCountryModel.h"
#import "FWCountryCell.h"
#import "LGUIView.h"
@interface FWCountryVC ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic)UIView *topView;
@property (strong, nonatomic)UITableView *tableView;
@property (strong, nonatomic)NSMutableArray *countryArr;
@property (strong, nonatomic)NSMutableArray *keyArr;
@property (strong, nonatomic)NSMutableArray *commonArr;
@property (strong, nonatomic)LGUIView *syView;
@end

@implementation FWCountryVC

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.keyArr.count+1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.commonArr.count;
    }else{
        FWCountryModel *model = self.keyArr[section-1];
        return model.countryList.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWCountryListModel *mModel = nil;
    if (indexPath.section == 0) {
        FWCountryModel *model = self.commonArr[indexPath.row];
        self.countryArr = [FWCountryListModel mj_objectArrayWithKeyValuesArray:model.countryList];
        mModel = self.countryArr[0];
    }else{
        FWCountryModel *model = self.keyArr[indexPath.section-1];
        self.countryArr = [FWCountryListModel mj_objectArrayWithKeyValuesArray:model.countryList];
        mModel = self.countryArr[indexPath.row];
    }
    
    FWCountryCell *cell = [FWCountryCell cellWithTableView:tableView] ;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithModel:mModel indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FWCountryCell cellHeight];
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
        label.text = @"常用地区";
    }else{
        FWCountryModel *model = self.keyArr[section-1];
        label.text = model.first;
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWCountryListModel *mModel = nil;
    if (indexPath.section == 0) {
        FWCountryModel *model = self.commonArr[indexPath.row];
        self.countryArr = [FWCountryListModel mj_objectArrayWithKeyValuesArray:model.countryList];
        mModel = self.countryArr[0];
    }else{
        FWCountryModel *model = self.keyArr[indexPath.section-1];
        self.countryArr = [FWCountryListModel mj_objectArrayWithKeyValuesArray:model.countryList];
        mModel = self.countryArr[indexPath.row];
    }
    if (self.countryblock) {
        self.countryblock(mModel.name, mModel.value,mModel.ID);
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark - Custom Delegate


#pragma mark - Event Response
- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Network Requests


#pragma mark - Public Methods


#pragma mark - Private Methods

- (void)setSubView
{
    self.topView = [[UIView alloc] initWithFrame:CGRectZero];
    self.topView.backgroundColor = Color_White;
    [self.view addSubview:self.topView];
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(130);
        make.left.top.right.equalTo(self.view);
    }];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backBtn setTitleColor:Color_Black forState:UIControlStateNormal];
    [backBtn setImage:Image(@"back_black") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(20);
        if (IS_iPhoneX_Later) {
            make.top.equalTo(self.view).offset(44);
        }else{
            make.top.equalTo(self.view).offset(30);
        }
        make.left.equalTo(self.view).offset(15);
    }];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"选择国家和地区";
    label.textColor = Color_Black;
    label.font = systemFont(30);
    [self.topView addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.left.equalTo(self.view).offset(30);
        make.top.equalTo(backBtn.mas_bottom).offset(25);
    }];
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
        make.top.mas_equalTo(self.topView.mas_bottom);
        make.bottom.mas_equalTo(self.view);
    }];
    
}

- (void)setSYView
{
    NSMutableArray *tempArr = [NSMutableArray array];
    [tempArr removeAllObjects];
    for (FWCountryModel *model in self.keyArr) {
        [tempArr addObject:model.first];
    }
    [tempArr insertObject:@"↑" atIndex:0];
    self.syView = [[LGUIView alloc] initWithFrame:CGRectMake(Screen_W-40, (Screen_H-15*tempArr.count + 80)/2, 40, 15*tempArr.count) indexArray:tempArr];
    [self.view addSubview:self.syView];
    
    [self.syView selectIndexBlock:^(NSInteger section)
     {
         [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                                     animated:NO
                               scrollPosition:UITableViewScrollPositionTop];
     }];
}

- (void)loadData
{
    [self.keyArr removeAllObjects];
    [self.commonArr removeAllObjects];
    [self.countryArr removeAllObjects];
    [FWLoginManager loadCountryWithParameters:nil result:^(NSArray <FWCountryModel*> *model) {
        if (model && model.count>0) {
            for (FWCountryModel *mModel in model) {
                NSScanner* scan = [NSScanner scannerWithString:mModel.first];
                int val;
                if ([scan scanInt:&val] && [scan isAtEnd]) {
                    [self.commonArr addObject:mModel];
                }else{
                    [self.keyArr addObject:mModel];
                }
            }
            [self.tableView reloadData];
            [self setSYView];
            
        }else{
            [MBProgressHUD showError:@"获取国家地区编码失败"];
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

- (NSMutableArray*)countryArr
{
    if (_countryArr == nil) {
        _countryArr = [NSMutableArray array];
    }
    return _countryArr;
}

- (NSMutableArray*)commonArr
{
    if (_commonArr == nil) {
        _commonArr = [NSMutableArray array];
    }
    return _commonArr;
}

#pragma mark - Getters


@end
