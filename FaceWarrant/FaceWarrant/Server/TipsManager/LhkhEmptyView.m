//
//  LhkhEmptyView.m
//  LhkhEmptyView
//
//  Created by LHKH on 2018/2/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "LhkhEmptyView.h"
#import "FWQuestionVC.h"

@interface LhkhEmptyView()

@end

@implementation LhkhEmptyView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = Color_MainBg;
        [self addSubview:self.tipsImage];
        [self addSubview:self.tipsLabel];
        [self addSubview:self.tipsButton];
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.tipsImage setFrame:CGRectMake((self.frame.size.width - 170)/2, (self.frame.size.height - 170)/2 - 80, 170, 170)];
    [self.tipsLabel setFrame:CGRectMake(0, CGRectGetMaxY(self.tipsImage.frame) + 20, self.frame.size.width, 20)];
    [self.tipsButton setFrame:CGRectMake(0, CGRectGetMaxY(self.tipsLabel.frame) + 20, self.frame.size.width, 20)];
    
//    [self.tipsImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.width.offset(170);
//        make.centerX.equalTo(self.mas_centerX);
//        make.centerY.equalTo(self.mas_centerY);
//    }];
//
//    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(20);
//        make.top.equalTo(self.tipsImage.mas_bottom).offset(20);
//        make.left.equalTo(self).offset(10);
//        make.right.equalTo(self).offset(-10);
//    }];
//
//    [self.tipsButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(20);
//        make.top.equalTo(self.tipsLabel.mas_bottom).offset(20);
//        make.left.equalTo(self).offset(10);
//        make.right.equalTo(self).offset(-10);
//    }];
}


#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response

- (void)click
{
    if (self.type == TipsType_HaveNoQuestion) {
        FWQuestionVC *vc = [[FWQuestionVC alloc] init];
        [[self superViewController:self].navigationController pushViewController:vc animated:YES];
    }else if (self.type == TipsType_HaveNoFavourite){
        [[self superViewController:self].tabBarController setSelectedIndex:0];
    }
}


#pragma mark - Network requests




#pragma mark - Public Methods




#pragma mark - Private Methods

#pragma mark 获取当前View所在的ViewController
- (UIViewController *)superViewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}



#pragma mark - Setters

- (UIImageView *)tipsImage
{
    if (!_tipsImage) {
        _tipsImage = [[UIImageView alloc] init];
    }
    return _tipsImage;
}


- (UILabel *)tipsLabel
{
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = systemFont(14);
        _tipsLabel.textColor = Color_MainText;
        _tipsLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tipsLabel;
}

- (UIButton *)tipsButton
{
    if(!_tipsButton){
        _tipsButton = [[UIButton alloc]init];
        _tipsButton.titleLabel.font = systemFont(14);
        [_tipsButton setTitleColor:[UIColor colorWithHexString:@"#3D84FA"] forState:UIControlStateNormal];
        _tipsButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_tipsButton addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _tipsButton;
}

#pragma mark - Getters



@end
