//
//  FWFaceLibrarySearchVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/14.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFaceLibrarySearchVC.h"
#import "FWFaceLibrarySearchTypeVC.h"
#import "FWSearchView.h"
//#import "FWVoiceView.h"
#import "LhkhButton.h"
#import "FWHomeClassifyModel.h"
#import "UIButton+Lhkh.h"
#import "FWFaceLibraryAllBrandVC.h"
#import "FWSearchManager.h"
#import "FWBrandModel.h"
#import "LhkhLabel.h"
@interface FWFaceLibrarySearchVC ()<UIScrollViewDelegate,FWSearchViewDelegate>
{
    NSString *_brandId;
    NSString *_allstr;
}
@property (strong, nonatomic) FWSearchView *searchView;
//@property (strong, nonatomic) FWVoiceView *voiceView;
@property (strong, nonatomic) UIScrollView *classifyTitleView;
@property (strong, nonatomic) UIView *sliderView;
@property (strong, nonatomic) LhkhButton *classifyselectedButton;
@property (strong, nonatomic) LhkhButton *brandselectedButton;
@property (strong, nonatomic) UIView *topView;
@property (strong, nonatomic) UIView *brandView;
@property (strong, nonatomic) LhkhLabel *brandLab;
//@property (strong, nonatomic) UILabel *brandLab;
@property (strong, nonatomic) UILabel *brandSelLab;
@property (strong, nonatomic) UIScrollView *classifycontentView;
@property (strong, nonatomic) NSMutableArray *groupsList;
@property (strong, nonatomic) NSMutableArray *brandList;
@property (strong, nonatomic) FWFaceLibraryAllBrandVC *allBrandVC;
@end

@implementation FWFaceLibrarySearchVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadBrandData) name:@"reloadBrandData" object:nil];
    
    if (self.model.groupsList != nil && self.model.groupsList.count>0 && self.model.brandList != nil && self.model.groupsList.count>0) {
        [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.view];
        [self setTopBrandView];
        [self setUpclassifyTitleView];
        [self setupclassifyContentView];
        
    }else{
        [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.view];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.model.groupsList != nil && self.model.groupsList.count>0 && self.model.brandList != nil && self.model.groupsList.count>0) {
        [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.view];
        [self reloadBrandData];
    }else{
        [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.view];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - Layout SubViews
//11.29换新的框架 替换掉原来适配的代码

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


//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    self.voiceView.hidden = YES;
//    [self.view endEditing:YES];
//}

#pragma mark - Custom Delegate
#pragma mark - FWSearchViewDelegate
- (void)FWSearchViewDelegateWithText:(NSString *)text
{
    DLog(@"---- >%@",text);
    _searchText = text;
    [self loadData:text];
}

- (void)FWSearchViewDelegateVoiceClick
{
    [self.searchView.searchText resignFirstResponder];
}

//- (void)FWSearchViewDelegateWithTextViewBeginEditing
//{
//    self.voiceView.hidden = YES;
//}

//#pragma mark - FWVoiceViewDelegate
//- (void)FWVoiceViewDelegateWithText:(NSString *)text
//{
//    self.searchView.searchText.text = text;
//    self.searchText = text;
//    self.voiceView.hidden = YES;
//    [self loadData:text];
//}

#pragma mark - Event Response

#pragma mark 标题栏品牌的点击事件
-(void)brandtitleClick:(LhkhButton *)button{
    
//    self.brandselectedButton.enabled = YES;
//    button.enabled = NO;
//    [self setTitleColor:Color_Black forState:UIControlStateNormal];
//    [self setTitleColor:Color_Theme_Pink forState:UIControlStateDisabled];

//    BOOL result = button.selected;
    if (self.brandselectedButton) {
        if (button.tag != self.brandselectedButton.tag) {
            self.brandselectedButton.selected = NO;
            [self.brandselectedButton setTitleColor:Color_Black forState:UIControlStateNormal];
        }
    }
    button.selected = !button.selected;
    self.brandselectedButton = button;
    if (button.selected) {
        [button setTitleColor:Color_Theme_Pink forState:UIControlStateNormal];
        FWFacelibrarySearchGroupsListModel *model = self.groupsList[self.classifyselectedButton.tag];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notif_BrandClick object:self userInfo:@{@"brandId":[NSString stringWithFormat:@"%ld",(long)button.tag],@"groupId":model.groupsId,@"searchText":self.searchText}];
    }else{
        [button setTitleColor:Color_Black forState:UIControlStateNormal];
        FWFacelibrarySearchGroupsListModel *model = self.groupsList[self.classifyselectedButton.tag];
        [[NSNotificationCenter defaultCenter] postNotificationName:Notif_BrandClick object:self userInfo:@{@"brandId":@"",@"groupId":model.groupsId,@"searchText":self.searchText}];
    }
}

