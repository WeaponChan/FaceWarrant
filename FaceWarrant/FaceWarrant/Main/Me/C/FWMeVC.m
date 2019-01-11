//
//  FWMeVC.m
//  FaceWarrant
//
//  Created by LHKH on 2018/6/8.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMeVC.h"
#import "FWMeHeaderCell.h"
#import "FWMeSecondCell.h"
#import "FWMeItemCell.h"
#import "FWMyFaceVC.h"
#import "FWMyCollectVC.h"
#import "FWAttentionVC.h"
#import "FWSetUpVC.h"
#import "FWAboutVC.h"
#import "FWIntegralVC.h"
#import "FWMessageVC.h"
#import "FWMyQuestionVC.h"
#import "FWFaceValueVC.h"
#import "FWFaceGroupVC.h"
#import "FWInviteVC.h"
#import "FWMeManager.h"
#import "FWMeInfoModel.h"
#import "OSSUploadFileManager.h"
@interface FWMeVC ()<UITableViewDelegate, UITableViewDataSource,FWMeHeaderCellDelegate,FWMeSecondCellDelegate>
{
    UIBarButtonItem *right;
    NSString *_isShow;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FWMeInfoModel *model;
@property (assign, nonatomic) CGFloat marginTop;
@property (strong, nonatomic) UIView *naviView;
@property (strong, nonatomic) UIButton *qiandaoBtn;
@property (strong, nonatomic) UILabel *navTitle;
@end

@implementation FWMeVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setTableView];
    [self setNaviView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isShow = [USER_DEFAULTS objectForKey:UD_IsShowBuy];
    [self loadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_ChangeHeaderbgImg object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_ApplyFaceValueSuccess object:nil];
}

#pragma mark - Layout SubViews



#pragma mark - System Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 || section == 1) {
        return 1;
    }else if (section == 2 ){
        return 3;
    }else{
        if ([_isShow isEqualToString:@"1"]) {
            return 3;
        }else{
            return 4;
        }
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FWMeHeaderCell *cell = [FWMeHeaderCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell configCellWithModel:self.model];
        return cell;
    }else if (indexPath.section == 1){
        FWMeSecondCell *cell = [FWMeSecondCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell configCellWithModel:self.model];
        return cell;
    }else{
        FWMeItemCell *cell = [FWMeItemCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithIndexPath:indexPath item:self.model vcType:@""];
        return cell;
    }
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [FWMeHeaderCell cellHeight];
    }else if (indexPath.section == 1){
        return [FWMeSecondCell cellHeight];;
    }
    else{
        return [FWMeItemCell cellHeight];
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 3) {
        return 50;
    }else{
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            DLog(@"我的消息");
            [self.navigationController pushViewController:[FWMessageVC new] animated:NO];
        }else if (indexPath.row == 1){
            DLog(@"我的提问");
            FWMyQuestionVC *vc = [FWMyQuestionVC new];
            vc.vctype = @"我的提问";
            [self.navigationController pushViewController:vc animated:NO];
        }else{
            DLog(@"我的问答");
            FWMyQuestionVC *vc = [FWMyQuestionVC new];
            vc.vctype = @"我的回答";
            [self.navigationController pushViewController:vc animated:NO];
        }
    }else if (indexPath.section == 3){
        if ([_isShow isEqualToString:@"1"]) {
            if (indexPath.row == 0){
                DLog(@"群组管理");
                [self.navigationController pushViewController:[FWFaceGroupVC new] animated:NO];
            }else if (indexPath.row == 1) {
                DLog(@"设置");
                FWSetUpVC *vc = [[FWSetUpVC alloc] init];
                vc.headerUrl = self.model.headUrl;
                vc.model = self.model;
                [self.navigationController pushViewController:vc animated:NO];
            }else if(indexPath.row == 2){
                DLog(@"关于我们");
                [self.navigationController pushViewController:[FWAboutVC new] animated:NO];
            }
        }else{
            if (indexPath.row == 0) {
                DLog(@"邀请好友");
                FWInviteVC *vc = [FWInviteVC new];
                vc.name = self.model.name;
                vc.point = self.model.pointsRegister;
                [self.navigationController pushViewController:vc animated:NO];
            }else if (indexPath.row == 1){
                DLog(@"群组管理");
                [self.navigationController pushViewController:[FWFaceGroupVC new] animated:NO];
            }else if (indexPath.row == 2) {
                DLog(@"设置");
                FWSetUpVC *vc = [[FWSetUpVC alloc] init];
                vc.headerUrl = self.model.headUrl;
                vc.model = self.model;
                [self.navigationController pushViewController:vc animated:NO];
            }else if(indexPath.row == 3){
                DLog(@"关于我们");
                [self.navigationController pushViewController:[FWAboutVC new] animated:NO];
            }
        }
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.marginTop != scrollView.contentInset.top) {
        self.marginTop = scrollView.contentInset.top;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    offsetY = MIN(offsetY, 0);
    offsetY = MAX(-StatusBar_H, offsetY);
    self.naviView.backgroundColor = [Color_MainBg colorWithAlphaComponent:(StatusBar_H + offsetY) / StatusBar_H];
    if (offsetY == -StatusBar_H) {
        self.navTitle.text = @"";
        self.qiandaoBtn.hidden = YES;
    }else{
        self.navTitle.text = @"我的";
        self.qiandaoBtn.hidden = YES;
    }
}

