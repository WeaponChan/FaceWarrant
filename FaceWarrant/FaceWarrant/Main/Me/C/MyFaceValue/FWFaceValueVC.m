//
//  FWFaceValueVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFaceValueVC.h"
#import "FWMeSubItemCell.h"
#import "FWFaceValueHeaderCell.h"
#import "FWFaceValueDetailVC.h"
#import "FWWithdrawCashVC.h"
#import "FWWithdrawCashNoteVC.h"
#import "WaterRippleView.h"
@interface FWFaceValueVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSString *_faceValue;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UILabel *faceValueLab;

@end

@implementation FWFaceValueVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setTableView];
//    [self setSubView];
}

- (void)viewDidAppear:(BOOL)animated
{
    _faceValue = [USER_DEFAULTS objectForKey:UD_UserFaceValue];
    [self.tableView reloadData];
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
    if (section == 0) {
        return 1;
    }else{
        return 3;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        FWFaceValueHeaderCell *cell = [FWFaceValueHeaderCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithIndexPath:indexPath item:_faceValue];
        return cell;
    }else{
        FWMeSubItemCell *cell = [FWMeSubItemCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithIndexPath:indexPath item:@"" vcType:@"我的脸值"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return Screen_W*0.8;
    }else{
        return 44;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else{
        UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 44)];
        headView.backgroundColor = Color_MainBg;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, Screen_W-20, 34)];
        label.text = @"收入明细";
        label.font = systemFont(14);
        label.textColor = Color_SubText;
        [headView addSubview:label];
        return headView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        FWFaceValueDetailVC *vc = [FWFaceValueDetailVC new];
        if (indexPath.row == 0) {
            vc.itemType = @"订单收入";
        }else if (indexPath.row == 1){
            vc.itemType = @"邀请奖励";
        }else{
            vc.itemType = @"积分兑换";
        }
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - Custom Delegate


#pragma mark - Event Response
- (void)txClick
{
     [self.navigationController pushViewController:[FWWithdrawCashVC new] animated:NO];
}

- (void)txjlClick
{
    [self.navigationController pushViewController:[FWWithdrawCashNoteVC new] animated:NO];
}

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Network Requests


#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.title = @"我的脸值";
}

- (void)setSubView
{
    self.headView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.headView.backgroundColor = Color_White;
    [self.view addSubview:_headView];
    
    UIImageView *bgimageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bgimageView.image = Image(@"me_faceValuehu");
    [self.headView addSubview:bgimageView];
    
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [backBtn setImage:Image(@"back_white") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.headView addSubview:backBtn];
    
    UILabel *itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
    itemLab.text = @"我的脸值";
    itemLab.font = systemFont(18);
    itemLab.textColor = Color_White;
    itemLab.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:itemLab];
    
    
    [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(Screen_W*0.72);
        make.top.equalTo(self.view);
        make.left.right.equalTo(self.view);
    }];
    
    [bgimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.headView);
        make.top.equalTo(self.headView).offset(-1);
    }];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(11);
        make.height.offset(22);
        make.top.equalTo(self.headView.mas_top).offset(52);
        make.left.equalTo(self.headView).offset(15);
    }];
    
    [itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(100);
        make.height.offset(20);
        make.centerX.equalTo(self.headView.mas_centerX);
        make.top.equalTo(self.headView).offset(54);
    }];
    
    UIView *boundView = [[UIView alloc] initWithFrame:CGRectZero];
    boundView.backgroundColor = [UIColor colorWithHexString:@"#FF659A"];
    boundView.layer.cornerRadius = Screen_W*0.16;
    boundView.layer.masksToBounds = YES;
    boundView.layer.borderColor = Color_White.CGColor;
    boundView.layer.borderWidth = 1.f;
    [_headView addSubview:boundView];
    
    
    
    
    [boundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(Screen_W*0.32);
        make.top.equalTo(itemLab.mas_bottom).offset(20);
        make.centerX.equalTo(self.headView.mas_centerX);
    }];
    
