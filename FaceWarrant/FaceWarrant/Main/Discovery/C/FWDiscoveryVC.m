//
//  FWDiscoveryVC.m
//  FaceWarrant
//
//  Created by LHKH on 2018/6/8.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWDiscoveryVC.h"
#import "FWDiscoveryTypeVC.h"
#import "FWSearchVC.h"
#import "FWSearchView.h"
#import "LhkhButton.h"
#import "FWVoiceView.h"
@interface FWDiscoveryVC ()<UIScrollViewDelegate,FWSearchViewDelegate>
@property (strong, nonatomic) FWSearchView *searchView;
@property (strong, nonatomic) UIView *titlesView;
@property (strong, nonatomic) LhkhButton *selectedButton;
@property (strong, nonatomic) UIView *sliderView;
@property (strong, nonatomic) UIScrollView *contentView;
@property (strong, nonatomic) FWDiscoveryTypeVC *newsVC;
@property (strong, nonatomic) FWDiscoveryTypeVC *answerVC;
@end

@implementation FWDiscoveryVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setupChildViewControllers];
    [self setUpTitleView];
    [self setupContentView];
}


#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码


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
- (void)FWSearchViewDelegateVoiceClick
{
    DLog(@"----");
}

#pragma mark - Event Response

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
}


#pragma mark - Network requests




#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setNav
{
    if (iOS10Later) {
        UIBarButtonItem *item = [UIBarButtonItem js_itemWithTitle:@"" target:self action:nil];
        UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        fixedItem.width = -40;
        self.navigationItem.leftBarButtonItems = @[fixedItem,item];
    }
    if (iOS11Later) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    self.navigationItem.titleView = self.searchView;
    
}

/*设置标题组*/

- (void)setUpTitleView{
    //标题数组
    NSArray *titleArr = @[@"新品",@"回答"];
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
    NSInteger width = (titlesView.width-100) / titleArr.count;
    NSInteger height = 40;
    for (NSInteger i=0; i<titleArr.count; i++) {
        LhkhButton *btn = [[LhkhButton alloc] init];
        btn.width = width;
        btn.height = height;
        btn.y = 0;
        btn.x = 50 + i * width;
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
    [self setupOneChildViewController:selectDiscoveryNewType];
//    [self setupOneChildViewController:selectDiscoveryFaceType];
    [self setupOneChildViewController:selectDiscoveryAnswerType];
}

- (void)setupOneChildViewController:(selectDiscoveryType)type
{
    
    if (type == selectHomeNewestType ) {
        self.newsVC = [[FWDiscoveryTypeVC alloc] init];
        self.newsVC.selectType = selectDiscoveryNewType;
        [self addChildViewController:self.newsVC];
    }
//    else if (type == selectDiscoveryFaceType){
//        self.faceLVC = [[FWDiscoveryTypeVC alloc] init];
//        self.faceLVC.selectType = selectDiscoveryFaceType;
//        [self addChildViewController:self.faceLVC];
//    }
    else if (type == selectDiscoveryAnswerType){
        self.answerVC = [[FWDiscoveryTypeVC alloc] init];
        self.answerVC.selectType = selectDiscoveryAnswerType;
        [self addChildViewController:self.answerVC];
    }
    
}


#pragma mark - Setters

- (FWSearchView*)searchView
{
    if (_searchView == nil) {
        _searchView = [[FWSearchView alloc] initWithFrame:CGRectMake(0, 0, Screen_W-40, 30)];
        _searchView.backgroundColor = Color_MainBg;
        _searchView.vcStr = @"FWDiscoveryVC";
        _searchView.index = 3;
        _searchView.delegate = self;
    }
    return _searchView;
}


#pragma mark - Getters




@end
