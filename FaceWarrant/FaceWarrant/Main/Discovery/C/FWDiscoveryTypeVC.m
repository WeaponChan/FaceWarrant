//
//  FWDiscoveryTypeVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWDiscoveryTypeVC.h"
#import "FWPersonalHomePageVC.h"
#import "FWDiscoveryFaceCell.h"
#import "FWDiscoveryBlankCell.h"
#import "FWDiscoveryComCell.h"
#import "FWMQReplyCell.h"
#import "FWDiscoveryManager.h"
#import "FWMessageManager.h"
#import "FWDiscoveryModel.h"
#import "UIButton+Lhkh.h"
#import "FWQuestionDetailVC.h"
#import "FWMeManager.h"
@interface FWDiscoveryTypeVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITableViewDelegate, UITableViewDataSource,FWMQReplyCellDelClickDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIView *blankView;
@property (strong, nonatomic) UICollectionView *faceCollectionView;
@property (strong, nonatomic) NSMutableArray *dataList;
@end
static int page = 1;
@implementation FWDiscoveryTypeVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (self.selectType == 0) {
        [self loadData];
    }else{
        [self loadAnswerList];
        [self setTableView];
    }
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.selectType == 0) {
        return 2;
    }else{
        return self.dataList.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectType == 0) {
        if (indexPath.section == 0) {
            FWDiscoveryBlankCell *cell = [FWDiscoveryBlankCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            FWDiscoveryComCell *cell = [FWDiscoveryComCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        FWMessageAModel *model = self.dataList[indexPath.section];
        FWMQReplyCell *cell = [FWMQReplyCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithModel:model vctype:@"FWDiscoveryTypeVC"];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectType == 0) {
        if (indexPath.section == 0) {
            return [FWDiscoveryBlankCell cellHeight];
        }else{
            return [FWDiscoveryComCell cellHeight];
        }
    }
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.selectType == 0) {
        if (section == 0) {
            return nil;
        }else{
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 30)];
            view.backgroundColor = Color_MainBg;
            UILabel *rlabel = [[UILabel alloc] initWithFrame:CGRectZero];
            rlabel.text = @"推荐";
            rlabel.font = systemFont(14);
            rlabel.textColor = Color_MainText;
            [view addSubview:rlabel];
            
            UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectZero];
            [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
            moreBtn.titleLabel.font = systemFont(14);
            [moreBtn setTitleColor:Color_SubText forState:UIControlStateNormal];
            [moreBtn setImage:Image(@"you") forState:UIControlStateNormal];
            [moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:moreBtn];
            
            [rlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(20);
                make.bottom.equalTo(view.mas_bottom).offset(-5);
                make.left.equalTo(view).offset(10);
            }];
            
            [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(20);
                make.width.offset(50);
                make.right.equalTo(view).offset(-10);
                make.bottom.equalTo(view.mas_bottom).offset(-5);
            }];
            [moreBtn changeImageAndTitle];
            
            return view;
        }
    }else{
        return [UIView new];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.selectType == 0) {
        if (section == 0) {
            return 0;
        }else{
            return 40;
        }
    }else{
        return 10;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectType != 0) {
        FWMessageAModel *model = self.dataList[indexPath.section];
        [self loadQDetail:model.questionId fromUserId:model.fromUserId messageId:model.messageId];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWDiscoveryFaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FWDiscoveryFaceCell class]) forIndexPath:indexPath];
    FWDiscoveryModel *model = self.dataList[indexPath.row];
    [cell configCellWithData:model];
    
    if (self.dataList.count>=10 && (indexPath.row == self.dataList.count-2) && (self.faceCollectionView.mj_footer.state != MJRefreshStateNoMoreData)) {
        [self.faceCollectionView.mj_footer beginRefreshing];
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [FWDiscoveryFaceCell cellSize];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWDiscoveryModel *model = self.dataList[indexPath.row];
    FWPersonalHomePageVC *vc = [[FWPersonalHomePageVC alloc] init];
    vc.faceId = model.faceId;
    [self.navigationController pushViewController:vc animated:NO];
}


#pragma mark - Custom Delegate
#pragma mark - FWMQReplyCellDelClickDelegate
- (void)FWMQReplyCellDelClickDelegate:(NSString *)answerId
{
    [self deleteMessageWithId:answerId];
}


#pragma mark - Event Response

- (void)moreClick
{
    [self.tabBarController setSelectedIndex:0];
}

#pragma mark - Network Requests

