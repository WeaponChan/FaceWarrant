//
//  FWAttentionCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWAttentionCell.h"
#import "FWAttentionModel.h"
#import "FWContactModel.h"
#import "FWRecommendModel.h"
@interface FWAttentionCell ()
@property (strong, nonatomic)UIImageView *userImg;
@property (strong, nonatomic)UILabel *userName;
@property (strong, nonatomic)UILabel *userDesc;
@property (strong, nonatomic)NSIndexPath *indexPath;
@property (strong, nonatomic)FWAttentionModel *amodel;
@property (strong, nonatomic)FWContactModel *cmodel;
@property (strong, nonatomic)FWRecommendModel *rmodel;
@property (strong, nonatomic)NSString *selTag;
@end

@implementation FWAttentionCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWAttentionCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWAttentionCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.userImg];
        [self.contentView addSubview:self.userName];
        [self.contentView addSubview:self.userDesc];
        [self.contentView addSubview:self.attenBtn];
        
        [self layoutCustomViews];
        
        
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutCustomViews
{
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(35);
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.attenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.offset(80);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.userImg.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.attenBtn.mas_left).offset(-5);
//        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.userDesc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.userName.mas_left);
        make.right.equalTo(self.attenBtn.mas_left).offset(-5);
        make.top.equalTo(self.userName.mas_bottom).offset(5);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = Color_MainBg;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}


#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response

- (void)addAttenClick:(UIButton*)sender
{
    if([sender.titleLabel.text isEqualToString:@"已邀请"]){
        [MBProgressHUD showTips:@"该Face已邀请"];
    }else if([sender.titleLabel.text isEqualToString:@"已添加"]){
        [MBProgressHUD showTips:@"该Face已添加"];
    }else if ([sender.titleLabel.text isEqualToString:@"邀请"]) {
        if ([self.delegate respondsToSelector:@selector(FWAttentionCellDelegateInviteClick:countryCode: indexPath:)]) {
            [self.delegate FWAttentionCellDelegateInviteClick:self.cmodel.mobile countryCode:self.cmodel.countryCode indexPath:self.indexPath];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(FWAttentionCellDelegateAddClick:indexPath:)]) {
            if (self.indexPath.section == 0) {
                [self.delegate FWAttentionCellDelegateAddClick:self.amodel.faceId indexPath:self.indexPath];
            }else{
                if ([self.selTag isEqualToString:@"2"]) {
                    [self.delegate FWAttentionCellDelegateAddClick:self.rmodel.faceId indexPath:self.indexPath];
                }
            }
        }
    }
}


#pragma mark - Network requests




#pragma mark - Public Methods