#pragma mark 标题栏每个按钮的点击事件
-(void)classifytitleClick:(LhkhButton *)button{
    //    button.transform = CGAffineTransformMakeScale(1.2, 1.2);
    self.classifyselectedButton.enabled = YES;
    button.enabled = NO;
    self.classifyselectedButton = button;
    [UIView animateWithDuration:0.25 animations:^{
        self.sliderView.width = button.titleLabel.width;
        self.sliderView.centerX = button.centerX;
    }];
    CGPoint offset = self.classifycontentView.contentOffset;
    offset.x = button.tag * self.classifycontentView.width;
    [self.classifycontentView setContentOffset:offset animated:YES];
    
    FWFacelibrarySearchGroupsListModel *model = self.groupsList[self.classifyselectedButton.tag];
    if (_brandId && _brandId.length>0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:Notif_BrandClick object:self userInfo:@{@"brandId":_brandId,@"groupId":model.groupsId,@"searchText":self.searchText}];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:Notif_BrandClick object:self userInfo:@{@"brandId":self.brandselectedButton.tag==0?@"":[NSString stringWithFormat:@"%ld",(long)self.brandselectedButton.tag],@"groupId":model.groupsId,@"searchText":self.searchText}];
    }
    
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
    if (deltaX < 0 ) {
        [self.classifyTitleView setContentOffset:CGPointMake(0, 0) animated:YES];
    }else{
        [self.classifyTitleView setContentOffset:CGPointMake(deltaX, 0) animated:YES];
    }
}


- (void)allBrandClick
{
    DLog(@"allBrand");
    self.allBrandVC.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    self.allBrandVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    self.allBrandVC.searchText = self.searchText;
    LhkhWeakSelf(self);
    self.allBrandVC.brandidblock = ^(FWBrandModel *model,NSString *all) {
        if ([all isEqualToString:@""]) {
           self.brandSelLab.text = @"选择";
            FWFacelibrarySearchGroupsListModel *fmodel = weakself.groupsList[weakself.classifyselectedButton.tag];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notif_BrandClick object:weakself userInfo:@{@"brandId":model.brandId,@"groupId":fmodel.groupsId,@"searchText":weakself.searchText}];
            weakself.brandLab.text = [NSString stringWithFormat:@"%@(%@)",model.brandName,model.releaseCount];
            self->_brandId = model.brandId;
            weakself.brandLab.hidden = NO;
            weakself.brandView.hidden = YES;
        }else{
            self->_allstr = @"全部";
            FWFacelibrarySearchGroupsListModel *fmodel = weakself.groupsList[weakself.classifyselectedButton.tag];
            [[NSNotificationCenter defaultCenter] postNotificationName:Notif_BrandClick object:weakself userInfo:@{@"brandId":@"",@"groupId":fmodel.groupsId,@"searchText":weakself.searchText}];
            weakself.brandLab.hidden = YES;
            weakself.brandView.hidden = NO;
            if(weakself.topView){
                UIView *view = [weakself.view viewWithTag:100010];
                [view removeFromSuperview];
            }
            [weakself setTopBrandView];
        }
    };
    [self presentViewController:self.allBrandVC animated:YES completion:^(void)
     {
         self.allBrandVC.view.superview.backgroundColor = [UIColor clearColor];
     }];
}

- (void)reloadBrandData
{
    [self loadData:self.searchText];
}

#pragma mark - Network Requests

