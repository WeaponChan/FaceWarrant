//
//  FWOpinionAlertVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWOpinionAlertVC.h"

@interface FWOpinionAlertVC ()
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation FWOpinionAlertVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bgView.layer.cornerRadius = 5.f;
    self.bgView.layer.masksToBounds = YES;
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (IBAction)sureClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:Notif_OpinionAlertOK object:nil userInfo:nil];
}

#pragma mark - Network Requests


#pragma mark - Public Methods


#pragma mark - Private Methods


#pragma mark - Setters


#pragma mark - Getters


@end
