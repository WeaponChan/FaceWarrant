//
//  FWMyCollectVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMyCollectVC.h"
#import "FWMyCollectionCell.h"
#import "FWMeManager.h"
#import "FWMyCollectionModel.h"
#import "FWWarrantDetailVC.h"
#import "FWWarrantManager.h"
#import "LhkhWaterfallLayout.h"
@interface FWMyCollectVC ()<UICollectionViewDelegate,UICollectionViewDataSource,LhkhWaterfallLayoutDelegate>
{
    BOOL _isEdit;
    BOOL _isSelect;
}
@property (strong, nonatomic)UICollectionView *faceCollectionView;
@property (strong, nonatomic)NSMutableArray *itemList;
@property (strong, nonatomic)NSMutableArray *releasegoodsId;
@property (strong, nonatomic) UIButton *topBtn;
@end
static int page = 1;
@implementation FWMyCollectVC

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


#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码


#pragma mark - System Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.itemList.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWMyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FWMyCollectionCell class]) forIndexPath:indexPath];
    FWMyCollectionModel *model = self.itemList[indexPath.row];
    model.isSel = NO;
    [cell configCellWithData:model isEdit:self->_isEdit indexPath:indexPath];
    LhkhWeakSelf(cell);
    cell.selectblock = ^() {
        model.isSel = !model.isSel;
        if (model.isSel == YES) {
            [weakcell.delBtn setImage:Image(@"checkBoxSel") forState:UIControlStateNormal];
            [self.releasegoodsId addObject:model.releaseGoodsId];
        }else{
            [weakcell.delBtn setImage:Image(@"checkBox") forState:UIControlStateNormal];
            [self.releasegoodsId removeObject:model.releaseGoodsId];
        }
    };
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y > 200.0f) {
        self.topBtn.hidden = NO;
    }else{
        self.topBtn.hidden = YES;
    }
}

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(LhkhWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    FWMyCollectionModel *model = self.itemList[indexPath.row];
    return model.height.floatValue / model.width.floatValue * itemWidth +60;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWMyCollectionModel *model = self.itemList[indexPath.row];
    if ([model.collectStatus isEqualToString:@"2"]) {
        [MBProgressHUD showTips:@"此碑它已取消了额~"];
    }else{
        FWWarrantDetailVC *vc = [FWWarrantDetailVC new];
        vc.releaseGoodsId = model.releaseGoodsId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Custom Delegate



#pragma mark - Event Response

- (void)editClick
{
    if (self.itemList.count > 0) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem js_itemWithTitle:@"删除" target:self action:@selector(deleteClick)];
        self->_isEdit = YES;
        [self.faceCollectionView reloadData];
    }
}

- (void)deleteClick
{
    if (self.releasegoodsId.count>0) {
        NSString *releaseIds = [self.releasegoodsId componentsJoinedByString:@","];
        [UIAlertController js_alertAviewWithTarget:self andAlertTitle:nil andMessage:@"确认删除此心愿吗？" andDefaultActionTitle:@"确定" dHandler:^(UIAlertAction *action) {
            [self deleteCollection:releaseIds];
        } andCancelActionTitle:@"取消" cHandler:^(UIAlertAction *action) {
            
        } completion:nil];
    }else{
        [MBProgressHUD showTips:@"请选择要删除的心愿额~"];
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
    [FWMeManager loadCollectionListWithParameters:param result:^(NSArray <FWMyCollectionModel *> *model) {
        [self.faceCollectionView.mj_footer setState:MJRefreshStateIdle];
        [self.itemList removeAllObjects];
        [self.itemList addObjectsFromArray:model];
        [self.faceCollectionView reloadData];
        if (self.itemList.count == 0) {
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoFavourite toView:self.faceCollectionView];
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView: self.faceCollectionView];
        }
        [self.faceCollectionView.mj_header endRefreshing];
        if (model.count < 10) {
            [self.faceCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        page = 1;
    }];
}

- (void)loadMoreItemListData
{
    page ++;
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":@"10"
                            };
    [FWMeManager loadCollectionListWithParameters:param result:^(NSArray <FWMyCollectionModel *> *model) {
        [self.itemList addObjectsFromArray:model];
        [self.faceCollectionView reloadData];
        [self.faceCollectionView.mj_footer endRefreshing];
        if (model.count < 10) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.faceCollectionView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
    }];
}

- (void)deleteCollection:(NSString*)releasegoodsId
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"isCollect":@"1",
                            @"releaseGoodsId":releasegoodsId
                            };
    
    [FWWarrantManager actionWarrantCollectedWithParameter:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            self->_isEdit = NO;
            [self loadItemListData];
            [self.releasegoodsId removeAllObjects];
            [MBProgressHUD showSuccess:response[@"resultDesc"]];
            self.navigationItem.rightBarButtonItem = [UIBarButtonItem js_itemWithTitle:@"编辑" target:self action:@selector(editClick)];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}


#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setNav
{
    self.navigationItem.title = @"我的心愿单";
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
        [collectionView registerClass:[FWMyCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([FWMyCollectionCell class])];
        [self.view addSubview:collectionView];
        collectionView;
    });
    
    [self.faceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        if (iOS11Later) {
            make.top.mas_equalTo(self.view).offset(NavigationBar_H);
        }else{
            make.top.mas_equalTo(self.view);
        }
    }];
    LhkhWeakSelf(self);
    self.faceCollectionView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadItemListData];
    }];
    
    self.faceCollectionView.mj_footer = [RefreshCatGifFooter footerWithRefreshingBlock:^{
        [weakself loadMoreItemListData];
    }];
    [self.faceCollectionView.mj_header beginRefreshing];
}


#pragma mark - Setters

- (NSMutableArray *)itemList
{
    if (_itemList == nil) {
        _itemList = [NSMutableArray array];
    }
    return _itemList;
}

- (NSMutableArray *)releasegoodsId
{
    if (_releasegoodsId == nil) {
        _releasegoodsId = [NSMutableArray array];
    }
    return _releasegoodsId;
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