- (void)loadData:(NSString *)text
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"searchCondition":text,
                            @"requestType":@"0"
                            };
    [FWSearchManager loadFaceLibrarySearchDataWithParameters:param result:^(FWFacelibrarySearchModel *model) {
        [self.searchView.searchText resignFirstResponder];
        self.model = model;
        [self.brandList removeAllObjects];
//        [self.groupsList removeAllObjects];
//        self.groupsList = [FWFacelibrarySearchGroupsListModel mj_objectArrayWithKeyValuesArray:self.model.groupsList];
        self.brandList = [FWFacelibrarySearchBrandListModel mj_objectArrayWithKeyValuesArray:self.model.brandList];
        if (self.model.groupsList != nil && self.model.brandList != nil) {
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.view];
            [self setTopBrandView];
//            [self setUpclassifyTitleView];
//            [self setupclassifyContentView];
            FWFacelibrarySearchGroupsListModel *model = self.groupsList[self.classifyselectedButton.tag];
            
            if (self->_brandId && self->_brandId.length>0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:Notif_BrandClick object:self userInfo:@{@"brandId":self->_brandId,@"groupId":model.groupsId,@"searchText":self.searchText}];
            }else{
                [[NSNotificationCenter defaultCenter] postNotificationName:Notif_BrandClick object:self userInfo:@{@"brandId":self.brandselectedButton.tag==0?@"":[NSString stringWithFormat:@"%ld",(long)self.brandselectedButton.tag],@"groupId":model.groupsId,@"searchText":self.searchText}];
            }
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.view];
        }
    }];
}
#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.titleView = self.searchView;
}

- (void)setTopBrandView
{
    self.topView = [[UIView alloc] initWithFrame:CGRectMake(0, NavigationBar_H, Screen_W, 100)];
    self.topView.backgroundColor = Color_White;
    self.topView.tag = 100010;
    [self.view addSubview:self.topView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 40, 20)];
    label.text = @"品牌";
    label.textColor = Color_Black;
    label.font = systemFont(18);
    [self.topView addSubview:label];
    
    UIImageView *xiaImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    xiaImg.image = Image(@"facelibrary_xia");
    [self.topView addSubview:xiaImg];
    
    self.brandSelLab = [[UILabel alloc] initWithFrame:CGRectZero];
    self.brandSelLab.text = _allstr?:@"选择";
    self.brandSelLab.textColor = [UIColor colorWithHexString:@"#666666"];
    self.brandSelLab.font = systemFont(14);
    [self.topView addSubview:self.brandSelLab];
    
    UIButton *allBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [allBtn addTarget:self action:@selector(allBrandClick) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:allBtn];
    
    [xiaImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(13);
        make.height.offset(7);
        make.right.equalTo(self.topView).offset(-15);
        make.centerY.equalTo(label.mas_centerY);
    }];
    
    [self.brandSelLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(xiaImg.mas_left).offset(-5);
        make.height.offset(20);
        make.width.offset(30);
        make.centerY.equalTo(label.mas_centerY);
    }];
    
    [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.brandSelLab);
        make.right.equalTo(xiaImg);
        make.top.equalTo(self.brandSelLab);
        make.bottom.equalTo(self.brandSelLab);
    }];
    
    self.brandView = [[UIView alloc] initWithFrame:CGRectZero];
    self.brandView.backgroundColor = Color_White;
    [self.topView addSubview:self.brandView];
    self.brandView.hidden = NO;
    [self.brandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(15);
        make.right.equalTo(self.topView).offset(-15);
        make.height.offset(30);
        make.bottom.equalTo(self.topView).offset(-10);
    }];
    
    [self.topView addSubview:self.brandLab];
    self.brandLab.hidden = YES;
    [self.brandLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView).offset(15);
        make.height.offset(30);
        make.bottom.equalTo(self.topView).offset(-10);
    }];
    self.brandLab.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
    
    NSInteger width = (Screen_W-60)/3;
    NSInteger height = 30;
    
    for (NSInteger i=0; i<self.model.brandList.count; i++) {
        FWFacelibrarySearchBrandListModel *model = self.brandList[i];
        LhkhButton *btn = [[LhkhButton alloc] init];
        btn.width = width;
        btn.height = height;
        btn.y = 0;
        btn.x = i*width+i*15;
        btn.tag = model.brandId.integerValue;
        btn.backgroundColor = [UIColor colorWithHexString:@"#F4F3F3"];
        btn.layer.cornerRadius = 15.f;
        btn.layer.masksToBounds = YES;
        [btn setTitle: [NSString stringWithFormat:@"%@（%@）",model.brandName,model.releaseCount] forState:UIControlStateNormal];
        [btn setTitleColor:Color_Black forState:UIControlStateNormal];
        btn.titleLabel.font = systemFont(12);
        [btn addTarget:self action:@selector(brandtitleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.brandView addSubview:btn];
    }
}

