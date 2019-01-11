//
//  LhkhCollectionView.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/11.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "LhkhCollectionView.h"
#import "FWFaceCell.h"
#import "FWRecommendFaceCell.h"
#import "FWPersonalHomePageVC.h"
#import "FWHomeManager.h"
#import "FWDiscoveryManager.h"
#define cellWidth (Screen_W-30)/2
static int page = 1;
@interface LhkhCollectionView()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate,FWFaceModelDelegate,FWRecommendFaceCellDelegate>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) UILongPressGestureRecognizer *longPress;
@property (strong, nonatomic) NSString *vcType;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (assign, nonatomic) NSInteger selectType;
@property (strong, nonatomic) UIButton *topBtn;
@end


@implementation LhkhCollectionView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setCollectionView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame vcType:(NSString*)vctype selectType:(NSInteger)selectType
{
    if (self = [super initWithFrame:frame]) {
        self.vcType = vctype;
        self.selectType = selectType;
        [self setCollectionView];
        if ([self.vcType isEqualToString:@"FWDiscoveryTypeVC"]) {
            [self loadData];
            self.topBtn.hidden = YES;
        }else{
            [self.collectionView.mj_header beginRefreshing];
            self.topBtn.hidden = NO;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(attenAction:) name:@"attenAction" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark - Layout SubViews




#pragma mark - System Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.vcType isEqualToString:@"FWDiscoveryTypeVC"]) {
        FWRecommendFaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FWRecommendFaceCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        FWDiscoveryFaceModel *model = self.dataList[indexPath.row];
        [cell configCellWithData:model indexPath:indexPath];
        return cell;
    }else{
        FWFaceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FWFaceCell class]) forIndexPath:indexPath];
        cell.delegate = self;
        FWFaceModel *model = self.dataList[indexPath.row];
        [cell configCellWithData:model indexPath:indexPath];
        if (self.dataList.count >=20 && (indexPath.row == self.dataList.count-4) && (self.collectionView.mj_footer.state != MJRefreshStateNoMoreData)) {
            [self.collectionView.mj_footer beginRefreshing];
        }
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.vcType isEqualToString:@"FWDiscoveryTypeVC"]) {
        return [FWRecommendFaceCell cellSize];
    }else{
        return [FWFaceCell cellSize];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.vcType isEqualToString:@"FWDiscoveryTypeVC"]) {
        FWDiscoveryFaceModel *model = self.dataList[indexPath.row];
        FWPersonalHomePageVC *vc = [[FWPersonalHomePageVC alloc] init];
        vc.faceId = model.userId;
        vc.indexPath = indexPath;
        [[self superViewController:self].navigationController pushViewController:vc animated:NO];
        
    }else{
        FWFaceModel *model = self.dataList[indexPath.row];
        FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
        vc.faceId = model.userId;
        vc.indexPath = indexPath;
        [[self superViewController:self].navigationController pushViewController:vc animated:NO];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y > 200.0f) {
        self.topBtn.hidden = NO;
    }else{
        self.topBtn.hidden = YES;
    }
}


#pragma mark - Custom Delegate

#pragma mark - FWFaceModelDelegate
-(void)FWFaceModelDelegateClickWithID:(NSString *)userId faceId:(NSString *)faceId isAtten:(NSString *)isAttention indexPath:(NSIndexPath *)indexPath
{
    NSArray *arr = @[indexPath];
    [self.collectionView reloadItemsAtIndexPaths:arr];
}

#pragma mark - FWRecommendFaceCellDelegate
-(void)FWRecommendFaceCellDelegateClickWithID:(NSString *)userId faceId:(NSString *)faceId isAtten:(NSString *)isAttention indexPath:(NSIndexPath *)indexPath
{
    DLog(@"关注");
    NSArray *arr = @[indexPath];
    [self.collectionView reloadItemsAtIndexPaths:arr];
}

#pragma mark - Event Response

- (void)topClick
{
    DLog(@"top");
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)attenAction:(NSNotification*)notif
{
    if (![self.vcType isEqualToString:@"FWDiscoveryTypeVC"]) {
        NSString *isAttention = notif.userInfo[@"isAttention"];
        NSString *type = notif.userInfo[@"type"];
        NSIndexPath *indexPath = notif.object;
        FWFaceModel *model = self.dataList[indexPath.row];
        model.isAttentioned = isAttention;
        if ([type isEqualToString:@"1"]) {
            NSInteger zan = model.cnt.integerValue;
            zan = zan+1;
            model.cnt = [NSString stringWithFormat:@"%ld",zan];
        }else{
            NSInteger zan = model.cnt.integerValue;
            zan = zan-1;
            model.cnt = [NSString stringWithFormat:@"%ld",zan];
        }
        if (indexPath != nil) {
            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        }
    }
}

