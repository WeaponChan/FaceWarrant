//
//  FWFacelibrarySearchCell.m
//  FaceWarrant
//
//  Created by FW on 2018/9/14.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFacelibrarySearchCell.h"
#import "FWFacelibrarySearchFaceModel.h"
#import "FWHomeManager.h"
#define cellWidth (Screen_W-30)/2
@interface FWFacelibrarySearchCell()
@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UILabel *faceNameLab;
@property (nonatomic, strong) UILabel *faceDescLab;
@property (nonatomic, strong) UIButton *faceAttenBtn;

@property (nonatomic, strong) FWFacelibrarySearchFaceModel *model;
@end

@implementation FWFacelibrarySearchCell

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

- (void)attenClick
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"faceId":self.model.faceId,
                            @"isAttention":self.model.isAttention
                            };
    [self actionattented:param];
}

#pragma mark - Network Requests

- (void)actionattented:(NSDictionary*)params
{
    [FWHomeManager actionHomeAttentedFaceWithParameter:params result:^(id response) {
        if (response && response[@"success"] && [response[@"success"] isEqual:@1]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadBrandData" object:nil];
        }else{
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }
    }];
}


#pragma mark - Public Methods
+ (CGSize)cellSize
{
    return CGSizeMake(cellWidth, cellWidth+60);
}


- (void)configCellWithData:(FWFacelibrarySearchFaceModel*)model indexPath:(NSIndexPath*)indexPath
{
    self.model = model;
    self.faceNameLab.text = model.faceName;
    [self.faceImageView  sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image_placeHolder354];
    NSString *cnt = @"";
    if (model.fansCount.floatValue > 9999) {
        cnt = [NSString stringWithFormat:@"%.1f万",model.fansCount.floatValue/10000];
    }else{
        cnt = model.fansCount;
    }
    [self.faceAttenBtn setTitle:cnt forState:UIControlStateNormal];
    self.faceDescLab.text = model.standing;
    if ([model.isAttention isEqualToString:@"1"]) {
        [_faceAttenBtn setImage:[UIImage imageNamed:@"xinSel"] forState:UIControlStateNormal];
    }else{
        [_faceAttenBtn setImage:[UIImage imageNamed:@"xin"] forState:UIControlStateNormal];
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
        [_faceAttenBtn setImage:[UIImage imageNamed:@"xin"] forState:UIControlStateNormal];
        _faceAttenBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;//居右显示
        [_faceAttenBtn addTarget:self action:@selector(attenClick) forControlEvents:UIControlEventTouchUpInside];
        _faceAttenBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
    }
    return _faceAttenBtn;
}


#pragma mark - Getters



@end
