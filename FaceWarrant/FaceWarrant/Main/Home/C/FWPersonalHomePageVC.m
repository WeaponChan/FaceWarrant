//
//  FWPersonalHomePageVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/5.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWPersonalHomePageVC.h"
#import "FWWarrantDetailVC.h"
#import "FWBrandVC.h"
#import "FWFaceHomeHeaderView.h"
#import "FWFaceLibraryHomeCell.h"
#import "FWFaceLibraryManager.h"
#import "FWFaceHomeModel.h"
#import "FWFaceReleaseModel.h"
#define ViewH 320*Screen_W/375
@interface FWPersonalHomePageVC ()<FWFaceHomeHeaderViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,LhkhWaterfallLayoutDelegate, UIScrollViewDelegate>
{
    NSString *_sortType;
}
@property (strong, nonatomic) FWFaceHomeHeaderView *headerView;
@property (strong, nonatomic) UICollectionView *faceCollectionView;
@property (strong, nonatomic) NSMutableArray *faceList;
@property (strong, nonatomic) FWFaceHomeModel *model;
@property (assign, nonatomic) CGFloat marginTop;
@property (strong, nonatomic) UIView *naviView;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UILabel *navTitle;
@property (strong, nonatomic) UIButton *topBtn;
@property (strong, nonatomic) UIView *blankView;
@end
static int page = 1;
@implementation FWPersonalHomePageVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setCollectionView];
    [self setNaviView];
    [self setSubView];
    [self setBlankView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.faceCollectionView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"releasePlayerDealloc" object:nil];
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
    if (self.faceList.count>=10 && (indexPath.row == self.faceList.count-2) && (self.faceCollectionView.mj_footer.state != MJRefreshStateNoMoreData)) {
        [self.faceCollectionView.mj_footer beginRefreshing];
    }
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
    FWFaceReleaseModel *model = self.faceList[indexPath.row];
    FWWarrantDetailVC *vc = [FWWarrantDetailVC new];
    vc.releaseGoodsId = model.releaseGoodsId;
    [self.navigationController pushViewController:vc animated:NO];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (self.marginTop != scrollView.contentInset.top) {
        self.marginTop = scrollView.contentInset.top;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    offsetY = MIN(offsetY, 0);
    offsetY = MAX(-ViewH, offsetY);
    self.naviView.backgroundColor = [Color_MainBg colorWithAlphaComponent:(ViewH + offsetY) / ViewH];
    if (offsetY == -ViewH) {
        [self.backBtn setBackgroundImage:Image(@"back_white") forState:UIControlStateNormal];
        self.navTitle.text = @"";
    }else{
        [self.backBtn setBackgroundImage:Image(@"back_black") forState:UIControlStateNormal];
        self.navTitle.text = self.model.faceName;
    }
    
    if (scrollView.contentOffset.y > 200.0f) {
        self.topBtn.hidden = NO;
    }else{
        self.topBtn.hidden = YES;
    }
}


#pragma mark - Custom Delegate
#pragma mark - FWFaceHomeHeaderViewDelegate
-(void)FWFaceHomeHeaderViewDelegateMoreBrandClick
{
    FWBrandVC *vc = [FWBrandVC new];
    vc.faceId = self.model.faceId;
    vc.searchCondition = self.searchText;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)FWFaceHomeHeaderViewDelegateMoregoodsClick:(NSString *)sortType
{
    _sortType = sortType;
    [self loadCollectionData];
}

#pragma mark - Event Response

- (void)backClick
{
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)topClick
{
    DLog(@"top");
    [self.faceCollectionView setContentOffset:CGPointMake(0, -ViewH) animated:YES];
}


#pragma mark - Network requests

- (void)loadData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"faceId":self.faceId
                            };
    [FWFaceLibraryManager loadFaceHomeDataWithParameters:param result:^(FWFaceHomeModel *model,NSString *resultCode,NSString *resultDesc) {
        if ([resultCode isEqual:@200]) {
            self.model = model;
        }else{
            [MBProgressHUD showTips:resultDesc];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
    }];
}

- (void)loadCollectionData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"faceId":self.faceId,
                            @"brandId":_brandId?:@"",
                            @"sortType":_sortType,
                            @"searchCondition":_searchText?:@"",
                            @"page":@"1",
                            @"rows":@"10"
                            };
    [FWFaceLibraryManager loadFaceHomeReleasegoodsDataWithParameters:param result:^(NSArray<FWFaceReleaseModel *> *model) {
        [self.faceCollectionView.mj_header endRefreshing];
        [self.faceCollectionView.mj_footer setState:MJRefreshStateIdle];
        [self.faceList removeAllObjects];
        [self.faceList addObjectsFromArray:model];
        [self.headerView configCellWithModel:self.model];
        [self.faceCollectionView reloadData];
        if (model.count < 10) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.faceCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
        
        if (model.count == 0) {
            self.blankView.hidden = NO;
            self.faceCollectionView.scrollEnabled = NO;
        }else{
            self.blankView.hidden = YES;
            self.faceCollectionView.scrollEnabled = YES;
        }
        page = 1;
    }];
}

