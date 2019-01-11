//
//  FWFaceLibraryHomeCell.m
//  FaceWarrant
//
//  Created by FW on 2018/8/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFaceLibraryHomeCell.h"
#import "FWFaceReleaseModel.h"
#define cellWidth (Screen_W-30)/2
#define cellHeight 200*Screen_W/((Screen_W-30)/2)
@interface FWFaceLibraryHomeCell()
@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UILabel *faceNameLab;
@property (nonatomic, strong) UILabel *faceDescLab;
@property (nonatomic, strong) UIButton *faceAttenBtn;
@property (nonatomic, strong) UIButton *faceBuyBtn;
@property (nonatomic, strong) UIImageView *isNewImg;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) FWFaceReleaseModel *model;
@end

@implementation FWFaceLibraryHomeCell

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        [self.contentView addSubview:self.faceImageView];
        [self.contentView addSubview:self.faceNameLab];
        [self.contentView addSubview:self.faceDescLab];
        [self.contentView addSubview:self.faceAttenBtn];
        [self.contentView addSubview:self.faceBuyBtn];
        [self.contentView addSubview:self.isNewImg];
        [self.contentView addSubview:self.playBtn];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews


- (void)layoutCustomViews
{
    
    [self.faceDescLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    [self.faceBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.width.offset(50);
        make.right.equalTo(self.contentView).offset(-5);
        make.centerY.equalTo(self.faceDescLab.mas_centerY);
    }];
    
    [self.faceAttenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(14);
        make.width.offset(50);
        make.right.equalTo(self.contentView).offset(-5);
        make.bottom.equalTo(self.faceDescLab.mas_top).offset(-5);
    }];
    
    [self.faceNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.contentView).offset(5);

        make.right.equalTo(self.faceAttenBtn.mas_left).offset(-5);
        make.bottom.equalTo(self.faceDescLab.mas_top).offset(-5);
    }];
    
    [self.faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-50);
    }];
    
    [self.isNewImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(20);
        make.top.equalTo(self.faceImageView).offset(5);
        make.right.equalTo(self.faceImageView).offset(-5);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(30);
        make.centerX.equalTo(self.faceImageView.mas_centerX);
        make.centerY.equalTo(self.faceImageView.mas_centerY);
    }];
}


#pragma mark - System Delegate

#pragma mark - Custom Delegate

#pragma mark - Event Response

#pragma mark - Network Requests

#pragma mark - Public Methods
+ (CGSize)cellSize
{
    return CGSizeMake(0, 0);
}


- (void)configCellWithData:(FWFaceReleaseModel*)model indexPath:(NSIndexPath*)indexPath
{
    self.model = model;
    self.faceNameLab.text = model.goodsName;
    [self.faceImageView  sd_setImageWithURL:URL(model.modelUrl) placeholderImage:Image_placeHolder100];
    NSString *favoriteCount = @"";
    if (model.favoriteCount.floatValue > 9999) {
        favoriteCount = [NSString stringWithFormat:@"%.1f万",model.favoriteCount.floatValue/10000];
    }else{
        favoriteCount = model.favoriteCount;
    }
    [self.faceAttenBtn setTitle:favoriteCount forState:UIControlStateNormal];
    [self.faceBuyBtn setTitle:model.buyNo forState:UIControlStateNormal];
    self.faceDescLab.text = model.createTime;
    
    if ([model.isNew isEqualToString:@"0"]) {
        self.isNewImg.hidden = NO;
    }else{
        self.isNewImg.hidden = YES;
    }
    
    if ([model.modelType isEqualToString:@"1"]) {
        self.playBtn.hidden = NO;
    }else{
        self.playBtn.hidden = YES;
    }
}

#pragma mark - Private Methods

#pragma mark - Setters
- (UIImageView*)faceImageView
{
    if (_faceImageView == nil) {
        _faceImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _faceImageView;
}

- (UILabel*)faceNameLab
{
    if (_faceNameLab == nil) {
        _faceNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _faceNameLab.textColor = Color_MainText;
        _faceNameLab.font = systemFont(14);
    }
    return _faceNameLab;
}

- (UILabel*)faceDescLab
{
    if (_faceDescLab == nil) {
        _faceDescLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _faceDescLab.textColor = Color_SubText;
        _faceDescLab.font = systemFont(12);
    }
    return _faceDescLab;
}

- (UIButton*)faceAttenBtn
{
    if (_faceAttenBtn == nil) {
        _faceAttenBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_faceAttenBtn setTitleColor:[UIColor colorWithHexString:@"2c2c2c"] forState:UIControlStateNormal];
        _faceAttenBtn.titleLabel.font = systemFont(10);
        [_faceAttenBtn setImage:[UIImage imageNamed:@"gray_xiao"] forState:UIControlStateNormal];
        _faceAttenBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//居右显示
        _faceAttenBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
    }
    return _faceAttenBtn;
}

- (UIButton*)faceBuyBtn
{
    if (_faceBuyBtn == nil) {
        _faceBuyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_faceBuyBtn setTitleColor:[UIColor colorWithHexString:@"2c2c2c"] forState:UIControlStateNormal];
        _faceBuyBtn.titleLabel.font = systemFont(10);
        [_faceBuyBtn setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
        _faceBuyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//居右显示
        _faceBuyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
    }
    return _faceBuyBtn;
}

- (UIImageView*)isNewImg
{
    if (_isNewImg == nil) {
        _isNewImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _isNewImg.image = Image(@"red_dot");
    }
    return _isNewImg;
}


- (UIButton *)playBtn
{
    if (_playBtn == nil) {
        _playBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_playBtn setImage:Image(@"warrant_play") forState:UIControlStateNormal];
        _playBtn.userInteractionEnabled = NO;
    }
    return _playBtn;
}


#pragma mark - Getters



@end
