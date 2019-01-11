//
//  FWMyFaceVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMyFaceVC.h"
#import "FWWarrantDetailVC.h"
#import "FWFaceCell.h"
#import "FWMyReleasegoodsCell.h"
#import "FWMeManager.h"
#import "FWWarrantManager.h"
#import "LhkhWaterfallLayout.h"
#import "FWFaceReleaseModel.h"
@interface FWMyFaceVC ()<UICollectionViewDelegate,UICollectionViewDataSource,LhkhWaterfallLayoutDelegate,FWMyReleasegoodsCellDelegate>
{
    BOOL _isEdit;
    NSIndexPath *_selectIndexPath;
    NSString *_releasegoodsId;
}
@property (strong, nonatomic)UICollectionView *faceCollectionView;
@property (strong, nonatomic)NSMutableArray *dataList;
//@property (strong, nonatomic)NSMutableArray *releasegoodsId;
@property (strong, nonatomic) UIButton *topBtn;
@end
static int page = 1;
@implementation FWMyFaceVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setCollectionView];
    [self.view addSubview:self.topBtn];
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(35);
        make.right.equalTo(self.view).offset(-15);
        make.bottom.equalTo(self.view).offset(-90);
    }];
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
    return self.dataList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWFaceReleaseModel *model = self.dataList[indexPath.row];
    FWMyReleasegoodsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FWMyReleasegoodsCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    [cell configCellWithData:model isEdit:_isEdit indexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DLog(@"---%ld",indexPath.row);
    FWFaceReleaseModel *model = self.dataList[indexPath.row];
    FWWarrantDetailVC *vc = [FWWarrantDetailVC new];
    vc.releaseGoodsId = model.releaseGoodsId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y > 200.0f) {
        self.topBtn.hidden = NO;
    }else{
        self.topBtn.hidden = YES;
    }
}

#pragma mark - Custom Delegate
#pragma mark - LhkhWaterfallLayoutDelegate
//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(LhkhWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    FWFaceReleaseModel *model = self.dataList[indexPath.row];
    return model.Height.floatValue / model.width.floatValue * itemWidth + 60;
}

#pragma mark - FWMyReleasegoodsCellDelegate
- (void)FWMyReleasegoodsCellDelegateDeleteClick:(NSString*)releasegoodId indexPath:(NSIndexPath *)indexPath
{
    if (_selectIndexPath && _selectIndexPath != indexPath) {
        FWFaceReleaseModel *smodel = self.dataList[_selectIndexPath.row];
        if (smodel.isSelected == YES) {
            smodel.isSelected = !smodel.isSelected;
        }
    }
    FWFaceReleaseModel *model = self.dataList[indexPath.row];
    model.isSelected = !model.isSelected;
    
    if (model.isSelected == YES) {
        _selectIndexPath = indexPath;
        _releasegoodsId = releasegoodId;
    }else{
        _selectIndexPath = nil;
        _releasegoodsId = @"";
    }
    [self.faceCollectionView reloadData];
}

#pragma mark - Event Response

- (void)editClick
{
    if (self.dataList.count>0) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem js_itemWithTitle:@"删除" target:self action:@selector(deleteClick)];
        self->_isEdit = YES;
        [self.faceCollectionView reloadData];
    }
}

- (void)deleteClick
{
    if (_releasegoodsId.length>0 && ![_releasegoodsId isEqualToString:@""]) {
        [UIAlertController js_alertAviewWithTarget:self andAlertTitle:nil andMessage:@"确认删除碑它吗？" andDefaultActionTitle:@"确定" dHandler:^(UIAlertAction *action) {
            [self deleteReleasegoods:self->_releasegoodsId];
        } andCancelActionTitle:@"取消" cHandler:^(UIAlertAction *action) {
            
        } completion:nil];
    }else{
        [MBProgressHUD showTips:@"请选择要删除的碑它额~"];
    }
    
}


- (void)topClick
{
    DLog(@"top");
    [self.faceCollectionView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - Network requests

- (void)loadItemListData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"page":@"1",
                            @"rows":@"10"
                            };
    [FWMeManager loadFaceGoodsListWithParameters:param result:^(NSArray <FWFaceReleaseModel *> *model) {
        [self.faceCollectionView.mj_footer setState:MJRefreshStateIdle];
        [self.faceCollectionView.mj_header endRefreshing];
        [self.dataList removeAllObjects];
        [self.dataList addObjectsFromArray:model];
        self->_releasegoodsId = @"";
        [self.faceCollectionView reloadData];
        if (model.count == 0) {
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.faceCollectionView];
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView: self.faceCollectionView];
        }
        if (model.count <10) {
            [self.faceCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        page = 1;
    }];
}

- (void)loadMoreItemListData
{
    page++;
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":@"10"
                            };
    [FWMeManager loadFaceGoodsListWithParameters:param result:^(NSArray <FWFaceReleaseModel *> *model) {
        [self.faceCollectionView.mj_footer endRefreshing];
        [self.dataList addObjectsFromArray:model];
        [self.faceCollectionView reloadData];
        if (model.count <10) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.faceCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
    }];
}

- (void)deleteReleasegoods:(NSString*)releasegoodsId
{
    NSDictionary *param = @{
                            @"releaseGoodIds":releasegoodsId,
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID]
                            };
    [FWWarrantManager deleteWarrantgoodsWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [MBProgressHUD showTips:response[@"resultDesc"]];
            self->_isEdit = NO;
            self->_selectIndexPath = nil;
            [self loadItemListData];
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem js_itemWithTitle:@"编辑" target:self action:@selector(editClick)];
        }else{
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }
    }];
}

#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setNav
{
    self.navigationItem.title = @"我的碑它";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem js_itemWithTitle:@"编辑" target:self action:@selector(editClick)];
    self->_isEdit = NO;
}

- (void)setCollectionView
{
    _faceCollectionView = ({
        LhkhWaterfallLayout *layout = [LhkhWaterfallLayout waterFallLayoutWithColumnCount:2];
        [layout setColumnSpacing:10 rowSpacing:10 sectionInset:UIEdgeInsetsMake(0, 10, 10, 10)];
        layout.delegate = self;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[FWMyReleasegoodsCell class] forCellWithReuseIdentifier:NSStringFromClass([FWMyReleasegoodsCell class])];
        [self.view addSubview:collectionView];
        collectionView;
    });
    
    [self.faceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (iOS11Later) {
            make.top.equalTo(self.view).offset(NavigationBar_H);
        }else{
            make.top.equalTo(self.view);
        }
        
    }];
    
    LhkhWeakSelf(self);
    self.faceCollectionView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadItemListData];
    }];
    
    self.faceCollectionView.mj_footer = [RefreshCatGifFooter footerWithRefreshingBlock:^{
        [weakself loadMoreItemListData];
    }];
}


#pragma mark - Setters

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

//- (NSMutableArray *)releasegoodsId
//{
//    if (_releasegoodsId == nil) {
//        _releasegoodsId = [NSMutableArray array];
//    }
//    return _releasegoodsId;
//}

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