/*设置标题组*/
- (void)setUpclassifyTitleView{
    
    // 标题栏
    self.classifyTitleView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavigationBar_H+100, Screen_W, 40)];
    self.classifyTitleView.backgroundColor = Color_White;
    self.classifyTitleView.showsHorizontalScrollIndicator = NO;
    self.classifyTitleView.bounces = NO;
    self.classifyTitleView.delegate = self;
    [self.view addSubview:self.classifyTitleView];
    
    self.classifyTitleView.contentSize = CGSizeMake(90 * self.groupsList.count, 40);
    
    // 底部滑条
    UIView *sliderView = [[UIView alloc] init];
    sliderView.backgroundColor = Color_Theme_Pink;
    sliderView.height = 2;
    sliderView.tag = -1;
    sliderView.y = self.classifyTitleView.height - sliderView.height -5;
    
    self.sliderView = sliderView;
    
    //设置上面的按钮
    NSInteger width = 90;
    NSInteger height = 30;
    for (NSInteger i=0; i<self.groupsList.count; i++) {
        FWFacelibrarySearchGroupsListModel *model = self.groupsList[i];
        LhkhButton *btn = [[LhkhButton alloc] init];
        btn.width = width;
        btn.height = height;
        btn.y = 5;
        btn.x = i*width;
        btn.tag = i;
        [btn setTitle: model.groupsName forState:UIControlStateNormal];
        [btn setTitleColor:Color_Black forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(classifytitleClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.classifyTitleView addSubview:btn];
        
        if (i == 0) {
            btn.enabled = NO;
            self.classifyselectedButton = btn;
            [btn.titleLabel sizeToFit];
            self.sliderView.width = btn.titleLabel.width;
            self.sliderView.centerX = btn.centerX;
        }
        [self.classifyTitleView addSubview:sliderView];
        //根据返回的title数动态创建子控制器
        FWFaceLibrarySearchTypeVC *vc = [[FWFaceLibrarySearchTypeVC alloc] init];
        vc.groupsId = model.groupsId;
        vc.searchText = self.searchText;
        
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

//- (void)setSubView
//{
//    self.voiceView.hidden = YES;
//    [self.view addSubview:self.voiceView];
//    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(200);
//        make.left.right.bottom.equalTo(self.view);
//    }];
//}


#pragma mark - Setters
- (FWSearchView*)searchView
{
    if (_searchView == nil) {
        _searchView = [[FWSearchView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 30)];
        _searchView.backgroundColor = Color_MainBg;
        _searchView.delegate = self;
        _searchView.vcStr = @"FWFaceLibraryVC";
        _searchView.index = 1;
//        _searchView.clickBtn.hidden = YES;
        _searchView.searchText.text = self.searchText;
    }
    return _searchView;
}

//- (FWVoiceView*)voiceView
//{
//    if (_voiceView == nil) {
//        _voiceView = [[FWVoiceView alloc] initWithFrame:CGRectMake(0, Screen_H-300, Screen_W, 300)];
//        _voiceView.backgroundColor = Color_MainBg;
//        _voiceView.delegate = self;
//        _voiceView.vctype = @"0";
//    }
//    return _voiceView;
//}

- (NSMutableArray*)groupsList
{
    if (_groupsList == nil) {
        _groupsList = [NSMutableArray array];
        [_groupsList removeAllObjects];
        _groupsList = [FWFacelibrarySearchGroupsListModel mj_objectArrayWithKeyValuesArray:self.model.groupsList];
    }
    return _groupsList;
}

- (NSMutableArray*)brandList
{
    if (_brandList == nil) {
        _brandList = [NSMutableArray array];
        [_brandList removeAllObjects];
        _brandList = [FWFacelibrarySearchBrandListModel mj_objectArrayWithKeyValuesArray:self.model.brandList];
    }
    return _brandList;
}

//- (UIView*)brandView
//{
//    if (_brandView == nil) {
//        _brandView = [[UIView alloc] initWithFrame:CGRectZero];
//        _brandView.backgroundColor = Color_White;
//    }
//    return _brandView;
//}

- (UILabel*)brandLab
{
    if (_brandLab == nil) {
        _brandLab = [[LhkhLabel alloc] initWithFrame:CGRectZero];
        _brandLab.font = systemFont(14);
        _brandLab.backgroundColor = [UIColor colorWithHexString:@"#F4F3F3"];
        _brandLab.textColor = Color_Theme_Pink;
        _brandLab.textAlignment = NSTextAlignmentCenter;
        _brandLab.layer.cornerRadius = 15.f;
        _brandLab.layer.masksToBounds = YES;
    }
    return _brandLab;
}

- (FWFaceLibraryAllBrandVC*)allBrandVC
{
    if (_allBrandVC == nil) {
        _allBrandVC = [FWFaceLibraryAllBrandVC new];
    }
    return _allBrandVC;
}

#pragma mark - Getters


@end
