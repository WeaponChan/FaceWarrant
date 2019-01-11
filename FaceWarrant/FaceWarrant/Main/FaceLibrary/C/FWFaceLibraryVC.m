//
//  FWFaceLibraryVC.m
//  FaceWarrant
//
//  Created by FW on 2018/11/15.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import "FWFaceLibraryVC.h"
#import "FWSearchVC.h"
#import "FWSearchView.h"
#import "LSPPageView.h"
#import "FWFaceLibraryManager.h"
#import "FWMyFacesSubVC.h"
#import "FWFaceLibraryClassifyModel.h"
#import "FWAddAttentionVC.h"
#import "FWQuestionVC.h"
@interface FWFaceLibraryVC ()<LSPPageViewDelegate,FWSearchViewDelegate,FWMyFacesSubVCDelegate>
{
    CGFloat _lastOffsetY;
}
@property (strong, nonatomic) FWSearchView *searchView;
@property (strong, nonatomic) NSMutableArray *classifyArr;
@property (strong, nonatomic) LSPPageView *pageView;
@property (strong, nonatomic) UIButton *supBtn;
@property (strong, nonatomic) UIButton *topBtn;
@end

@implementation FWFaceLibraryVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self loadData];
}


#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码

#pragma mark - System Delegate


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


#pragma mark - LSPPageViewDelegate
- (void)pageViewScollEndView:(LSPPageView *)pageView WithIndex:(NSInteger)index
{
    DLog(@"第%zd个",index);
    FWFaceLibraryClassifyModel *model = self.classifyArr[index];
    self.searchView.typeStr = model.groupsName;
}

- (void)pageViewAddClick:(LSPPageView *)pageView WithIndex:(NSInteger)index
{
    FWAddAttentionVC *vc = [[FWAddAttentionVC alloc] init];
    FWFaceLibraryClassifyModel *model = self.classifyArr[index];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:NO];
}

#pragma mark -FWMyFacesSubVCDelegate

- (void)FWMyFacesSubVCDelegateScrollOffsetY:(CGFloat)offsetY
{
    CGFloat touchW = 60;
    CGFloat touchX = Screen_W - 70;
    CGFloat touchY = 0;
    if (IS_iPhoneX_Later) {
        touchY = Screen_H - 300;
    }else{
        touchY = Screen_H - 200;
    } 
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.supBtn.frame = CGRectMake(touchX+40, touchY, touchW, touchW);
        self.supBtn.alpha = 0.5;
    } completion:^(BOOL finished) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (self->_lastOffsetY == offsetY) {
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    self.supBtn.frame = CGRectMake(touchX, touchY, touchW, touchW);
                    self.supBtn.alpha = 1;
                } completion:nil];
            }
        });
    }];
    
    _lastOffsetY = offsetY;
    
    if (offsetY > 200.0f) {
        self.topBtn.hidden = NO;
    }else{
        self.topBtn.hidden = YES;
    }
}

#pragma mark - Event Response
- (void)p_clickBtn
{
    FWQuestionVC *vc = [[FWQuestionVC alloc] init];
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)topClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"topClick" object:nil];
}

#pragma mark - Network Requests

- (void)refreshData
{
    [self loadData];
}

- (void)loadData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID]
                            };
    [FWFaceLibraryManager loadFaceLibraryClassifyWithParameters:param result:^(NSArray<FWFaceLibraryClassifyModel *> *model) {
        [self.classifyArr removeAllObjects];
        [self.classifyArr addObjectsFromArray:model];
        if (model.count == 0) {
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.view];
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView: self.view];
            [self setSubView];
            [self setSuspensionBtn];
        }
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods

- (void)setNav
{
    self.view.backgroundColor = Color_MainBg;
    if (iOS10Later) {
        UIBarButtonItem *item = [UIBarButtonItem js_itemWithTitle:@"" target:self action:nil];
        UIBarButtonItem *fixedItem = [[UIBarButtonItem alloc]  initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
        fixedItem.width = -40;
        self.navigationItem.leftBarButtonItems = @[fixedItem,item];
        self.navigationItem.rightBarButtonItems = @[fixedItem,item];
    }
    if (iOS11Later) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
    self.navigationItem.titleView = self.searchView;
}


- (void)setSubView
{
    if (self.pageView) {
        UIView *view = [self.view viewWithTag:900090];
        [view removeFromSuperview];
    }
    NSMutableArray *childVcArray = [NSMutableArray array];
    NSMutableArray *titleVcArray = [NSMutableArray array];
    for (int i = 0; i <self.classifyArr.count; i++) {
        FWFaceLibraryClassifyModel *model = self.classifyArr[i];
        FWMyFacesSubVC *vc = [[FWMyFacesSubVC alloc] init];
        vc.delegate = self;
        vc.groupId = model.groupsId;
        [titleVcArray addObject:model.groupsName];
        [childVcArray addObject:vc];
    }
    self.pageView = [[LSPPageView alloc] initWithFrame:CGRectMake(0, NavigationBar_H, self.view.bounds.size.width, self.view.bounds.size.height) titles:titleVcArray.mutableCopy style:nil childVcs:childVcArray.mutableCopy parentVc:self];
    self.pageView.tag = 900090;
    self.pageView.delegate = self;
    [self.view addSubview:self.pageView];
}

-(void)setSuspensionBtn
{
    if (self.supBtn) {
        UIView *view = [self.view viewWithTag:900091];
        [view removeFromSuperview];
    }
    
    CGFloat touchW = 60;
    CGFloat touchX = Screen_W - 70;
    CGFloat touchY = 0;
    if (IS_iPhoneX_Later) {
        touchY = Screen_H - 300;
    }else{
        touchY = Screen_H - 200;
    } 
    
    CGFloat touchH = 60;
    self.supBtn = [[UIButton alloc] initWithFrame:CGRectMake(touchX, touchY, touchW, touchH)];
    self.supBtn.tag = 900091;
    self.supBtn.backgroundColor = [UIColor clearColor];
    [self.supBtn setBackgroundImage:Image(@"suspension") forState:UIControlStateNormal];
    
    [self.view addSubview:self.supBtn];
    [self.supBtn addTarget:self action:@selector(p_clickBtn) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:self.topBtn];
    [self.topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(35);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(self.supBtn.mas_bottom).offset(10);
    }];
}


#pragma mark - Setters

- (FWSearchView*)searchView
{
    if (_searchView == nil) {
        _searchView = [[FWSearchView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 30)];
        _searchView.backgroundColor = Color_MainBg;
        _searchView.vcStr = @"FWFaceLibraryVC";
        _searchView.index = 1;
        _searchView.delegate = self;
    }
    return _searchView;
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

- (NSMutableArray *)classifyArr
{
    if (_classifyArr == nil) {
        _classifyArr = [NSMutableArray array];
    }
    return _classifyArr;
}

#pragma mark - Getters


@end
