//
//  FWBaseViewController.m
//  FaceWarrant
//
//  Created by LHKH on 2018/6/8.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
#import "FWLoginVC.h"
#import "FWRegisterVC.h"
#import "FWMeVC.h"
#import "FWRegisterInfoVC.h"
#import "FWForgetPwdVC.h"
#import "FWPersonalHomePageVC.h"
#import "FWIntegralVC.h"
#import "FWIntegralRuleVC.h"
#import "FWFaceValueVC.h"
#import "FWCountryVC.h"
#import "FWBindPhoneVC.h"
#import "FWBrandDetailVC.h"
#import "FWHomeVC.h"
@interface FWBaseViewController ()
@property (nonatomic, strong) UIImageView *shadowImage;
@end

@implementation FWBaseViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = Color_MainBg;
    self.navigationController.navigationBar.barTintColor = Color_White;
    self.shadowImage = [self getLineViewInNavigationBar:self.navigationController.navigationBar];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.shadowImage.hidden = YES;
    if ([self isKindOfClass:[FWLoginVC class]] || [self isKindOfClass:[FWRegisterVC class]] || [self isKindOfClass:[FWForgetPwdVC class]] || [self isKindOfClass:[FWBindPhoneVC class]] || [self isKindOfClass:[FWRegisterInfoVC class]] || [self isKindOfClass:[FWCountryVC class]] || [self isKindOfClass:[FWIntegralVC class]]  || [self isKindOfClass:[FWIntegralRuleVC class]]  || [self isKindOfClass:[FWFaceValueVC class]]  || [self isKindOfClass:[FWBrandDetailVC class]] || [self isKindOfClass:[FWPersonalHomePageVC class]] || [self isKindOfClass:[FWMeVC class]]) {
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if ([self isKindOfClass:[FWLoginVC class]] || [self isKindOfClass:[FWRegisterVC class]] || [self isKindOfClass:[FWForgetPwdVC class]] || [self isKindOfClass:[FWBindPhoneVC class]] || [self isKindOfClass:[FWRegisterInfoVC class]] || [self isKindOfClass:[FWCountryVC class]] || [self isKindOfClass:[FWIntegralVC class]]  || [self isKindOfClass:[FWIntegralRuleVC class]]  || [self isKindOfClass:[FWFaceValueVC class]]  || [self isKindOfClass:[FWBrandDetailVC class]] || [self isKindOfClass:[FWPersonalHomePageVC class]] || [self isKindOfClass:[FWMeVC class]]) {
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
    }
}

#pragma mark - Layout SubViews




#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response



#pragma mark - Network requests




#pragma mark - Public Methods




#pragma mark - Private Methods


//找到导航栏最下面黑线视图
- (UIImageView *)getLineViewInNavigationBar:(UIView *)view
{
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self getLineViewInNavigationBar:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}



#pragma mark - Setters




#pragma mark - Getters




@end