#pragma mark - Custom Delegate

#pragma mark - FWMeHeaderCellDelegate
-(void)FWMeHeaderCellDelegateWith:(NSInteger)tag
{
    if (tag == 0) {
        DLog(@"积分");
        [self.navigationController pushViewController:[FWIntegralVC new] animated:NO];
    }else if(tag == 1){
        DLog(@"脸值");
        FWFaceValueVC *vc = [FWFaceValueVC new]; 
        [self.navigationController pushViewController:vc animated:NO];
    }else if(tag == 2){
        [self qiandaoClick];
    }
}


#pragma mark - FWMeSecondCellDelegate

- (void)FWMeSecondCellDelegateWith:(NSInteger)tag
{
    if(tag == 2){
        FWAttentionVC *vc = [FWAttentionVC new];
        vc.vcTitle = @"我的关注";
        [self.navigationController pushViewController:vc animated:NO];
    }else if(tag == 3){
        FWMyFaceVC *vc = [FWMyFaceVC new];
        vc.vcTitle = @"我的碑它";
        [self.navigationController pushViewController:vc animated:NO];
    }else if(tag == 4){
        FWMyCollectVC *vc = [FWMyCollectVC new];
        vc.vcTitle = @"心愿单";
        [self.navigationController pushViewController:vc animated:NO];
    }
}

#pragma mark - Event Response

- (void)changeHeaderBgImg
{
    [self loadData];
}

- (void)applyFaceValueSuccess
{
    [self loadData];
}


#pragma mark - Network requests