- (void)configCellWithModel:(FWAttentionModel*)model cmodel:(FWContactModel*)cmodel rmodel:(FWRecommendModel*)rmodel indexPath:(NSIndexPath*)indexPath  type:(NSString *)vcType  tag:(NSString*)tag
{
    self.indexPath = indexPath;
    self.selTag = tag;
    self.amodel = model;
    self.cmodel = cmodel;
    self.rmodel = rmodel;
    if ([vcType isEqualToString:@"FWAddAttentionVC"]) {
        self.attenBtn.hidden = NO;
        if (indexPath.section == 0) {
            [self.userImg sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image_placeHolder80];
            self.userName.text = model.faceName;
            self.userDesc.text = model.standing;
            if (model.isAttened) {
                [_attenBtn setTitle:@"已添加" forState:UIControlStateNormal];
                [_attenBtn setImage:nil forState:UIControlStateNormal];
            }else{
                [_attenBtn setTitle:@"添加" forState:UIControlStateNormal];
                [_attenBtn setImage:nil forState:UIControlStateNormal];
            }
            
        }else{
            if ([tag isEqualToString:@"1"]) {
                [self.userImg sd_setImageWithURL:URL(cmodel.headUrl) placeholderImage:Image(@"contactHeader")];
                if (cmodel.faceName.length>0 && ![cmodel.faceName isEqualToString:@""] && cmodel.faceName != nil) {
                    self.userName.text = [NSString stringWithFormat:@"%@(%@)",cmodel.contactName,cmodel.faceName];
                }else{
                    self.userName.text = cmodel.contactName;
                }
                if ([cmodel.isRegistered isEqualToString:@"0"]) {
                    self.userDesc.text = cmodel.formatMobile;
                    if (cmodel.isInvited) {
                        [_attenBtn setTitle:@"已邀请" forState:UIControlStateNormal];
                        [_attenBtn setImage:nil forState:UIControlStateNormal];
                    }else{
                        [_attenBtn setTitle:@"邀请" forState:UIControlStateNormal];
                        [_attenBtn setImage:nil forState:UIControlStateNormal];
                    }
                }else{
                    self.userDesc.text = cmodel.formatMobile;
                    if (cmodel.isInvited) {
                        [_attenBtn setTitle:@"已添加" forState:UIControlStateNormal];
                        [_attenBtn setImage:nil forState:UIControlStateNormal];
                    }else{
                        [_attenBtn setTitle:@"添加" forState:UIControlStateNormal];
                        [_attenBtn setImage:nil forState:UIControlStateNormal];
                    }
                }
            }else if([tag isEqualToString:@"2"]){
                [self.userImg sd_setImageWithURL:URL(rmodel.headUrl) placeholderImage:Image_placeHolder80];
                self.userName.text = rmodel.faceName;
                self.userDesc.text = rmodel.standing;
                if (rmodel.isAttened) {
                    [_attenBtn setTitle:@"已添加" forState:UIControlStateNormal];
                    [_attenBtn setImage:nil forState:UIControlStateNormal];
                }else{
                    [_attenBtn setTitle:@"添加" forState:UIControlStateNormal];
                    [_attenBtn setImage:nil forState:UIControlStateNormal];
                }
            }
        }
    }else{
        self.attenBtn.hidden = YES;
        [self.userImg sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image_placeHolder80];
        self.userName.text = model.faceName;
        self.userDesc.text = model.standing;
    }
}


#pragma mark - Private Methods



#pragma mark - Setters

- (UIImageView*)userImg
{
    if (_userImg == nil) {
        _userImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _userImg.layer.cornerRadius = 35.f/2;
        _userImg.layer.masksToBounds = YES;
        _userImg.contentMode = UIViewContentModeScaleToFill;
    }
    return _userImg;
}

- (UILabel*)userName
{
    if (_userName == nil) {
        _userName = [[UILabel alloc] initWithFrame:CGRectZero];
        _userName.textColor = Color_MainText;
        _userName.font = systemFont(14);
    }
    return _userName;
}

- (UILabel*)userDesc
{
    if (_userDesc == nil) {
        _userDesc = [[UILabel alloc] initWithFrame:CGRectZero];
        _userDesc.textColor = Color_SubText;
        _userDesc.font = systemFont(12);
    }
    return _userDesc;
}

- (UIButton*)attenBtn
{
    if (_attenBtn == nil) {
        _attenBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _attenBtn.layer.cornerRadius = 5.f;
        _attenBtn.layer.masksToBounds = YES;
        _attenBtn.layer.borderColor = [UIColor colorWithHexString:@"d4d4d4"].CGColor;
        _attenBtn.layer.borderWidth = 1.f;
        [_attenBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_attenBtn setTitleColor:[UIColor colorWithHexString:@"2c2c2c"] forState:UIControlStateNormal];
        _attenBtn.titleLabel.font = systemFont(12);
        [_attenBtn setImage:[UIImage imageNamed:@"me_add"] forState:UIControlStateNormal];
        [_attenBtn addTarget:self action:@selector(addAttenClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attenBtn;
}


#pragma mark - Getters



@end