//获取关注face的新品  如果没有新品 就获取推荐的face
- (void)loadData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"page":@"1",
                            @"rows":@"10"
                            };
    [FWDiscoveryManager loadDiscoveryFaceWithParameters:param result:^(NSArray *dataArr, NSString *type) {
        if (type && [type isEqualToString:@"1"]) {
            [self setCollectionView];
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:dataArr];
            [self.faceCollectionView reloadData];
            [self.faceCollectionView.mj_header endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.faceCollectionView.mj_footer setState:MJRefreshStateIdle];
            });
            if (dataArr.count<10) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.faceCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
                });
            }
        }else if((type && [type isEqualToString:@"0"]) || (type && [type isEqualToString:@"-1"])){
            [self setTableView];
        }
    }];
    page = 1;
}

- (void)loadNextPageData
{
    page++;
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":@"10"
                            };
    [FWDiscoveryManager loadDiscoveryFaceWithParameters:param result:^(NSArray *dataArr, NSString *type) {
        if (type && [type isEqualToString:@"1"]) {
            [self.dataList addObjectsFromArray:dataArr];
            [self.faceCollectionView reloadData];
            [self.faceCollectionView.mj_footer endRefreshing];
            if (dataArr.count<10) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.faceCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
                });
            }
        }else if((type && [type isEqualToString:@"0"]) || (type && [type isEqualToString:@"-1"])){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.faceCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
    }];
}

//获取回答列表数据
- (void)loadAnswerList
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"messageType":@"Q",
                            @"page":@"1",
                            @"rows":pageSize
                            };
    [FWMessageManager loadMessageListWithParameters:param result:^(NSArray <FWMessageAModel*> *model,NSString *count) {
        [self.dataList removeAllObjects];
        [self.dataList addObjectsFromArray:model];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer setState:MJRefreshStateIdle];
        });
        if (self.dataList.count == 0) {
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.tableView];
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView: self.tableView];
            
            if (model.count < pageSize.integerValue) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                });
            }
        }
        page = 1;
    }];
}

- (void)loadMoreAnswerData
{
    page++;
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"messageType":@"Q",
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":pageSize
                            };
    [FWMessageManager loadMessageListWithParameters:param result:^(NSArray <FWMessageAModel*> *model,NSString *count) {
        [self.dataList addObjectsFromArray:model];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        if (model.count<pageSize.floatValue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
    }];
}

- (void)deleteMessageWithId:(NSString *)messageId
{
    [UIAlertController js_alertAviewWithTarget:self andAlertTitle:@"确认删除？" andMessage:nil andDefaultActionTitle:@"确认" dHandler:^(UIAlertAction *action) {
        
        NSDictionary *param = @{
                                @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                                @"type":@"2",
                                @"messageId":messageId
                                };
        [FWMessageManager editMessageWithParameters:param result:^(id response) {
            [self loadAnswerList];
        }];
        
    } andCancelActionTitle:@"取消" cHandler:nil completion:nil];
}


- (void)loadQDetail:(NSString*)questionId fromUserId:(NSString *)fromUserId messageId:(NSString *)messageId
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"questionId":questionId,
                            @"page":@"1",
                            @"rows":pageSize
                            };
    [FWMeManager loadQuestionAndAnswerDetailWithParameters:param result:^(FWQAndADetailModel *model,NSString *resultCode) {
        if ([resultCode isEqual:@200]) {
            FWQuestionDetailVC *vc = [FWQuestionDetailVC new];
            vc.questionId = questionId;
            vc.touserId = fromUserId;
            vc.messageId = messageId;
            vc.type = @"1";
            [self.navigationController pushViewController:vc animated:NO];
        }else if ([resultCode isEqual:@4002]){
            [MBProgressHUD showTips:@"该提问已被删除!"];
        }
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setCollectionView
{
    _faceCollectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);//分区内边距
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        [collectionView registerClass:[FWDiscoveryFaceCell class] forCellWithReuseIdentifier:NSStringFromClass([FWDiscoveryFaceCell class])];
        [self.view addSubview:collectionView];
        collectionView;
    });
    __weak typeof (self) weakself = self;
    self.faceCollectionView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    
    self.faceCollectionView.mj_footer = [RefreshCatGifFooter footerWithRefreshingBlock:^{
        [weakself loadNextPageData];
    }];
    [self.faceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(NavigationBar_H + 40);
        make.bottom.mas_equalTo(self.view).offset(-TabBar_H);
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
        make.top.mas_equalTo(self.view).offset(NavigationBar_H + 40);
        make.bottom.mas_equalTo(self.view).offset(-TabBar_H);
    }];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.tag = 30000;
    LhkhWeakSelf(self);
    self.tableView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        if (self.selectType == 0) {
            [weakself loadData];
        }else{
            [weakself loadAnswerList];
        }
    }];
    
    if (self.selectType != 0) {
        self.tableView.mj_footer = [RefreshCatGifFooter footerWithRefreshingBlock:^{
            [weakself loadMoreAnswerData];
        }];
    }
}

#pragma mark - Setters

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


#pragma mark - Getters


@end
