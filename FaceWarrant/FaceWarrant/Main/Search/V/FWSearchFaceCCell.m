//
//  FWSearchFaceCCell.m
//  FaceWarrant
//
//  Created by FW on 2018/8/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWSearchFaceCCell.h"
#import "FWSearchFaceModel.h"
#define cellWidth (Screen_W-30)/2
@interface FWSearchFaceCCell()

@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UILabel *faceNameLab;
@property (nonatomic, strong) UILabel *faceDescLab;
@property (nonatomic, strong) UIButton *faceAttenBtn;
@property (nonatomic, strong) FWSearchFaceModel *model;
@end

@implementation FWSearchFaceCCell

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
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    [self.faceImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(cellWidth);
        make.height.offset(cellWidth);
        make.left.right.top.equalTo(self.contentView);
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
        make.top.equalTo(self.faceImageView.mas_bottom).offset(18);
    }];
    
    [self.faceDescLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(self.faceNameLab.mas_bottom).offset(5);
        make.left.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
}



#pragma mark - System Delegate

#pragma mark - Custom Delegate

#pragma mark - Event Response

#pragma mark - Network Requests

#pragma mark - Public Methods
+ (CGSize)cellSize
{
    return CGSizeMake(cellWidth, cellWidth+60);
}

- (void)configCellWithModel:(FWSearchFaceModel*)model indexPath:(NSIndexPath*)indexPath
{
    self.model = model;
    self.faceNameLab.text = model.faceName;
    [self.faceImageView sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image_placeHolder354];
    [self.faceAttenBtn setTitle:model.fansCount forState:UIControlStateNormal];
    self.faceDescLab.text = model.standing;
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
        [_faceAttenBtn setTitle:@"9999" forState:UIControlStateNormal];
        [_faceAttenBtn setTitleColor:[UIColor colorWithHexString:@"2c2c2c"] forState:UIControlStateNormal];
        _faceAttenBtn.titleLabel.font = systemFont(10);
        [_faceAttenBtn setImage:[UIImage imageNamed:@"xin"] forState:UIControlStateNormal];
        _faceAttenBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//居右显示
        _faceAttenBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
    }
    return _faceAttenBtn;
}

#pragma mark - Getters



@end
