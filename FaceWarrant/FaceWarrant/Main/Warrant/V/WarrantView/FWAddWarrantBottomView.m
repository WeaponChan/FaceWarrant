//
//  FWAddWarrantBottomView.m
//  FaceWarrant
//
//  Created by FW on 2018/9/5.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWAddWarrantBottomView.h"

@interface FWAddWarrantBottomView()
@property (weak, nonatomic) IBOutlet UILabel *itemLab;
@property (weak, nonatomic) IBOutlet UIView *cameraView;
@property (weak, nonatomic) IBOutlet UILabel *lab1;
@property (weak, nonatomic) IBOutlet UILabel *lab2;
@property (weak, nonatomic) IBOutlet UILabel *lab3;
@property (weak, nonatomic) IBOutlet UILabel *albumLab;
@property (weak, nonatomic) IBOutlet UILabel *cameraLab;
@property (weak, nonatomic) IBOutlet UILabel *videoLab;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation FWAddWarrantBottomView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.cameraView.layer.cornerRadius = 35.f;
    self.cameraView.layer.masksToBounds = YES;
    self.cameraView.layer.borderColor = [UIColor colorWithHexString:@"d4d4d4"].CGColor;
    self.cameraView.layer.borderWidth = 2.f;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTitleAndImg) name:Notif_ChangeBtnTitleAndImg object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Notif_ChangeBtnTitleAndImg object:nil];
}

#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response


- (IBAction)ButtonClick:(UIButton *)sender {
    if (sender.tag == 6) {
        sender.selected = !sender.selected;
    }
    if (self.tagBlock) {
        self.tagBlock(sender.tag);
    }
}

- (void)changeTitleAndImg
{
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureBtn setBackgroundImage:nil forState:UIControlStateNormal];
}

#pragma mark - Network Requests


#pragma mark - Public Methods


#pragma mark - Private Methods


#pragma mark - Setters


#pragma mark - Getters



@end
