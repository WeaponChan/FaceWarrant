//
//  FWFaceAlertVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/21.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFaceAlertVC.h"

#import "FWPersonalHomePageVC.h"
#import "FWQuestionVC.h"


@interface FWFaceAlertVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *faceName;
@property (weak, nonatomic) IBOutlet UIButton *facehomeBtn;

@end

@implementation FWFaceAlertVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSubView];
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (IBAction)pageHomeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *kwindow = [UIApplication sharedApplication].keyWindow;
        LhkhNavigationController *nav = (LhkhNavigationController*)kwindow.rootViewController;
        FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
        vc.faceId = self.model.faceId;
        [nav.viewControllers.lastObject pushViewController:vc animated:YES];
    });
}

- (IBAction)questionClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIWindow *kwindow = [UIApplication sharedApplication].keyWindow;
        LhkhNavigationController *nav = (LhkhNavigationController*)kwindow.rootViewController;
        FWQuestionVC *vc = [FWQuestionVC new];
        NSArray *tempArr = [NSArray arrayWithObject:self.model];
        vc.faceArr = tempArr;
        [nav.viewControllers.lastObject pushViewController:vc animated:YES];
    });
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - Network Requests


#pragma mark - Public Methods

- (void)configViewWithModel:(FWAttentionModel*)model
{
    self.faceName.text = model.faceName;
    [self.headImg sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image_placeHolder80];
    self.facehomeBtn.layer.borderColor = Color_Line.CGColor;
    self.facehomeBtn.layer.borderWidth = 1.f;
}

#pragma mark - Private Methods

- (void)setSubView
{
    self.faceName.text = self.model.faceName;
    [self.headImg sd_setImageWithURL:URL(self.model.headUrl) placeholderImage:Image_placeHolder80];
    self.facehomeBtn.layer.borderColor = Color_Line.CGColor;
    self.facehomeBtn.layer.borderWidth = 1.f;
}

#pragma mark - Setters


#pragma mark - Getters


@end
