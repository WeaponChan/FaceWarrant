//
//  FWRecommendFaceCell.m
//  FaceWarrant
//
//  Created by FW on 2018/9/7.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWRecommendFaceCell.h"
#import "UIButton+Lhkh.h"
#import "FWDiscoveryFaceModel.h"
#import "FWHomeManager.h"

#define cellWidth (Screen_W-30)/2
@interface FWRecommendFaceCell()
@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UILabel *faceNameLab;
@property (nonatomic, strong) UILabel *faceDescLab;
@property (nonatomic, strong) UIButton *faceAttenBtn;
@property (nonatomic, strong) UILabel *countLab;
@property (nonatomic, strong) FWDiscoveryFaceModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation FWRecommendFaceCell

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
        [self.contentView addSubview:self.countLab];
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
    
    [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
    }];
}
#pragma mark - System Delegate

#pragma mark - Custom Delegate

#pragma mark - Event Response
- (void)attenClick
{
    
    DLog(@"关注");
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"faceId":self.model.userId,
                            @"isAttention":self.model.isAttentioned
                            };
    [self actionattented:param];
 
}
#pragma mark - Network Requests

- (void)actionattented:(NSDictionary*)params
{
    [FWHomeManager actionHomeAttentedFaceWithParameter:params result:^(id response) {
        if (response && response[@"success"] && [response[@"success"] isEqual:@1]) {
            NSInteger zan = self.model.cnt.integerValue;
            if ([self.model.isAttentioned isEqualToString:@"0"]) {
                [self.faceAttenBtn setImage:Image(@"xinSel") forState:UIControlStateNormal];
                zan = zan+1;
                self.model.isAttentioned = @"1";
            }else{
                [self.faceAttenBtn setImage:Image(@"xin") forState:UIControlStateNormal];
                zan = zan-1;
                self.model.isAttentioned = @"0";
            }
            [self.faceAttenBtn setTitle:[NSString stringWithFormat:@"%ld",zan] forState:UIControlStateNormal];
            self.model.cnt = [NSString stringWithFormat:@"%ld",zan];
            if ([self.delegate respondsToSelector:@selector(FWRecommendFaceCellDelegateClickWithID:faceId:isAtten:indexPath:)]) {
                [self.delegate FWRecommendFaceCellDelegateClickWithID:[USER_DEFAULTS objectForKey:UD_UserID] faceId:self.model.userId isAtten:self.model.isAttentioned indexPath:self.indexPath];
            }
//            [MBProgressHUD showSuccess:response[@"resultDesc"]];
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

- (void)configCellWithData:(FWDiscoveryFaceModel*)model indexPath:(NSIndexPath*)indexPath
{
    
    self.model = model;
    self.indexPath = indexPath;
    self.faceNameLab.text = model.trueName;
    [self.faceImageView  sd_setImageWithURL:URL(model.portraitUrl) placeholderImage:Image_placeHolder354];
    NSString *cnt = @"";
    if (model.cnt.floatValue > 9999) {
        cnt = [NSString stringWithFormat:@"%.1f万",model.cnt.floatValue/10000];
    }else{
        cnt = model.cnt;
    }
    [self.faceAttenBtn setTitle:cnt forState:UIControlStateNormal];
    if ([self.model.isAttentioned isEqualToString:@"0"]) {
        [self.faceAttenBtn setImage:Image(@"xin") forState:UIControlStateNormal];
    }else{
        [self.faceAttenBtn setImage:Image(@"xinSel") forState:UIControlStateNormal];
    }
    self.faceDescLab.text = model.standing;
    self.countLab.hidden = YES;
//    if ([model.hasNew isEqualToString:@"1"]) {
//        self.countLab.hidden = NO;
//    }else{
//        self.countLab.hidden = YES;
//    }
//    self.countLab.text = model.hasNewReleaseGoods;
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

- (UILabel*)countLab
{
    if (_countLab == nil) {
        _countLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _countLab.layer.cornerRadius = 10.f;
        _countLab.layer.masksToBounds = YES;
        _countLab.backgroundColor = [UIColor redColor];
        _countLab.textColor = Color_White;
        _countLab.font = systemFont(10);
    }
    return _countLab;
}

#pragma mark - Getters



@end
