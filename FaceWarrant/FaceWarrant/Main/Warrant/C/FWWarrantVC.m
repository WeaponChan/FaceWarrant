//
//  FWWarrantVC.m
//  FaceWarrant
//
//  Created by LHKH on 2018/6/8.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantVC.h"
#import "FWWarrantDetailVC.h"
#import "FWWarrantInfoVC.h"

#import "LhkhWaterfallLayout.h"
#import "FWMyWarrantCell.h"
#import "LhkhImagePickerController.h"
#import "FWWarrantItemView.h"

#import "FWWindowManager.h"
#import "FWWarrantManager.h"
#import "FWOSSConfigManager.h"
#import "FWFaceReleaseModel.h"
#import "LhkhAliyunShortVedioManager.h"

@interface FWWarrantVC ()<UICollectionViewDelegate,UICollectionViewDataSource,LhkhWaterfallLayoutDelegate,FWWarrantItemViewDelegate>
{
    UIImage *_fImage;
}
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;//毛玻璃视图
@property (strong, nonatomic) FWWarrantItemView *warrantView;
@property (strong, nonatomic) UIButton *topBtn;
@end
static int page = 1;
@implementation FWWarrantVC

#pragma mark - Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setCollectionView];
    [self setAddView];
    [self setItemView];
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    
    
    //回到顶端
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
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self loadItemListData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"releasePlayerDealloc" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_CropPhotoImageSure object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"Notif_ChaPop" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name: Notif_CropPhotoImageSure object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name: Notif_CropCameraImageSure object: nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"releasePlayerDealloc" object:nil];
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
    FWMyWarrantCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FWMyWarrantCell class]) forIndexPath:indexPath];
    FWFaceReleaseModel *model = self.dataList[indexPath.row];
    [cell configCellWithModel:model indexPath:indexPath];
    if (self.dataList.count >=10 && (indexPath.row == self.dataList.count-6)) {
        [self.collectionView.mj_footer beginRefreshing];
    }
    return cell;
}

//根据item的宽度与indexPath计算每一个item的高度
- (CGFloat)waterfallLayout:(LhkhWaterfallLayout *)waterfallLayout itemHeightForWidth:(CGFloat)itemWidth atIndexPath:(NSIndexPath *)indexPath {
    //根据图片的原始尺寸，及显示宽度，等比例缩放来计算显示高度
    FWFaceReleaseModel *model = self.dataList[indexPath.row];
    return model.Height.floatValue / model.width.floatValue * itemWidth;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWFaceReleaseModel *model = self.dataList[indexPath.row];
    FWWarrantDetailVC *vc = [FWWarrantDetailVC new] ;
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

#pragma mark - FWWarrantItemViewDelegate
- (void)FWWarrantItemViewDelegateClickWithTag:(NSInteger)tag
{
    self.visualEffectView.hidden = YES;
    [self.warrantView removeFromSuperview];
    self.tabBarController.tabBar.hidden = NO;
    if (tag == 0) {
        self.visualEffectView.hidden = self.warrantView.hidden = YES;
    }else if (tag == 1) {
        [self selectPhoto:@"1"];
    }else if(tag == 2){
        [self selectPhoto:@"2"];
    }else if (tag == 3) {
        [[LhkhAliyunShortVedioManager shareManager] aliyunShortVedio:self];
//        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    }
}

#pragma mark - Event Response

- (void)topClick
{
    DLog(@"top");
    [self.collectionView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)addWarrant
{
    self.warrantView.hidden = self.visualEffectView.hidden = NO;
    [self.tabBarController.view addSubview:self.warrantView];
    [self.warrantView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(210);
        make.left.right.equalTo(self.tabBarController.view);
        make.bottom.equalTo(self.tabBarController.view);
    }];
}

- (void)singleTapDetected
{
    self.tabBarController.tabBar.hidden = NO;
    self.warrantView.hidden = self.visualEffectView.hidden = YES;
}

- (void)notificationSure: (NSNotification *)notification
{
    FWWarrantInfoVC *vc = [FWWarrantInfoVC new];
    vc.image = notification.object;
    vc.type = @"0";
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)chaClick
{
    self.tabBarController.tabBar.hidden = YES;
    [self addWarrant];
}

#pragma mark - Network requests

- (void)loadItemListData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"page":@"1",
                            @"rows":@"10"
                            };
    [FWWarrantManager loadWarrantListWithParameters:param result:^(NSArray <FWFaceReleaseModel *> *model) {
        
        [self.collectionView.mj_header endRefreshing];
        
        if (model.count<10) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }else{
            [self.collectionView.mj_footer setState:MJRefreshStateIdle];
        }
        
        [self.dataList removeAllObjects];
        [self.dataList addObjectsFromArray:model];
        [self.collectionView reloadData];
        
        if (model.count == 0) {
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.collectionView];
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.collectionView];
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
    [FWWarrantManager loadWarrantListWithParameters:param result:^(NSArray <FWFaceReleaseModel *> *model) {
        
        [self.collectionView.mj_footer endRefreshing];
        if (model.count<10) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
        
        [self.dataList addObjectsFromArray:model];
        [self.collectionView reloadData];
    }];
}


