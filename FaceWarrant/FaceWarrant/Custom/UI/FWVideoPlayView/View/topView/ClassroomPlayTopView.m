//
//  ClassroomPlayTopView.m
//  NWMJ_C
//
//  Created by 项正 on 2018/9/11.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import "ClassroomPlayTopView.h"

#define kALYPVColorTextNomal                     [UIColor colorWithRed:(231 / 255.0) green:(231 / 255.0) blue:(231 / 255.0) alpha:1]

static const CGFloat ALYPVTopViewTitleLabelMargin = 8;  //标题 间隙
static const CGFloat ALYPVTopViewBackButtonWidth  = 24; //返回按钮宽度
static const CGFloat ALYPVTopViewDownLoadButtonWidth  = 30; //返回按钮宽度

@interface ClassroomPlayTopView()

@property (nonatomic, strong) UIImageView *topBarBG;        //背景图片
@property (nonatomic, strong) UILabel *titleLabel;          //标题
@property (nonatomic, strong) UIButton *backButton;         //返回按钮
@property (nonatomic, strong) UIButton *moreButton;        //更多界面展示按钮

@end

@implementation ClassroomPlayTopView

#pragma mark - Life Cycle

- (instancetype)init{
    return  [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.topBarBG];
        [self addSubview:self.titleLabel];
        [self addSubview:self.backButton];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutSubviews{
    [super layoutSubviews];
    
    float width = self.bounds.size.width;
    float height = self.bounds.size.height;
    if (UIInterfaceOrientationPortrait == [[UIApplication sharedApplication] statusBarOrientation]) {
        //竖屏
        self.titleLabel.hidden = YES;//竖屏隐藏标题
        self.backButton.hidden = YES;//竖屏隐藏返回
    }else{
        //横屏
        self.titleLabel.hidden = NO;
        self.backButton.hidden = NO;
    }
    
    self.topBarBG.frame = self.bounds;
    
    self.backButton.frame = CGRectMake(ALYPVTopViewTitleLabelMargin, (height - ALYPVTopViewBackButtonWidth)/2.0, ALYPVTopViewBackButtonWidth, ALYPVTopViewBackButtonWidth);
    
    self.moreButton.frame = CGRectMake(width-ALYPVTopViewTitleLabelMargin-ALYPVTopViewDownLoadButtonWidth, (height - ALYPVTopViewDownLoadButtonWidth)/2.0, ALYPVTopViewDownLoadButtonWidth, ALYPVTopViewDownLoadButtonWidth);
    
    
    CGFloat titleWidth = width - (ALYPVTopViewBackButtonWidth + 2*ALYPVTopViewTitleLabelMargin) - (ALYPVTopViewDownLoadButtonWidth+2*ALYPVTopViewTitleLabelMargin);
    self.titleLabel.frame = CGRectMake(CGRectGetMaxX(self.backButton.frame)+ALYPVTopViewTitleLabelMargin, 0, titleWidth, height);
    
}



#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response

- (void)backButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onBackViewClickWithClassroomPlayTopView:)]) {
        [self.delegate onBackViewClickWithClassroomPlayTopView:self];
    }
}

- (void)moreButtonClicked:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(onMoreViewClickedWithClassroomPlayTopView:)]) {
        [self.delegate onMoreViewClickedWithClassroomPlayTopView:self];
    }
}

#pragma mark - Network requests




#pragma mark - Public Methods




#pragma mark - Private Methods




#pragma mark - Setters

- (void)setTopTitle:(NSString *)topTitle{
    _topTitle = topTitle;
    self.titleLabel.text = topTitle;
}


#pragma mark - Getters

- (UIImageView *)topBarBG{
    if (!_topBarBG) {
        _topBarBG = [[UIImageView alloc] init];
        _topBarBG.image = [UIImage imageNamed:@"user-视频top"];
    }
    return _topBarBG;
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setTextColor:kALYPVColorTextNomal];
        [_titleLabel setFont:[UIFont systemFontOfSize:18.0f]];
    }
    return _titleLabel;
}

- (UIButton *)backButton{
    if (!_backButton){
        _backButton = [[UIButton alloc] init];
        UIImage *backImage = [UIImage imageNamed:@"user-视频返回"];
        [_backButton setBackgroundImage:backImage forState:UIControlStateNormal];
        [_backButton setBackgroundImage:backImage forState:UIControlStateSelected];
        [_backButton addTarget:self action:@selector(backButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)moreButton{
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

@end
