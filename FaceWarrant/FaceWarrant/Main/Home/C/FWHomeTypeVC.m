//
//  FWHomeTypeVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWHomeTypeVC.h"
#import "LhkhCollectionView.h"
#import "LhkhButton.h"
#import "FWClassifyTypeVC.h"
#import "FWHomeClassifyModel.h"
#import "UIButton+Lhkh.h"
@interface FWHomeTypeVC ()<UIScrollViewDelegate>
@property (strong, nonatomic)LhkhCollectionView *faceCollectionView;
@property (assign, nonatomic)CGFloat marginTop;

@property (strong, nonatomic) UIScrollView *classifyTitleView;
@property (strong, nonatomic) LhkhButton *classifyselectedButton;
@property (strong, nonatomic) UIScrollView *classifycontentView;


@end

@implementation FWHomeTypeVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.selectType == 2) {
        if (self.classifyArr.count>0) {
            [self setUpclassifyTitleView];
            [self setupclassifyContentView];
        }
    }else{
        [self setFaceCollectionView];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Layout SubViews




#pragma mark - System Delegate

#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    if (scrollView == self.classifyTitleView) {
        DLog(@"titleView move");
    }else{
        NSInteger index = scrollView.contentOffset.x / scrollView.width;
        UIViewController *vc = self.childViewControllers[index];
        vc.view.x = scrollView.contentOffset.x;
        vc.view.y = 0;
        vc.view.height = scrollView.height;
        [scrollView addSubview:vc.view];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView  {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    if (scrollView == self.classifyTitleView) {
        DLog(@"titleView move");
    }else{
        //点击标题按钮
        NSInteger index = scrollView.contentOffset.x / scrollView.width;
        [self  classifytitleClick:self.classifyTitleView.subviews[index]];
    }
}


#pragma mark - Custom Delegate




#pragma mark - Event Response

#pragma mark 标题栏每个按钮的点击事件
-(void)classifytitleClick:(LhkhButton *)button{
//    button.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.classifyselectedButton.enabled = YES;
    button.enabled = NO;
    self.classifyselectedButton = button;
    CGPoint offset = self.classifycontentView.contentOffset;
    offset.x = button.tag * self.classifycontentView.width;
    [self.classifycontentView setContentOffset:offset animated:YES];
    
    // 这个偏移量是相对于scrollview的content frame原点的相对对标
    CGFloat deltaX = button.center.x - Screen_W / 2;
    // 设置偏移量
    if (deltaX < 0)
    {
        // 最左边
        deltaX = 0;
    }
    CGFloat maxDeltaX = self.classifyTitleView.contentSize.width - Screen_W;
    if (deltaX > maxDeltaX)
    {
        // 最右边不能超范围
        deltaX = maxDeltaX;
    }
    [self.classifyTitleView setContentOffset:CGPointMake(deltaX, 0) animated:YES];
}


#pragma mark - Network requests



#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setFaceCollectionView
{
    [self.view addSubview:self.faceCollectionView];
    [self.faceCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).offset(NavigationBar_H +40);
        make.bottom.equalTo(self.view).offset(-TabBar_H);
    }];
}


/*设置标题组*/

- (void)setUpclassifyTitleView{
    
    // 标题栏
    self.classifyTitleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationBar_H+40, Screen_W, 40)];
    self.classifyTitleView.showsHorizontalScrollIndicator = NO;
    self.classifyTitleView.bounces = NO;
    self.classifyTitleView.delegate = self;
    [self.view addSubview:self.classifyTitleView];
    
    self.classifyTitleView.contentSize = CGSizeMake(15+110 * self.classifyArr.count, 40);
    
    //设置上面的按钮
    NSInteger width = 90;
    NSInteger height = 30;
    for (NSInteger i=0; i<self.classifyArr.count; i++) {
        FWHomeClassifyModel *model = self.classifyArr[i];
        LhkhButton *btn = [[LhkhButton alloc] init];
        btn.width = width;
        btn.height = height;
        btn.y = 5;
        btn.x = 15+i*width+i*20;
        btn.tag = i;
        btn.backgroundColor = Color_White;
        btn.layer.cornerRadius = 15.f;
        btn.layer.masksToBounds = YES;
        [btn setTitle: model.name forState:UIControlStateNormal];
        [btn lhkh_setButtonImageWithUrl:model.value];
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        [btn addTarget:self action:@selector(classifytitleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.classifyTitleView addSubview:btn];
        
        if (i == 0) {
            btn.enabled = NO;
            self.classifyselectedButton = btn;
            [btn.titleLabel sizeToFit];
        }
        //根据返回的title数动态创建子控制器
        FWClassifyTypeVC *vc = [[FWClassifyTypeVC alloc] init];
        vc.titleType = model.code;
        [self addChildViewController:vc];
    }
}


/*设置scrollview的内容部分*/
- (void)setupclassifyContentView
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *contentView = [[UIScrollView alloc] init];
    
    contentView.backgroundColor = COLOR(236, 236, 236);
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    [self.view insertSubview:contentView atIndex:0];
    self.classifycontentView = contentView;
    self.classifycontentView.showsVerticalScrollIndicator = NO;
    self.classifycontentView.showsHorizontalScrollIndicator = NO;
    [self scrollViewDidEndScrollingAnimation:contentView];
}



#pragma mark - Setters

- (LhkhCollectionView*)faceCollectionView
{
    if (_faceCollectionView == nil) {
        _faceCollectionView = [[LhkhCollectionView alloc] initWithFrame:CGRectZero vcType:@"FWHomeTypeVC" selectType:self.selectType];
    }
    return _faceCollectionView;
}



#pragma mark - Getters




@end