#pragma mark - Network requests

- (void)loadData
{
    if ([self.vcType isEqualToString:@"FWDiscoveryTypeVC"]) {
        NSDictionary *param = @{
                                @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                                @"page":@"1",
                                @"rows":@"10"
                                };
        [FWDiscoveryManager loadDiscoveryFaceWithParameters:param result:^(NSArray *dataArr, NSString *type) {
            [self.dataList removeAllObjects];
            if (dataArr.count>10) {
                for (int i = 0; i<10; i++) {
                    FWDiscoveryFaceModel *model = dataArr[i];
                    [self.dataList addObject:model];
                }
            }else{
                [self.dataList addObjectsFromArray:dataArr];
            }
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
        }];
    }else{
        NSString *type = @"";
        NSString *code = @"";
        if ([self.vcType isEqualToString:@"FWHomeTypeVC"]) {
            if (self.selectType == 0 ) {
                type = @"N";
            }else{
                type = @"H";
            }
        }else{
            type = @"H";
            code = self.vcType;
        }
        
        NSDictionary *param = @{
                                @"searchType":type,
                                @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                                @"page":@"1",
                                @"rows":pageSize,
                                @"memberClass":code?:@""
                                };
        
        
        [FWHomeManager loadHomeFaceWithParameters:param result:^(NSArray<FWFaceModel *> *model) {
            
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:model];
            [self.collectionView reloadData];
            [self.collectionView.mj_header endRefreshing];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView.mj_footer setState:MJRefreshStateIdle];
            });
            if (self.dataList.count == 0) {
                [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.collectionView];
            }else{
                [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView: self.collectionView];
                
                if (model.count<pageSize.integerValue) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
                    });
                }
            }
        }];
    }
    page = 1;
}

- (void)loadNextPageData
{
    page++;
    NSString *type = @"";
    NSString *code = @"";
    if ([self.vcType isEqualToString:@"FWHomeTypeVC"]) {
        if (self.selectType == 0 ) {
            type = @"N";
        }else{
            type = @"H";
        }
    }else{
        type = @"H";
        code = self.vcType;
    }
    
    NSDictionary *param = @{
                            @"searchType":type,
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":pageSize,
                            @"memberClass":code?:@""
                            };
    [FWHomeManager loadHomeFaceWithParameters:param result:^(NSArray<FWFaceModel *> *model) {
        
        [self.dataList addObjectsFromArray:model];
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
        if (model.count<pageSize.integerValue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
    }];
}

#pragma mark - Public Methods

- (void)refreshData:(NSString *)vctype
{
    self.vcType = vctype;
    [self loadData];
}


#pragma mark - Private Methods

- (void)setCollectionView
{
    _collectionView = ({
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
        if ([self.vcType isEqualToString:@"FWDiscoveryTypeVC"]) {
            collectionView.scrollEnabled = NO;
            [collectionView registerClass:[FWRecommendFaceCell class] forCellWithReuseIdentifier:NSStringFromClass([FWRecommendFaceCell class])];
        }else{
            [collectionView registerClass:[FWFaceCell class] forCellWithReuseIdentifier:NSStringFromClass([FWFaceCell class])];
        }
        [self addSubview:collectionView];
        collectionView;
    });
    
    __weak typeof (self) weakself = self;
    self.collectionView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];

    if (![self.vcType isEqualToString:@"FWDiscoveryTypeVC"]) {
        self.collectionView.mj_footer = [RefreshCatGifFooter footerWithRefreshingBlock:^{
            [weakself loadNextPageData];
        }];
    }
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self);
        make.bottom.equalTo(self);
    }];

    [self addSubview:self.topBtn];
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(35);
        make.right.equalTo(self).offset(-15);
        make.bottom.equalTo(self).offset(-TabBar_H);
    }];
}

#pragma mark 获取当前View所在的ViewController
- (UIViewController *)superViewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}

#pragma mark - Setters

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UIButton *)topBtn
{
    if (_topBtn == nil) {
        _topBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_topBtn setBackgroundImage:Image(@"home_top") forState:UIControlStateNormal];
        [_topBtn addTarget:self action:@selector(topClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _topBtn;
}

#pragma mark - Getters



@end
