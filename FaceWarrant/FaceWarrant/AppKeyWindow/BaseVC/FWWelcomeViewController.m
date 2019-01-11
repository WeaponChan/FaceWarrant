//
//  FWWelcomeViewController.m
//  FaceWarrant
//
//  Created by LHKH on 2018/6/8.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWelcomeViewController.h"

@interface FWWelcomeViewController ()
@property (nonatomic, strong) UIImageView *bgImageView;
@end

@implementation FWWelcomeViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:self.bgImageView];
    
    if (IS_iPhone_4S) {
        self.bgImageView.image = [UIImage imageNamed:@"640x960"];
    }else if (IS_iPhone_5) {
        self.bgImageView.image = [UIImage imageNamed:@"640x1136"];
    }else if (IS_iPhone_6) {
        self.bgImageView.image = [UIImage imageNamed:@"750X1334"];
    }else if (IS_iPhone6_Plus) {
        self.bgImageView.image = [UIImage imageNamed:@"1242x2208"];
    }else if (IS_iPhoneX) {
        self.bgImageView.image = [UIImage imageNamed:@"1125x2436"];
    }else if (IS_iPhoneXr) {
        self.bgImageView.image = [UIImage imageNamed:@"828x1792"];
    }else if (IS_iPhoneXs) {
        self.bgImageView.image = [UIImage imageNamed:@"1125x2436"];
    }else if (IS_iPhoneXs_Max) {
        self.bgImageView.image = [UIImage imageNamed:@"1242x2688"];
    }
}


#pragma mark - Layout SubViews




#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response




#pragma mark - Network requests




#pragma mark - Public Methods

- (void)welcomeViewStartAnimationWithCompletion:(completionBlock)block
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
        [UIView animateWithDuration:0.2 animations:^{
                
            self.view.alpha = 0;
                
        } completion:^(BOOL finished) {
                
            if (block) {
                    block();
            }
                
        }];
            
    });
        
}


#pragma mark - Private Methods




#pragma mark - Setters

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _bgImageView;
}


#pragma mark - Getters




@end
