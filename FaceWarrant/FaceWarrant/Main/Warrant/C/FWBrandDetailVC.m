//
//  FWBrandDetailVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBrandDetailVC.h"
#import "FWWarrantDetailVC.h"
#import "FWBrandHeaderView.h"
#import "FWFaceLibraryHomeCell.h"
#import "LhkhWaterfallLayout.h"
#import "FWHomeManager.h"
#import "FWBrandDetailModel.h"
#import "FWFaceReleaseModel.h"

#define cellH 220*Screen_W/375
@interface FWBrandDetailVC ()<UICollectionViewDelegate,UICollectionViewDataSource,LhkhWaterfallLayoutDelegate>
@property (strong, nonatomic) UICollectionView *faceCollectionView;
@property (strong, nonatomic) FWBrandHeaderView *headerView;
@property (strong, nonatomic) NSMutableArray *faceList;
@property (strong, nonatomic) FWBrandDetailModel *model;
@end
static int page = 1;
@implementation FWBrandDetailVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCollectionView];
    [self setSubView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.faceCollectionView.mj_header beginRefreshing];
}

#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码

#pragma mark - System Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.faceList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWFaceReleaseModel *model = self.faceList[indexPath.row];
    FWFaceLibraryHomeCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FWFaceLibraryHomeCell class]) forIndexPath:indexPath];
    [cell configCellWithData:model indexPath:indexPath];
    return cell;
}

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(LhkhWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    FWFaceReleaseModel *model = self.faceList[indexPath.row];
    return model.Height.floatValue / model.width.floatValue * itemWidth +50;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"---->%ld",indexPath.row);
    FWFaceReleaseModel *model = self.faceList[indexPath.row];
    FWWarrantDetailVC *vc = [FWWarrantDetailVC new];
    vc.releaseGoodsId = model.releaseGoodsId;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - Custom Delegate


#pragma mark - Event Response


#pragma mark - Network Requests
- (void)loadData
{
    NSDictionary *param = @{@"brandId":self.brandId};
    [FWHomeManager loadGoodsBrandDetailWithParameter:param result:^(FWBrandDetailModel * model) {
        self.model = model;
        [self loadGoodsData];
    }];
}

- (void)loadGoodsData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"brandId":self.brandId,
                            @"faceId":self.faceId,
                            @"sortType":[USER_DEFAULTS objectForKey:UD_SortType],
                            @"searchCondition":self.searchCondition?:@"",
                            @"page":@"1",
                            @"rows":@"10"
                            };
    [FWHomeManager loadGoodsBrandDetailListWithParameter:param result:^(NSArray <FWFaceReleaseModel*> *model) {
        [self.faceList removeAllObjects];
        [self.faceList addObjectsFromArray:model];
        [self.faceCollectionView reloadData];
        [self.headerView configCellWithModel:self.model];
        [self.faceCollectionView.mj_header endRefreshing];
        if (model.count < 10) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.faceCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
        page = 1;
    }];
    
}

- (void)loadMoreData
{
    page ++;
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"brandId":self.brandId,
                            @"faceId":self.faceId,
                            @"sortType":[USER_DEFAULTS objectForKey:UD_SortType],
                            @"searchCondition":self.searchCondition?:@"",
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":@"10"
                            };
    [FWHomeManager loadGoodsBrandDetailListWithParameter:param result:^(NSArray <FWFaceReleaseModel*> *model) {
        [self.faceList addObjectsFromArray:model];
        [self.faceCollectionView reloadData];
        [self.faceCollectionView.mj_footer endRefreshing];
        if (model.count < 10) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.faceCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods

- (void)setSubView
{
    self.headerView = [[FWBrandHeaderView alloc] initFaceBrandHeaderViewWithFrame:CGRectMake(0, -cellH, Screen_W, cellH)];
    self.faceCollectionView.contentInset = UIEdgeInsetsMake(cellH, 0, 0, 0);
    [self.faceCollectionView addSubview:self.headerView];
    [self.faceCollectionView setContentOffset:CGPointMake(0, -cellH)];
}

- (void)setCollectionView
{
    [self.view addSubview:self.faceCollectionView];
    [self.faceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(TabBar_H+100);
        make.top.mas_equalTo(self.view).offset(-StatusBar_H);
    }];
}

#pragma mark - Setters

- (UICollectionView*)faceCollectionView
{
    if (_faceCollectionView == nil) {
        LhkhWaterfallLayout *layout = [LhkhWaterfallLayout waterFallLayoutWithColumnCount:2];
        [layout setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(0, 10, 10, 10)];
        layout.delegate = self;
        _faceCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _faceCollectionView.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
        _faceCollectionView.dataSource = self;
        _faceCollectionView.delegate = self;
        [_faceCollectionView registerClass:[FWFaceLibraryHomeCell class] forCellWithReuseIdentifier:NSStringFromClass([FWFaceLibraryHomeCell class])];
        
        LhkhWeakSelf(self);
        _faceCollectionView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
            [weakself loadData];
        }];
        _faceCollectionView.mj_header.ignoredScrollViewContentInsetTop = cellH;
        _faceCollectionView.mj_footer = [RefreshCatGifFooter footerWithRefreshingBlock:^{
            [weakself loadMoreData];
        }];
    }
    return _faceCollectionView;
}

- (NSMutableArray*)faceList
{
    if (_faceList == nil) {
        _faceList = [NSMutableArray array];
    }
    return _faceList;
}

#pragma mark - Getters


@end
