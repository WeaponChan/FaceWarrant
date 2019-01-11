//
//  FWMyCollectionCell.m
//  FaceWarrant
//
//  Created by FW on 2018/8/24.
//  Copyright © 2018年 LHKH. All rights reserved.
//
#define cellWidth (Screen_W-30)/2
#import "FWMyCollectionCell.h"
#import "FWMyCollectionModel.h"
@interface FWMyCollectionCell()
{
    NSIndexPath *_selectIndexPath;
    NSIndexPath *_indexPath;
    UIButton *_selectBtn;
}
@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UIImageView *userImageView;
@property (nonatomic, strong) UILabel *faceNameLab;
@property (nonatomic, strong) UILabel *faceDescLab;
@property (nonatomic, strong) UIButton *faceAttenBtn;
@property (nonatomic, strong) UIButton *faceBuyBtn;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) FWMyCollectionModel *model;
@end

@implementation FWMyCollectionCell

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        [self.contentView addSubview:self.faceImageView];
        [self.contentView addSubview:self.playBtn];
        [self.contentView addSubview:self.faceNameLab];
        [self.contentView addSubview:self.faceDescLab];
        [self.contentView addSubview:self.faceAttenBtn];
        [self.contentView addSubview:self.faceBuyBtn];
        [self.contentView addSubview:self.coverView];
        [self.contentView addSubview:self.delBtn];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutCustomViews
{
    [self.faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-60);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(30);
        make.centerX.equalTo(self.faceImageView.mas_centerX);
        make.centerY.equalTo(self.faceImageView.mas_centerY);
    }];
    
    [self.faceNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.contentView).offset(5);
        make.top.equalTo(self.faceImageView.mas_bottom).offset(15);
        make.right.equalTo(self.faceAttenBtn.mas_left).offset(-5);
    }];
    
    [self.faceAttenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(14);
        make.width.offset(50);
        make.right.equalTo(self.contentView).offset(-5);
        make.centerY.equalTo(self.faceNameLab.mas_centerY);
    }];
    
    [self.faceBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.width.offset(50);
        make.right.equalTo(self.contentView).offset(-5);
        make.centerY.equalTo(self.faceDescLab.mas_centerY);
    }];
    
    [self.faceDescLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(self.faceNameLab.mas_bottom).offset(5);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.top.equalTo(self.contentView).offset(8);
        make.right.equalTo(self.contentView).offset(-8);
    }];
}

#pragma mark - System Delegate

#pragma mark - Custom Delegate

#pragma mark - Event Response
- (void)deleteClick:(UIButton*)sender
{
    if (self.selectblock) {
        self.selectblock();
    }
}
#pragma mark - Network Requests

#pragma mark - Public Methods
+ (CGSize)cellSize
{
    return CGSizeMake(cellWidth, cellWidth+60);
}

- (void)configCellWithData:(FWMyCollectionModel*)model isEdit:(BOOL)isEdit indexPath:(NSIndexPath*)indexPath
{
    self.model = model;
    _indexPath = indexPath;
    [self.faceImageView sd_setImageWithURL:URL(model.modelUrl) placeholderImage:Image_placeHolder354];
    self.faceNameLab.text = model.goodsName;
    self.faceDescLab.text = model.createTime;
    if (model.favoriteCount == nil) {
        [self.faceAttenBtn setTitle:@"0" forState:UIControlStateNormal];
    }else{
        [self.faceAttenBtn setTitle:model.favoriteCount forState:UIControlStateNormal];
    }
    
    if (model.buyNo == nil) {
        [self.faceBuyBtn setTitle:@"0" forState:UIControlStateNormal];
    }else{
        [self.faceBuyBtn setTitle:model.buyNo forState:UIControlStateNormal];
    }
    
    if ([model.modelType isEqualToString:@"1"]) {
        self.playBtn.hidden = NO;
    }else{
        self.playBtn.hidden = YES;
    }
    
    if ([model.collectStatus isEqualToString:@"2"]) {
        self.coverView.hidden = NO;
    }else{
        self.coverView.hidden = YES;
    }
    
    if (isEdit == YES) {
        self.delBtn.hidden = NO;
    }else{
        self.delBtn.hidden = YES;
    }
    
    if (model.isSel == NO) {
        [self.delBtn setImage:Image(@"checkBox") forState:UIControlStateNormal];
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
- (UIButton *)playBtn
{
    if (_playBtn == nil) {
        _playBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_playBtn setImage:Image(@"warrant_play") forState:UIControlStateNormal];
        _playBtn.userInteractionEnabled = NO;
    }
    return _playBtn;
}

- (UIImageView*)userImageView
{
    if (_userImageView == nil) {
        _userImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _userImageView.layer.cornerRadius = 10.f;
        _userImageView.layer.masksToBounds = YES;
    }
    return _userImageView;
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
        [_faceAttenBtn setImage:Image(@"gray_xiao") forState:UIControlStateNormal];
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

- (UIView*)coverView
{
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:CGRectZero];
        _coverView.alpha = 0.3;
        _coverView.backgroundColor = Color_Black;
    }
    return _coverView;
}

- (UIButton*)delBtn
{
    if (_delBtn == nil) {
        _delBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _delBtn.hidden = YES;
        [_delBtn setImage:Image(@"checkBox") forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(deleteClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delBtn;
}


#pragma mark - Getters



@end
