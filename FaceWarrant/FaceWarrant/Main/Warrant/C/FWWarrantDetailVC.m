//
//  FWWarrantDetailVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantDetailVC.h"

#import "FWCommentListVC.h"
#import "FWWarrantFCell.h"
#import "FWWarrantBannerCell.h"
#import "FWWarrantBrandCell.h"
#import "FWWarrantBrandDescCell.h"
#import "FWWarrantUseExpeCell.h"
#import "FWWarrantHeaderCell.h"
#import "FWWarrantCommentCell.h"
#import "FWWarrantFooterCell.h"
#import "FWWarrantBottomView.h"
#import "FWWarrantBottomBuyView.h"
#import "FWShareView.h"
#import "FWWarrantManager.h"
#import "FWWarrantDetailModel.h"
#import "FWMapVC.h"
#import "FWQCodeVC.h"
#import "FWWindowManager.h"

#import "WXApi.h"

@interface FWWarrantDetailVC ()<UITableViewDelegate, UITableViewDataSource,FWWarrantBannerCellDelegate,FWWarrantBrandDescCellDelegate>
{
    CGFloat _imgCellH;
    BOOL _isFirst;
    BOOL _isPop;
    BOOL _isShare;
    BOOL _isShop;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FWWarrantBottomView *bottomView;
@property (strong, nonatomic) FWWarrantBottomBuyView *bottomBuyView;
@property (strong, nonatomic) FWShareView *shareView;
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;//毛玻璃视图
@property (strong, nonatomic) FWWarrantDetailModel *model;
@property (strong, nonatomic) NSMutableArray *commentList;
@end

@implementation FWWarrantDetailVC

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
    [self.tableView.mj_header beginRefreshing];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"refreshData" object:nil];
}
#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码

#pragma mark - System Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 6){
        return self.commentList.count;
    }
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FWWarrantFCell *cell = [FWWarrantFCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithModel:self.model];
        return cell;
    }else if(indexPath.section == 1){
        FWWarrantBannerCell *cell = [FWWarrantBannerCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.celldelegate = self;
        if (_isFirst) {
            [cell configCellWithData:self.model];
        }
        return cell;
    }else if(indexPath.section == 2){
        FWWarrantBrandCell *cell = [FWWarrantBrandCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithModel:self.model];
        return cell;
    }else if(indexPath.section == 3){
        FWWarrantBrandDescCell *cell = [FWWarrantBrandDescCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell configCellWithModel:self.model indexPath:indexPath];
        return cell;
    }else if(indexPath.section == 4){
        FWWarrantUseExpeCell *cell = [FWWarrantUseExpeCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithModel:self.model];
        return cell;
    }else if(indexPath.section == 5){
        FWWarrantHeaderCell *cell = [FWWarrantHeaderCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithNum:self.model.commentCount];
        return cell;
    }else if(indexPath.section == 7){
        FWWarrantFooterCell *cell = [FWWarrantFooterCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        FWWarrantCommentCell *cell = [FWWarrantCommentCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CommendReplyModel *model = self.commentList[indexPath.row];
        [cell configCellWithData:self.model commentReplyModel:model indexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [FWWarrantFCell cellHeight];
    }else if (indexPath.section == 1){
        return _imgCellH;
    }else if (indexPath.section == 2){
        return [FWWarrantBrandCell cellHeight];
    }else if (indexPath.section == 3){
        if (self.model.isExpand) {
            return UITableViewAutomaticDimension;
        }else{
            return [FWWarrantBrandDescCell cellHeight];
        }
    }else if (indexPath.section == 4){
        return UITableViewAutomaticDimension;
    }else if (indexPath.section == 5){
        return 44;
    }else if (indexPath.section == 7){
        if (self.commentList.count>0) {
            return 44;
        }else{
            return 0;
        }
    }else{
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [FWWarrantFCell cellHeight];
    }else if (indexPath.section == 1){
        return _imgCellH;
    }else if (indexPath.section == 2){
        return [FWWarrantBrandCell cellHeight];
    }else if (indexPath.section == 3){
        return [FWWarrantBrandDescCell cellHeight];
    }else if (indexPath.section == 4){
        return 60;
    }else if (indexPath.section == 5){
        return 44;
    }else if (indexPath.section == 7){
        if (self.commentList.count>0) {
            return 44;
        }else{
            return 0;
        }
    }else{
        return 44;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 6 || section == 7) {
        return nil;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 6 || section == 7) {
        return 0;
    }
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.commentList.count>0) {
        if (indexPath.section == 5 || indexPath.section == 7) {
            FWCommentListVC *vc = [FWCommentListVC new];
            vc.indexTag = 1;
            vc.dModel = self.model;
            [self.navigationController pushViewController:vc animated:NO];
        }
    }
}

#pragma mark - Custom Delegate
#pragma mark - FWWarrantBannerCellDelegate
- (void)FWWarrantBannerCellDelegateWithHeight:(CGFloat)height
{
    _imgCellH = height;
    _isFirst = NO;
    [self.tableView reloadData];
}

- (void)FWWarrantBannerCellDelegateClick:(NSString *)playAuth
{
    
}


#pragma mark - FWWarrantBrandDescCellDelegate

- (void)FWWarrantBrandDescCellDelegateExpandClickWithIndexPath:(NSIndexPath *)indexPath
{
    self.model.isExpand = !self.model.isExpand;
    NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
    [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Event Response

- (void)shareClick
{
    if ([WXApi isWXAppInstalled]) {
        _isShare = YES;
        [self loadData];
    }
}

- (void)shopClick
{
    _isShop = YES;
    [self loadData];
}

- (void)backClick
{
    [[FWWindowManager sharedWindow] showTabbarView:nil];
}

#pragma mark - Network Requests

- (void)refreshData
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)loadData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"releaseGoodsId":self.releaseGoodsId,
                            @"isNew":self.isNew?:@"0"
                            };
    [FWWarrantManager loadWarrantDetailWithParameters:param result:^(FWWarrantDetailModel *model,NSString *resultCode) {
        if (resultCode && [resultCode isEqual:@200]) {
            self.model = model;
            self->_isFirst = YES;
            self.commentList = [CommendReplyModel mj_objectArrayWithKeyValuesArray:model.commendReplyResponseDtoList];
            [self.tableView reloadData];
            [self setupBottomView:self.model.hasBuy code:resultCode];
            [self setShareView];
            if (self->_isShop == YES) {
                self->_isShop = NO;
                FWMapVC *vc = [FWMapVC new];
                vc.selectType = @"品牌实体店";
                vc.goodsName = self.model.goodsName;
                vc.brandId = self.model.brandId;
                [self.navigationController pushViewController:vc animated:NO];
            }
        }else if (resultCode && [resultCode isEqual:@4002]){
            [MBProgressHUD showTips:@"此碑它已被取消"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:NO];
            });
            
        }else{
            [MBProgressHUD showTips:@"未获取到碑它详情"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:NO];
            });
        }
        [self.tableView.mj_header endRefreshing];
    }];
    
}

