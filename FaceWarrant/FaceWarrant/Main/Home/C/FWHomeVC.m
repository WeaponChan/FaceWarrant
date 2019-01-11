//
//  FWHomeVC.m
//  FaceWarrant
//
//  Created by LHKH on 2018/6/8.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWHomeVC.h"
#import "FWSearchView.h"
#import "FWSearchVC.h"
#import "FWHomeTypeVC.h"
#import "LhkhButton.h"
#import "FWMapVC.h"
#import "FWHomeManager.h"
#import "APPVersionManager.h"
@interface FWHomeVC ()<UIScrollViewDelegate,FWSearchViewDelegate>
{
    NSString *_isShow;
}
@property (strong, nonatomic) UIView *menuView;
@property (strong, nonatomic) UIView *titlesView;
@property (strong, nonatomic) LhkhButton *selectedButton;
@property (strong, nonatomic) UIView *sliderView;
@property (strong, nonatomic) UIScrollView *contentView;
@property (strong, nonatomic) FWSearchView *searchView;
@property (strong, nonatomic) FWHomeTypeVC *newestVC;//最新
@property (strong, nonatomic) FWHomeTypeVC *recommendVC;//推荐
@property (strong, nonatomic) FWHomeTypeVC *hotVC;//热门
@property (strong, nonatomic) NSMutableArray *classifyArr;
@property (strong, nonatomic) UIButton *topBtn;

@end

@implementation FWHomeVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setupChildViewControllers];
    [self setUpTitleView];
    [self setupContentView];
    [self setMenuView];
    [self loadAppStoreVersion];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
    [self.searchView.searchText resignFirstResponder];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.menuView.hidden = YES;
}

#pragma mark - Layout SubViews




#pragma mark - System Delegate

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;
    vc.view.height = scrollView.height;
    [scrollView addSubview:vc.view];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView  {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    //点击标题按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self  titleClick:self.titlesView.subviews[index]];
}


#pragma mark - Custom Delegate

#pragma mark - FWSearchViewDelegate

//- (void)FWSearchViewDelegateBtnClick
//{
//    FWSearchVC *vc = [FWSearchVC new];
//    vc.typeStr = @"FWHomeVC";
//    [self.navigationController pushViewController:vc animated:NO];
//}

- (void)FWSearchViewDelegateVoiceClick
{
    DLog(@"----");
//    FWSearchVC *vc = [FWSearchVC new];
//    vc.typeStr = @"FWHomeVC";
//    vc.yuyinType = @"1";
//    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark - Event Response

- (void)topClick
{
    DLog(@"top");
}

- (void)mapActionClick
{
    self.menuView.hidden = !self.menuView.hidden;
}


- (void)nearbyClick
{
    self.menuView.hidden = !self.menuView.hidden;
    FWMapVC *vc = [FWMapVC new];
    vc.selectType = @"附近商场";
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)brandClick
{
    self.menuView.hidden = !self.menuView.hidden;
    FWMapVC *vc = [FWMapVC new];
    vc.selectType = @"品牌实体店";
    [self.navigationController pushViewController:vc animated:NO];
    
}


#pragma mark 标题栏每个按钮的点击事件
-(void)titleClick:(LhkhButton *)button{
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    [UIView animateWithDuration:0.25 animations:^{
        self.sliderView.width = button.titleLabel.width;
        self.sliderView.centerX = button.centerX;
    }];
    CGPoint offset = self.contentView.contentOffset;
    offset.x = button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
    self.searchView.typeStr = self.selectedButton.titleLabel.text;
}


- (void)gotoWarrantDetail:(NSNotification*)notif
{
    DLog(@"dfhkakfhakfdhakfn");
}

#pragma mark - Network requests

- (void)loadData
{
    [FWHomeManager loadHomeClassifyWithParameters:nil result:^(NSArray<FWHomeClassifyModel *> *model) {
        [self.classifyArr removeAllObjects];
        [self.classifyArr addObjectsFromArray:model];
    }];
}

#pragma mark - Public Methods



 
#pragma mark - Private Methods

- (void)setNav
{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem js_itemWithImage:@"nearby" highImage:@"nearby" target:self action:@selector(mapActionClick)];
}

/*设置标题组*/
- (void)setUpTitleView{
    //标题数组
    NSArray *titleArr = @[@"最新",@"热门",@"分类"];
    //标题栏设置
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor whiteColor];
    titlesView.width = self.view.width;
    titlesView.height = 40;
    titlesView.y = NavigationBar_H;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
    
    
    // 底部滑条
    UIView *sliderView = [[UIView alloc] init];
    sliderView.backgroundColor = Color_Theme_Pink;
    sliderView.height = 2;
    sliderView.tag = -1;
    sliderView.y = titlesView.height - sliderView.height -5;
    
    self.sliderView = sliderView;
    
    //设置上面的按钮
    NSInteger width = titlesView.width / titleArr.count;
    NSInteger height = 40;
    for (NSInteger i=0; i<titleArr.count; i++) {
        LhkhButton *btn = [[LhkhButton alloc] init];
        btn.width = width;
        btn.height = height;
        btn.y = 0;
        btn.x = i * width;
        btn.tag = i;
        [btn setTitle: titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:btn];
        
        if (i == 0) {
            btn.enabled = NO;
            self.selectedButton = btn;
            [btn.titleLabel sizeToFit];
            self.sliderView.width = btn.titleLabel.width;
            self.sliderView.centerX = btn.centerX;
        }
    }
    [self.titlesView addSubview:sliderView];
    self.navigationItem.titleView = self.searchView;
    self.searchView.typeStr = self.selectedButton.titleLabel.text;
}