//    WaterRippleView *view6 = [[WaterRippleView alloc] initWithFrame:CGRectMake(0, Screen_W*0.32-Screen_W*0.1333, Screen_W*0.32, Screen_W*0.1333)
//                                                    mainRippleColor:[UIColor colorWithRed:242/255.0 green:181/255.0 blue:204/255.0 alpha:1]
//                                                   minorRippleColor:[UIColor colorWithRed:244/255.0 green:196/255.0 blue:214/255.0 alpha:1]
//                                                  mainRippleoffsetX:2.0f
//                                                 minorRippleoffsetX:3.2f
//                                                        rippleSpeed:3.5f
//                                                     ripplePosition:Screen_W*0.1333f
//                                                    rippleAmplitude:5.0f];
//    view6.backgroundColor = [UIColor clearColor];
//    [boundView addSubview:view6];
    
    
    [boundView addSubview:self.faceValueLab];
    
    [self.faceValueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.top.equalTo(boundView).offset(35);
        make.left.right.equalTo(boundView);
    }];
    
    UILabel *curLab = [[UILabel alloc] initWithFrame:CGRectZero];
    [_headView addSubview:curLab];
    curLab.text = @"余额(￥)";
    curLab.font = systemFont(14);
    curLab.textAlignment = NSTextAlignmentCenter;
    curLab.textColor = Color_White;
    
    [curLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(boundView.mas_bottom).offset(5);
        make.centerX.equalTo(boundView);
    }];
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectZero];
    btnView.backgroundColor = Color_White;
    btnView.layer.cornerRadius = 5.f;
    btnView.layer.masksToBounds = YES;
    [self.view addSubview:btnView];
    
    [btnView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(Screen_W*0.16);
        make.width.offset(Screen_W*0.8);
        make.top.equalTo(self.headView.mas_bottom).offset(-Screen_W*0.08);
        make.centerX.equalTo(self.headView.mas_centerX);
    }];
    
    UIButton *txBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [btnView addSubview:txBtn];
    [txBtn setTitle:@"我要提现" forState:UIControlStateNormal];
    [txBtn setImage:Image(@"me_faceValueCash") forState:UIControlStateNormal];
    txBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [txBtn setTitleColor:Color_MainText forState:UIControlStateNormal];
    txBtn.titleLabel.font = systemFont(14);
    [txBtn addTarget:self action:@selector(txClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#C4C4C4"];
    [btnView addSubview:lineView];
    
    UIButton *txjlBtn = [[UIButton alloc]initWithFrame:CGRectZero];
    [btnView addSubview:txjlBtn];
    [txjlBtn setTitle:@"提现记录" forState:UIControlStateNormal];
    [txjlBtn setImage:Image(@"me_faceValueCashNote") forState:UIControlStateNormal];
    txjlBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    [txjlBtn setTitleColor:Color_MainText forState:UIControlStateNormal];
    txjlBtn.titleLabel.font = systemFont(14);
    [txjlBtn addTarget:self action:@selector(txjlClick) forControlEvents:UIControlEventTouchUpInside];
    
    [txBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(Screen_W*0.16);
        make.width.offset(Screen_W*0.4);
        make.top.equalTo(btnView);
        make.bottom.equalTo(btnView);
        make.left.equalTo(btnView);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(Screen_W*0.16-20);
        make.width.offset(1);
        make.centerX.equalTo(btnView.mas_centerX);
        make.centerY.equalTo(btnView.mas_centerY);
    }];
    
    [txjlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(Screen_W*0.16);
        make.width.offset(Screen_W*0.4);
        make.top.equalTo(btnView);
        make.bottom.equalTo(btnView);
        make.right.equalTo(btnView);
    }];
    
    [self setTableView];
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
        make.top.mas_equalTo(self.view).offset(-StatusBar_H);
        make.bottom.mas_equalTo(self.view);
    }];
}

#pragma mark - Setters
- (UILabel*)faceValueLab
{
    if (_faceValueLab == nil) {
        _faceValueLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _faceValueLab.textAlignment = NSTextAlignmentCenter;
        _faceValueLab.font = systemFont(30);
        _faceValueLab.textColor = Color_White;
    }
    return _faceValueLab;
}

#pragma mark - Getters


@end
