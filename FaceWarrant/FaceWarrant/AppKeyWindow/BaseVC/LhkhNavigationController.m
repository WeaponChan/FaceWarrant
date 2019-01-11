//
//  LhkhNavigationController.m
//  Lhkh_Base
//
//  Created by Weapon on 2018/11/28.
//  Copyright © 2018 Lhkh. All rights reserved.
//

#import "LhkhNavigationController.h"
@interface LhkhNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation LhkhNavigationController

#pragma mark - Life Cycle

-(void)loadView
{
    [super loadView];
    //title颜色和字体
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:Color_Black,NSFontAttributeName:systemFont(18)};
    [UINavigationBar appearance].barTintColor = Color_MainBg;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.interactivePopGestureRecognizer.delegate = self;
    self.delegate = self;
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    self.interactivePopGestureRecognizer.enabled = YES;
    BOOL isRootVC = viewController == navigationController.viewControllers.firstObject;
    // 解决某些情况下push时的假死bug，防止把根控制器pop掉
    if (isRootVC) {
        self.interactivePopGestureRecognizer.enabled = NO;
    }
}


#pragma mark - UIGestureRecognizerDelegate

//修复有水平方向滚动的ScrollView时边缘返回手势失效的问题
//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//    return YES;
//}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 首先判断otherGestureRecognizer是不是系统pop手势
    if ([otherGestureRecognizer.view isKindOfClass:NSClassFromString(@"UILayoutContainerView")]) {
        // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
        if (otherGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

#pragma mark - Custom Delegate


#pragma mark - Event Response

#pragma mark push
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        view.backgroundColor = [UIColor clearColor];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"back_black"]];
        imageView.center = view.center;
        [view addSubview:imageView];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height)];
        [button addTarget:self action:@selector(didTapBackButton) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    } else {
        viewController.hidesBottomBarWhenPushed = NO;
    }
    [super pushViewController:viewController animated:YES];
}


- (void)didTapBackButton
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - Network Requests


#pragma mark - Public Methods


#pragma mark - Private Methods


#pragma mark - Setters


#pragma mark - Getters


@end