#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setNav
{
    self.navigationItem.title = @"我的碑它";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chaClick) name: @"Notif_ChaPop" object: nil];
}

- (void)setCollectionView
{
    _collectionView = ({

        LhkhWaterfallLayout *layout = [LhkhWaterfallLayout waterFallLayoutWithColumnCount:3];
        [layout setColumnSpacing:5 rowSpacing:5 sectionInset:UIEdgeInsetsMake(0, 5, 5, 5)];
        layout.delegate = self;
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor colorWithHexString:@"F4F4F4"];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.showsVerticalScrollIndicator = NO;
        [collectionView registerClass:[FWMyWarrantCell class] forCellWithReuseIdentifier:NSStringFromClass([FWMyWarrantCell class])];
        [self.view addSubview:collectionView];
        collectionView;
    });

    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(TabBar_H);
    }];
    LhkhWeakSelf(self);
    self.collectionView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadItemListData];
    }];
    self.collectionView.mj_footer = [RefreshCatGifFooter footerWithRefreshingBlock:^{
        [weakself loadMoreItemListData];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)setAddView
{
    UIButton *addbtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [self.view addSubview:addbtn];
    [addbtn setBackgroundImage:Image(@"warrant_publish") forState:UIControlStateNormal];
    [addbtn addTarget:self action:@selector(addWarrant) forControlEvents:UIControlEventTouchUpInside];
    [addbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(60);
        make.bottom.equalTo(self.view).offset(-TabBar_H-100);
        make.right.equalTo(self.view).offset(-10);
    }];
}


- (void)setItemView
{
    //实现模糊效果
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //毛玻璃视图
    self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    self.visualEffectView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
    self.visualEffectView.alpha = 0.5;
    self.visualEffectView.hidden = YES;
    [self.view addSubview:self.visualEffectView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.visualEffectView setUserInteractionEnabled:YES];
    [self.visualEffectView addGestureRecognizer:singleTap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSure:) name: Notif_CropPhotoImageSure object: nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSure:) name: Notif_CropCameraImageSure object: nil];
}


- (void)selectPhoto:(NSString*)type
{
    LhkhImagePickerController *vc = [[LhkhImagePickerController alloc]init];
    vc.seleType = type;
    vc.view.backgroundColor = [UIColor clearColor];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:vc  animated:NO completion:^(void)
     {
         vc.view.superview.backgroundColor = [UIColor clearColor];
     }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Setters

- (NSMutableArray*)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (FWWarrantItemView*)warrantView
{
    if (_warrantView == nil) {
        _warrantView = [FWWarrantItemView shareWarrantItemView];
        _warrantView.delegate = self;
    }
    return _warrantView;
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
