//
//  FWTabBarViewController.m
//  FaceWarrant
//
//  Created by LHKH on 2018/6/8.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWTabBarViewController.h"
#import "FWHomeVC.h"
#import "FWWarrantVC.h"
#import "FWDiscoveryVC.h"
#import "FWMessageVC.h"
#import "FWMeVC.h"
#import "FWFaceLibraryVC.h"

@interface FWTabBarViewController ()<UITabBarControllerDelegate>

@property(strong, nonatomic)LhkhNavigationController *HomeNavc;
@property(strong, nonatomic)LhkhNavigationController *FaceLibNavc;
@property(strong, nonatomic)FWFaceLibraryVC *faceLibVC;
@property(strong, nonatomic)LhkhNavigationController *WarrantNavc;
@property(strong, nonatomic)LhkhNavigationController *MessageNavc;
@property(strong, nonatomic)LhkhNavigationController *DiscoveryNavc;
@property(strong, nonatomic)LhkhNavigationController *MeNavc;
@end

@implementation FWTabBarViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    self.view.backgroundColor = Color_MainBg;
    [self setupChildVC];
    [self modifyTabarTopLine];
}


#pragma mark - Layout SubViews



#pragma mark - System Delegate

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    NSString *changeStatus = [USER_DEFAULTS objectForKey:UD_FaceLibraryChange];
    if ([changeStatus isEqualToString:@"1"]) {
        if ([tabBarController.selectedViewController isEqual:self.FaceLibNavc]) {
            // 判断再次选中的是否为当前的控制器
            if ([viewController isEqual:tabBarController.selectedViewController]) {
                // 执行操作
                [self.faceLibVC refreshData];
            }
        }
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    // 判断哪个界面要需要再次点击刷新，这里以第一个VC为例
    /*
    if ([tabBarController.selectedViewController isEqual:self.FaceLibNavc]) {
        // 判断再次选中的是否为当前的控制器
        if ([viewController isEqual:tabBarController.selectedViewController]) {
            // 执行操作
            [self.faceLibVC refreshData];

            return NO;
        }
    }*/
    return YES;
}

#pragma mark - Custom Delegate




#pragma mark - Event Response




#pragma mark - Network requests



#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setupChildVC
{
    FWHomeVC *homeVC = [FWHomeVC new];
    self.HomeNavc = [[LhkhNavigationController alloc] initWithRootViewController:homeVC];
    [self setupChildVC: self.HomeNavc title:@"首页" unselectedimage:@"home" selectedImage:@"homeSel"];
    
    self.faceLibVC = [FWFaceLibraryVC new];
    self.FaceLibNavc = [[LhkhNavigationController alloc] initWithRootViewController:self.faceLibVC];
    [self setupChildVC: self.FaceLibNavc title:@"Face库" unselectedimage:@"facelibrary" selectedImage:@"facelibrarySel"];
    
    FWWarrantVC *warrantVC = [FWWarrantVC new];
    self.WarrantNavc = [[LhkhNavigationController alloc] initWithRootViewController:warrantVC];
    [self setupChildVC: self.WarrantNavc title:@"碑它" unselectedimage:@"warrant" selectedImage:@"warrant"];
    self.WarrantNavc.tabBarItem.imageInsets = UIEdgeInsetsMake(-13.5, 0,13.5, 0);
    
    FWDiscoveryVC *discoveryVC = [FWDiscoveryVC new];
    self.DiscoveryNavc = [[LhkhNavigationController alloc] initWithRootViewController:discoveryVC];
    [self setupChildVC: self.DiscoveryNavc title:@"发现" unselectedimage:@"discovery" selectedImage:@"discoverySel"];

    FWMeVC *meVC = [FWMeVC new];
    self.MeNavc = [[LhkhNavigationController alloc] initWithRootViewController:meVC];
    [self setupChildVC: self.MeNavc title:@"我的" unselectedimage:@"me" selectedImage:@"meSel"];
    
    [[UITabBar appearance] setBarTintColor:Color_White];
    [UITabBar appearance].translucent = NO;
    
}


- (void)setupChildVC:(UINavigationController *)viewController title:(NSString *)title unselectedimage:(NSString *)image selectedImage:(NSString *)selectedImage
{
    viewController.tabBarItem.title = title;
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:Color_Theme_Pink,NSFontAttributeName:[UIFont systemFontOfSize:14]} forState:UIControlStateSelected];
    
    viewController.tabBarItem.image = viewController.tabBarItem.selectedImage = [UIImage js_renderingModelOriginalWithImageName:image];
    viewController.tabBarItem.selectedImage = [UIImage js_renderingModelOriginalWithImageName:selectedImage];
    
    [self addChildViewController:viewController];
}


//去掉tabbar上面的横线
-(void)removeTabarTopLine
{
    CGRect rect = CGRectMake(0, 0, Screen_W, Screen_H);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setBackgroundImage:img];
    [self.tabBar setShadowImage:img];
    self.tabBar.backgroundColor = Color_White;
    
}


//修改tabbar上面的横线颜色
-(void)modifyTabarTopLine
{
    CGRect rect = CGRectMake(0, 0, Screen_W, 0.3);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   RGB_COLOR(220, 220, 220).CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [self.tabBar setShadowImage:img];
    [self.tabBar setBackgroundImage:[[UIImage alloc]init]];
    
}


#pragma mark - Setters

- (FWFaceLibraryVC*)faceLibVC
{
    if (_faceLibVC == nil) {
        _faceLibVC = [FWFaceLibraryVC new];
    }
    return _faceLibVC;
}


#pragma mark - Getters




@end