- (void)loadMoreData
{
    page ++;
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"faceId":self.faceId,
                            @"sortType":_sortType,
                            @"brandId":_brandId?:@"",
                            @"searchCondition":_searchText?:@"",
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":@"10"
                            };
    [FWFaceLibraryManager loadFaceHomeReleasegoodsDataWithParameters:param result:^(NSArray<FWFaceReleaseModel *> *model) {
        [self.faceCollectionView.mj_footer endRefreshing];
        [self.faceList addObjectsFromArray:model];
        [self.faceCollectionView reloadData];
        if (model.count < 10) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.faceCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
    }];
}

#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setNaviView
{
    self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, NavigationBar_H)];
    self.naviView.backgroundColor = [Color_MainBg colorWithAlphaComponent:0];
    [self.view addSubview:self.naviView];
    self.backBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.backBtn setBackgroundImage:Image(@"back_white") forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [self.naviView addSubview: self.backBtn];
    
    self.navTitle = [[UILabel alloc] initWithFrame:CGRectZero];
    self.navTitle.font = systemFont(18);
    self.navTitle.textColor = Color_Black;
    self.navTitle.textAlignment = NSTextAlignmentCenter;
    [self.naviView addSubview:self.navTitle];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(25);
        make.left.equalTo(self.naviView).offset(15);
        make.top.equalTo(self.naviView).offset(StatusBar_H+10);
    }];
    
    [self.navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.left.equalTo(self.naviView).offset(45);
        make.centerY.equalTo(self.backBtn.mas_centerY);
        make.centerX.equalTo(self.naviView.mas_centerX);
    }];
}

- (void)setSubView
{
    self.headerView = [[FWFaceHomeHeaderView alloc] initFaceHomeHeaderViewWithFrame:CGRectMake(0, -ViewH, Screen_W, ViewH)];
    self.headerView.delegate = self;
    self.headerView.indexPath = self.indexPath;
    self.faceCollectionView.contentInset = UIEdgeInsetsMake(ViewH, 0, 0, 0);
    [self.faceCollectionView addSubview:self.headerView];
    [self.faceCollectionView setContentOffset:CGPointMake(0, -ViewH)];
    [self.view addSubview:self.topBtn];
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(35);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-90);
    }];
}

- (void)setCollectionView
{
    _sortType = @"0";
    [USER_DEFAULTS setObject:_sortType forKey:UD_SortType];
    [self.view addSubview:self.faceCollectionView];
    [self.faceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(-StatusBar_H);
    }];
}


- (void)setBlankView
{
    self.blankView = [[UIView alloc] initWithFrame:CGRectZero];
    self.blankView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.blankView];
    self.blankView.hidden = YES;
    
    UIImageView *blankImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    blankImg.image = Image(@"tip_Content");
    [self.blankView addSubview:blankImg];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"空空如也~";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = systemFont(14);
    label.textColor = Color_SubText;
    [self.blankView addSubview:label];
    
    
    [self.blankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(350);
    }];
    
    [blankImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(150);
        make.top.equalTo(self.blankView).offset(50);
        make.centerX.equalTo(self.blankView.mas_centerX);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(blankImg.mas_bottom).offset(25);
        make.centerX.equalTo(self.blankView.mas_centerX);
        make.left.right.equalTo(self.blankView);
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
        _faceCollectionView.backgroundColor = [[UIColor colorWithHexString:@"F4F4F4"] colorWithAlphaComponent:1];
        _faceCollectionView.dataSource = self;
        _faceCollectionView.delegate = self;
        _faceCollectionView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [_faceCollectionView registerClass:[FWFaceLibraryHomeCell class] forCellWithReuseIdentifier:NSStringFromClass([FWFaceLibraryHomeCell class])];
        _faceCollectionView.showsVerticalScrollIndicator = NO;
        LhkhWeakSelf(self);
        _faceCollectionView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
            [weakself loadData];
            [weakself loadCollectionData];
        }];
        _faceCollectionView.mj_header.ignoredScrollViewContentInsetTop = ViewH;
        _faceCollectionView.mj_footer = [RefreshCatGifFooter footerWithRefreshingBlock:^{
            [weakself loadMoreData];
        }];
    }
    
    return _faceCollectionView;
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

- (NSMutableArray*)faceList
{
    if (_faceList == nil) {
        _faceList = [NSMutableArray array];
    }
    return _faceList;
}


#pragma mark - Getters




@end