/*设置scrollview的内容部分*/

- (void)setupContentView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.backgroundColor = COLOR(236, 236, 236);
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    [self.view insertSubview:contentView atIndex:0];
    self.contentView = contentView;
    self.contentView.showsVerticalScrollIndicator = NO;
    self.contentView.showsHorizontalScrollIndicator = NO;
    [self scrollViewDidEndScrollingAnimation:contentView];
}


/*创建标题对应的子控制器*/

- (void)setupChildViewControllers
{
    [self setupOneChildViewController:selectHomeNewestType];
    [self setupOneChildViewController:selectHomeHotType];
    [self setupOneChildViewController:selectHomeRecommendType];
}

- (void)setupOneChildViewController:(selectHomeType)type
{
    
    if (type == selectHomeNewestType ) {
        self.newestVC = [[FWHomeTypeVC alloc] init];
        self.newestVC.selectType = selectHomeNewestType;
        [self addChildViewController:self.newestVC];
    }else if (type == selectHomeHotType){
        self.hotVC = [[FWHomeTypeVC alloc] init];
        self.hotVC.selectType = selectHomeHotType;
        [self addChildViewController:self.hotVC];
    }else if (type == selectHomeRecommendType){
        self.recommendVC = [[FWHomeTypeVC alloc] init];
        self.recommendVC.selectType = selectHomeRecommendType;
        self.recommendVC.classifyArr = self.classifyArr;
        [self addChildViewController:self.recommendVC];
    }
    
}

- (void)setMenuView
{
    self.menuView = [[UIView alloc] initWithFrame:CGRectZero];
    self.menuView.hidden = YES;
    [self.view addSubview:self.menuView];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    bgImageView.image = [UIImage imageNamed:@"home_juxing"];
    [self.menuView addSubview:bgImageView];
    
    UIButton *nearbyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [nearbyBtn setTitle:@"附近商场" forState:UIControlStateNormal];
    [nearbyBtn setTitleColor:Color_Black forState:UIControlStateNormal];
    [nearbyBtn setImage:Image(@"home_market") forState:UIControlStateNormal];
    nearbyBtn.titleLabel.font = systemFont(14);
    [nearbyBtn addTarget:self action:@selector(nearbyClick) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:nearbyBtn];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = Color_MainBg;
    [self.menuView addSubview:lineView];
    
    UIButton *brandBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [brandBtn setTitle:@"品牌实体店" forState:UIControlStateNormal];
    [brandBtn setTitleColor:Color_Black forState:UIControlStateNormal];
    [brandBtn setImage:Image(@"home_shop") forState:UIControlStateNormal];
    brandBtn.titleLabel.font = systemFont(14);
    [brandBtn addTarget:self action:@selector(brandClick) forControlEvents:UIControlEventTouchUpInside];
    [self.menuView addSubview:brandBtn];
    
    [self.menuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(136);
        make.height.offset(88);
        make.right.equalTo(self.view).offset(-5);
        make.top.equalTo(self.view).offset(NavigationBar_H);
    }];
    
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.menuView);
    }];
    
    [nearbyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.top.equalTo(self.menuView).offset(15);
        make.left.equalTo(self.menuView);
        make.right.equalTo(self.menuView);
    }];
    nearbyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.top.equalTo(nearbyBtn.mas_bottom);
        make.left.right.equalTo(self.menuView);
    }];
    
    
    [brandBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(self.menuView);
        make.right.equalTo(self.menuView);
    }];
    brandBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
}

- (void)loadAppStoreVersion
{
    _isShow = [USER_DEFAULTS objectForKey:UD_IsShowBuy];
    NSString *v = [USER_DEFAULTS objectForKey:UD_AppVersionCancel];
    
    if (![_isShow isEqualToString:@"1"] && ![v isEqualToString:@"1"]) {
        [[APPVersionManager sharedInstance]checkVersion:self];
    }
}

#pragma mark - Setters

- (FWSearchView*)searchView
{
    if (_searchView == nil) {
        _searchView = [[FWSearchView alloc] initWithFrame:CGRectMake(0, 0, Screen_W-40, 30)];
        _searchView.backgroundColor = Color_MainBg;
        _searchView.vcStr = @"FWHomeVC";
        _searchView.index = 0;
        _searchView.delegate = self;
    }
    return _searchView;
}

- (NSMutableArray *)classifyArr
{
    if (_classifyArr == nil) {
        _classifyArr = [NSMutableArray array];
    }
    return _classifyArr;
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
