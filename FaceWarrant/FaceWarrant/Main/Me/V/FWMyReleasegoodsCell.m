//
//  FWMyReleasegoodsCell.m
//  FaceWarrant
//
//  Created by FW on 2018/8/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMyReleasegoodsCell.h"
#import "FWFaceReleaseModel.h"
//#import <AVKit/AVKit.h>
//#import <AVFoundation/AVFoundation.h>
#define cellWidth (Screen_W-30)/2
@interface FWMyReleasegoodsCell()<UIAlertViewDelegate>
//{
//    NSString *_netWorkStatus;
//}
@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UILabel *faceNameLab;
@property (nonatomic, strong) UILabel *faceDescLab;
@property (nonatomic, strong) UIButton *faceAttenBtn;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) FWFaceReleaseModel *model;
@property (nonatomic, strong) UIButton *playBtn;
//@property (nonatomic, strong) AVPlayerViewController *playerVC;
//@property (nonatomic, strong) AVPlayer *player;
//@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation FWMyReleasegoodsCell

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5.f;
        self.layer.masksToBounds = YES;
        [self.contentView addSubview:self.faceImageView];
//        [self.contentView addSubview:self.playerVC.view];
        [self.contentView addSubview:self.playBtn];
        [self.contentView addSubview:self.faceNameLab];
        [self.contentView addSubview:self.faceDescLab];
        [self.contentView addSubview:self.faceAttenBtn];
        [self.contentView addSubview:self.buyBtn];
        [self.contentView addSubview:self.delBtn];
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
        make.right.equalTo(self.buyBtn.mas_left).offset(-5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.width.offset(50);
        make.right.equalTo(self.contentView).offset(-5);
        make.centerY.equalTo(self.faceDescLab.mas_centerY);
    }];
    
    [self.faceNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.faceAttenBtn.mas_left).offset(-5);
        make.bottom.equalTo(self.faceDescLab.mas_top).offset(-5);
    }];
    
    [self.faceAttenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(14);
        make.width.offset(50);
        make.right.equalTo(self.contentView).offset(-5);
        make.centerY.equalTo(self.faceNameLab.mas_centerY);
    }];
    
    
    [self.faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.contentView);
        make.bottom.equalTo(self.faceNameLab.mas_top).offset(-15);
    }];
    
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(30);
        make.centerX.equalTo(self.faceImageView.mas_centerX);
        make.centerY.equalTo(self.faceImageView.mas_centerY);
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
    if ([self.delegate respondsToSelector:@selector(FWMyReleasegoodsCellDelegateDeleteClick:indexPath:)]) {
        [self.delegate FWMyReleasegoodsCellDelegateDeleteClick:self.model.releaseGoodsId indexPath:self.indexPath];
    }
}

#pragma mark - Network Requests

#pragma mark - Public Methods
+ (CGSize)cellSize
{
    return CGSizeMake(cellWidth, cellWidth +60);
}

- (void)configCellWithData:(FWFaceReleaseModel*)model isEdit:(BOOL)isEdit indexPath:(NSIndexPath*)indexPath
{
    self.model = model;
    self.indexPath = indexPath;
    if ([model.modelType isEqualToString:@"1"]) {
        self.playBtn.hidden = NO;
    }else{
        self.playBtn.hidden = YES;
    }
    [self.faceImageView sd_setImageWithURL:URL(model.modelUrl) placeholderImage:Image_placeHolder354];
    self.faceNameLab.text = model.goodsName;
    self.faceDescLab.text = model.createTime;
    [self.faceAttenBtn setTitle:model.favoriteCount forState:UIControlStateNormal];
    [self.buyBtn setTitle:model.buyNo forState:UIControlStateNormal];
    if (isEdit == YES) {
        self.delBtn.hidden = NO;
    }else{
        self.delBtn.hidden = YES;
    }
    if (model.isSelected == YES) {
        [self.delBtn setImage:Image(@"checkBoxSel") forState:UIControlStateNormal];
    }else{
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

- (UIButton*)buyBtn
{
    if (_buyBtn == nil) {
        _buyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buyBtn setTitleColor:[UIColor colorWithHexString:@"2c2c2c"] forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = systemFont(10);
        [_buyBtn setImage:[UIImage imageNamed:@"shopCar"] forState:UIControlStateNormal];
        _buyBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//居右显示
        _buyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
    }
    return _buyBtn;
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