#pragma mark - Public Methods


#pragma mark - Private Methods

- (void)setNav
{
    self.navigationItem.title = @"碑它详情";
    UIButton *shopBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shopBtn addTarget:self action:@selector(shopClick) forControlEvents:UIControlEventTouchUpInside];
    [shopBtn setImage:[UIImage imageNamed:@"nearby"] forState:UIControlStateNormal];
    [shopBtn sizeToFit];
    UIBarButtonItem *shop = [[UIBarButtonItem alloc] initWithCustomView:shopBtn];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = 22;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn addTarget:self action:@selector(shareClick) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareBtn sizeToFit];
    UIBarButtonItem *share = [[UIBarButtonItem alloc] initWithCustomView:shareBtn];
    self.navigationItem.rightBarButtonItems = @[share,space,shop];
    
    if ([self.flag isEqualToString:@"1"]) {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem js_itemWithImage:@"back_black" highImage:@"back_black" target:self action:@selector(backClick)];
    }
    _isShare = NO;
    _isShop = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshData" object:nil];
}
- (void)setTableView
{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = Color_MainBg;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[FWWarrantCommentCell class] forCellReuseIdentifier:@"FWWarrantCommentCell"];
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
        make.bottom.mas_equalTo(self.view).offset(-50);
    }];
    
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    __weak typeof(self) weakself = self;
    self.tableView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
}

- (void)setupBottomView:(NSString *)hasbuy code:(NSString *)resultCode
{
    NSString *isShow = [USER_DEFAULTS objectForKey:UD_IsShowBuy];
    
    if ([isShow isEqualToString:@"1"]) {
        [self.view addSubview:self.bottomView];
        [self.bottomView configViewWithData:self.model code:resultCode];
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(50);
            make.bottom.left.right.equalTo(self.view);
        }];
    }else{
        if ([hasbuy isEqualToString:@"1"]) {
            [self.view addSubview:self.bottomBuyView];
            [self.bottomBuyView configViewWithData:self.model code:resultCode];
            [self.bottomBuyView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(50);
                make.bottom.left.right.equalTo(self.view);
            }];
        }else{
            [self.view addSubview:self.bottomView];
            [self.bottomView configViewWithData:self.model code:resultCode];
            [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(50);
                make.bottom.left.right.equalTo(self.view);
            }];
        }
    }
    
}

- (void)setShareView
{
    if (self.visualEffectView) {
        UIView *view = [self.view viewWithTag:100002];
        [view removeFromSuperview];
    }
    //实现模糊效果
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //毛玻璃视图
    self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    self.visualEffectView.tag = 100002;
    self.visualEffectView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
    self.visualEffectView.alpha = 0.5;
    self.visualEffectView.hidden = YES;
    [self.view addSubview:self.visualEffectView];
    [self.view addSubview:self.shareView];
    self.shareView.hidden = YES;
    LhkhWeakSelf(self);
    self.shareView.cancelblock = ^{
        weakself.shareView.hidden = YES;
        weakself.visualEffectView.hidden = YES;
    };
    [self.shareView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(175);
        make.bottom.left.right.equalTo(self.view);
    }];
    if (_isShare == YES) {
        _isShare = NO;
        self.shareView.hidden = self.visualEffectView.hidden = NO;
        [self.shareView configViewWithModel:self.model];
    }
}


#pragma mark - Setters
- (FWWarrantBottomView*)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [FWWarrantBottomView shareBottomView];
    }
    return _bottomView;
}

- (FWWarrantBottomBuyView*)bottomBuyView
{
    if (_bottomBuyView == nil) {
        _bottomBuyView = [FWWarrantBottomBuyView shareBottomBuyView];
    }
    return _bottomBuyView;
}

- (FWShareView*)shareView
{
    if (_shareView == nil) {
        _shareView = [FWShareView shareView];
    }
    return _shareView;
}

- (NSMutableArray*)commentList
{
    if (_commentList == nil) {
        _commentList = [NSMutableArray array];
    }
    return _commentList;
}

#pragma mark - Getters


@end