- (void)loadData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"loginType":[USER_DEFAULTS objectForKey:UD_LoginType]
                            };
    [FWMeManager loadMeWithParameters:param result:^(FWMeInfoModel *model) {
        self.model = model;
        if ([model.isSignOn isEqualToString:@"0"]) {
            [self.qiandaoBtn setTitle:@"签到" forState:UIControlStateNormal];
            [self.qiandaoBtn setImage:Image(@"me_qiandao") forState:UIControlStateNormal];
            self.qiandaoBtn.backgroundColor = Color_Theme_Pink;
            self.qiandaoBtn.enabled = YES;
        }else{
            [self.qiandaoBtn setTitle:@"已签到" forState:UIControlStateNormal];
            [self.qiandaoBtn setImage:Image(@"me_qiandao") forState:UIControlStateNormal];
            self.qiandaoBtn.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
            self.qiandaoBtn.enabled = NO;
        }
        self.navigationItem.rightBarButtonItem = self->right;
        [USER_DEFAULTS setObject:model.headUrl forKey:UD_UserHeadImg];
        [USER_DEFAULTS setObject:model.balance forKey:UD_UserFaceValue];
        [USER_DEFAULTS setObject:model.phoneNo forKey:UD_UserPhone];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)qiandaoClick
{

    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID]
                            };
    [FWMeManager qiandaoClickWithParameters:param result:^(id response) {
        [self loadData];
        NSString *pointsBase = response[@"result"][@"pointsBase"];
        UIView *view = [[UIView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.height.offset(100);
            make.width.offset(170);
        }];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        imageView.image = Image(@"qiandaoBg");
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(view);
        }];
        
        UILabel *point = [[UILabel alloc]initWithFrame:CGRectZero];
        point.text = StringConnect(@"+", pointsBase);
        point.font = systemFont(24);
        point.textAlignment = NSTextAlignmentCenter;
        point.textColor = [UIColor colorWithHexString:@"#FDFA02"];
        [view addSubview:point];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.text = @"签到成功";
        label.font = systemFont(14);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = Color_White;
        [view addSubview:label];
        
        [point mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(20);
            make.centerX.equalTo(view.mas_centerX);
            make.top.equalTo(view).offset(25);
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(20);
            make.centerX.equalTo(view.mas_centerX);
            make.top.equalTo(point.mas_bottom).offset(5);
        }];
        
        view.alpha = 1;
        [UIView animateWithDuration:1.0 // 动画时长
                              delay:0.0 // 动画延迟
             usingSpringWithDamping:1.0 // 类似弹簧振动效果 0~1
              initialSpringVelocity:2.0 // 初始速度
                            options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                         animations:^{
                             CGPoint point = view.center;
                             point.y -= 300;
                             [view setCenter:point];
                         } completion:^(BOOL finished) {
                             // 动画完成后执行
                             [view setAlpha:0];
                             [view removeFromSuperview];
                         }];
    }];
}


#pragma mark - Public Methods




#pragma mark - Private Methods

-(void)setNav
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHeaderBgImg) name:Notif_ChangeHeaderbgImg object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applyFaceValueSuccess) name:Notif_ApplyFaceValueSuccess object:nil];
}

- (void)setNaviView
{
    self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, NavigationBar_H)];
    self.naviView.backgroundColor = [Color_MainBg colorWithAlphaComponent:0];
    [self.view addSubview:self.naviView];

    self.navTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    self.navTitle.font = systemFont(18);
    self.navTitle.textColor = Color_Black;
    self.navTitle.textAlignment = NSTextAlignmentCenter;
    [self.naviView addSubview:self.navTitle];
    
    self.qiandaoBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    self.qiandaoBtn.hidden = YES;
    [self.qiandaoBtn addTarget:self action:@selector(qiandaoClick) forControlEvents:UIControlEventTouchUpInside];
    self.qiandaoBtn.titleLabel.font = systemFont(12);
    self.qiandaoBtn.layer.cornerRadius = 12.f;
    self.qiandaoBtn.layer.masksToBounds = YES;
    [self.naviView addSubview:self.qiandaoBtn];
    
    [self.navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.left.right.equalTo(self.naviView);
        make.top.equalTo(self.naviView).offset(StatusBar_H+10);
        make.centerX.equalTo(self.naviView.mas_centerX);
    }];
    
    [self.qiandaoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.naviView).offset(12);
        make.height.offset(24);
        make.width.offset(80);
        make.centerY.equalTo(self.navTitle.mas_centerY);
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
        make.top.mas_equalTo(self.view).offset(-StatusBar_H);
        make.bottom.mas_equalTo(self.view);
    }];
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    __weak typeof(self) weakself = self;
    self.tableView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
}


#pragma mark - Setters




#pragma mark - Getters




@end
