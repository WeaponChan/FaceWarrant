//
//  FWFaceLibrarySearchTypeVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/14.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFaceLibrarySearchTypeVC.h"
#import "FWFacelibrarySearchCell.h"
#import "FWFacelibrarySearchFaceModel.h"
#import "FWPersonalHomePageVC.h"
#import "FWSearchManager.h"
@interface FWFaceLibrarySearchTypeVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
{
    NSString *_brandId;
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataList;
@end

static int page = 1;
@implementation FWFaceLibrarySearchTypeVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCollectionView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(brandClick:) name:Notif_BrandClick object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:Notif_BrandClick object:nil];
}

#pragma mark - Layout SubViews
//11.29换新的框架 替换掉原来适配的代码

#pragma mark - System Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWFacelibrarySearchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FWFacelibrarySearchCell class]) forIndexPath:indexPath];
    FWFacelibrarySearchFaceModel *model = self.dataList[indexPath.row];
    [cell configCellWithData:model indexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [FWFacelibrarySearchCell cellSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWFacelibrarySearchFaceModel *model = self.dataList[indexPath.row];
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.faceId = model.faceId;
    vc.searchText = self.searchText;
    vc.brandId = _brandId;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - Custom Delegate


#pragma mark - Event Response

- (void)brandClick:(NSNotification*)notif
{
    _brandId = [[notif userInfo] valueForKey:@"brandId"];
    _groupsId = [[notif userInfo] valueForKey:@"groupId"];
    _searchText = [[notif userInfo] valueForKey:@"searchText"];
    [self loadFaceData];
}

#pragma mark - Network Requests

- (void)loadFaceData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"searchCondition":self.searchText,
                            @"groupsId":self.groupsId,
                            @"brandId":_brandId?:@"",
                            @"page":@"1",
                            @"rows":pageSize
                            };
    
    [FWSearchManager loadFaceLibrarySearchDataConditionWithParameters:param result:^(NSArray<FWFacelibrarySearchFaceModel *> *model) {
        [self.collectionView.mj_footer setState:MJRefreshStateIdle];
        [self.dataList removeAllObjects];
        [self.dataList addObjectsFromArray:model];
        [self.collectionView reloadData];
        [self.collectionView.mj_header endRefreshing];
        if (model.count < pageSize.floatValue) {
            [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        if (self.dataList.count == 0) {
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.collectionView];
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.collectionView];
        }
        page = 1;
    }];
}

- (void)loadMoreFaceData
{
    page++;
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"searchCondition":self.searchText,
                            @"groupsId":self.groupsId,
                            @"brandId":_brandId?:@"",
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":pageSize
                            };
    
    [FWSearchManager loadFaceLibrarySearchDataConditionWithParameters:param result:^(NSArray<FWFacelibrarySearchFaceModel *> *model) {
        [self.dataList addObjectsFromArray:model];
        [self.collectionView reloadData];
        [self.collectionView.mj_footer endRefreshing];
        if (model.count < pageSize.floatValue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
    }];
}

#pragma mark - Public Methods


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
        [collectionView registerClass:[FWFacelibrarySearchCell class] forCellWithReuseIdentifier:NSStringFromClass([FWFacelibrarySearchCell class])];
        [self.view addSubview:collectionView];
        collectionView;
    });
    
    LhkhWeakSelf(self);
    self.collectionView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadFaceData];
    }];
    self.collectionView.mj_footer = [RefreshCatGifFooter footerWithRefreshingBlock:^{
        [weakself loadMoreFaceData];
    }];
    [self.collectionView.mj_header beginRefreshing];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NavigationBar_H+140);
    }];
}

#pragma mark - Setters
- (UICollectionView*)collectionView
{
    if (_collectionView == nil) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero];
    }
    return _collectionView;
}

- (NSMutableArray*)dataList
{
    if (_dataList == nil) {
        _dataList = [[NSMutableArray alloc] init];
    }
    return _dataList;
}

#pragma mark - Getters


@end
