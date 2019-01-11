//
//  FWMAppreciateCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMAppreciateCell.h"
#import "FWMessageAModel.h"
#import "FWCommentListVC.h"
#import "FWWarrantDetailVC.h"
#import "FWMessageManager.h"
#import "LhkhLabel.h"
#import "FWHomeManager.h"
#import "FWAttenAlertVC.h"
#import "FWPersonalHomePageVC.h"
@interface FWMAppreciateCell ()
@property (nonatomic, strong) UIImageView *userImg;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) LhkhLabel *brandLab;
@property (nonatomic, strong) UIButton *attenBtn;
@property (nonatomic, strong) UIImageView *itemImg;
@property (nonatomic, strong) UIImageView *youImg;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) UIButton *contentBtn;
@property (nonatomic, strong) UIButton *contentImgBtn;
@property (nonatomic, strong) FWMessageAModel *model;
@property (nonatomic, strong) FWAttenAlertVC *alertVC;
@end

@implementation FWMAppreciateCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMAppreciateCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMAppreciateCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWMAppreciateCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.userImg];
        [self.contentView addSubview:self.userName];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.typeLab];
        [self.contentView addSubview:self.brandLab];
        [self.contentView addSubview:self.itemImg];
        [self.contentView addSubview:self.youImg];
        [self.contentView addSubview:self.imgBtn];
        [self.contentView addSubview:self.contentImgBtn];
        [self.contentView addSubview:self.attenBtn];
        [self.contentView addSubview:self.contentBtn];
        
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
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.userImg);
    }];
    
    [self.attenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.offset(60);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.userImg.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.attenBtn.mas_left);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.userName.mas_left);
        make.right.equalTo(self.attenBtn.mas_left);
        make.top.equalTo(self.userName.mas_bottom).offset(5);
    }];
    
    [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(40);
        make.right.equalTo(self.contentView).offset(-20);
        make.top.equalTo(self.timeLab.mas_bottom).offset(10);
    }];
    
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.userName.mas_left);
        make.top.equalTo(self.timeLab.mas_bottom).offset(10);
    }];
    
    [self.brandLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.width.offset(50);
        make.left.equalTo(self.userName.mas_left);
        make.top.equalTo(self.typeLab.mas_bottom).offset(10);
    }];
    
    [self.youImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(15);
        make.height.offset(15);
        make.right.equalTo(self.itemImg).offset(10);
        make.top.equalTo(self.itemImg).offset(-10);
    }];
    
    [self.contentImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.bottom.equalTo(self.contentView);
        make.left.equalTo(self.userName);
    }];
    
    [self.contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.typeLab);
        make.right.equalTo(self.itemImg.mas_left).offset(-10);
    }];
}


#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response

- (void)contentClick
{
//    FWCommentListVC *vc = [FWCommentListVC new];
//    vc.releaseGoodsId = self.model.releaseGoodsId;
//    [[self superViewController:self].navigationController pushViewController:vc animated:YES];
//
//    [self readedMessage];
    if ([self.model.releaseGoodsStatus isEqualToString:@"0"]) {
        [MBProgressHUD showTips:@"此碑它已被删除了额"];
    }else{
        FWWarrantDetailVC *vc = [[FWWarrantDetailVC alloc] init];
        vc.releaseGoodsId = self.model.releaseGoodsId;
        vc.isNew = @"0";
        [[self superViewController:self].navigationController pushViewController:vc animated:YES];
        
        [self readedMessage];
    }
}

- (void)contentImgClick
{
    if ([self.model.releaseGoodsStatus isEqualToString:@"0"]) {
        [MBProgressHUD showTips:@"此碑它已被删除了额"];
    }else{
        FWWarrantDetailVC *vc = [[FWWarrantDetailVC alloc] init];
        vc.releaseGoodsId = self.model.releaseGoodsId;
        vc.isNew = @"0";
        [[self superViewController:self].navigationController pushViewController:vc animated:YES];
        
        [self readedMessage];
    }
}

- (void)attenClick
{
    if ([self.attenBtn.titleLabel.text isEqualToString:@"已关注"]) {
        [self AttenClick:@"1"];
    }else{
        [self AttenClick:@"0"];
    }
}

- (void)imgClick
{
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.faceId = self.model.fromUserId;
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}


#pragma mark - Network requests

- (void)readedMessage
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"messageId":self.model.messageId?:@"",
                            @"type":@"1"
                            };
    [FWMessageManager readedMessageWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
        }
    }];
}

- (void)AttenClick:(NSString*)isAttention
{
    NSDictionary *param = @{
                            @"faceId":self.model.fromUserId,
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"isAttention":isAttention
                            };
    [FWHomeManager actionHomeAttentedFaceWithParameter:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            
            if ([isAttention isEqualToString:@"0"]) {
                
                [self->_attenBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [self->_attenBtn setImage:nil forState:UIControlStateNormal];
                [self->_attenBtn setTitleColor:Color_Black forState:UIControlStateNormal];
                
                if (response[@"result"] && [response[@"result"] isEqualToString:@"1"]) {
                    [MBProgressHUD showTips:response[@"resultDesc"]];
                }else{
                    [MBProgressHUD showTips:@"关注成功，把TA加入一个群组呗"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.alertVC.faceId = self.model.toUserId;
                        self.alertVC.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                        self.alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                        [[self superViewController:self] presentViewController:self.alertVC animated:YES completion:^(void)
                         {
                             self.alertVC.view.superview.backgroundColor = [UIColor clearColor];
                             
                         }];
                    });
                }
            }else{
                [MBProgressHUD showTips:response[@"resultDesc"]];
                [self->_attenBtn setTitle:@"关注" forState:UIControlStateNormal];
                [self->_attenBtn setTitleColor:Color_Black forState:UIControlStateNormal];
                [self->_attenBtn setImage:[UIImage imageNamed:@"me_add"] forState:UIControlStateNormal];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AttentionClick" object:nil];
        }else{
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }
    }];
}

#pragma mark - Public Methods

+ (CGFloat)cellHeight
{
    return 125;
}

- (void)configCellWithModel:(FWMessageAModel *)model type:(NSString*)type
{
    self.model = model;
    [self.userImg sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image(@"contactHeader")];
    self.userName.text = model.fromUser;
    self.timeLab.text  = model.createTime;
    if ([type isEqualToString:@"收藏"]) {
        self.typeLab.text = [NSString stringWithFormat:@"把我碑它的%@加入了心愿单",model.releaseGoodsName];
    }else{
        self.typeLab.text = StringConnect(@"赏脸了我的", model.releaseGoodsName);
    }
    
    if ([model.hasAttention isEqualToString:@"1"]) {
        self.attenBtn.hidden = NO;
        if ([model.isAttention isEqualToString:@"0"]) {
            [self.attenBtn setTitle:@"关注" forState:UIControlStateNormal];
            [_attenBtn setImage:[UIImage imageNamed:@"me_add"] forState:UIControlStateNormal];
        }else{
            [self.attenBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [self.attenBtn setImage:nil forState:UIControlStateNormal];
        }
    }else{
        self.attenBtn.hidden = YES;
    }

    [self.itemImg sd_setImageWithURL:URL(model.modelUrl) placeholderImage:nil];
    
    if ([model.status isEqualToString:@"0"]) {
        self.youImg.hidden = NO;
    }else{
        self.youImg.hidden = YES;
    }
    
    self.brandLab.text = model.brandName;
    self.brandLab.edgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    float w = [self widthForString:self.brandLab.text fontSize:12 andHeight:20];
    
    [self.brandLab mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.width.offset(w+10);
        make.left.equalTo(self.userName.mas_left);
        make.top.equalTo(self.typeLab.mas_bottom).offset(10);
    }];
}


#pragma mark - Private Methods

#pragma mark 获取当前View所在的ViewController
- (UIViewController *)superViewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}

-(float)widthForString:(NSString *)value fontSize:(float)fontSize andHeight:(float)height
{
    UIColor  *backgroundColor=[UIColor blackColor];
    UIFont *font=[UIFont systemFontOfSize:fontSize];
    CGRect sizeToFit = [value boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{
                                                                                                                                              NSForegroundColorAttributeName:backgroundColor,
                                                                                                                                              NSFontAttributeName:font
                                                                                                                                              } context:nil];
    
    return sizeToFit.size.width;
}

#pragma mark - Setters

- (UIImageView*)userImg
{
    if (_userImg == nil) {
        _userImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _userImg.contentMode = UIViewContentModeScaleAspectFill;
        _userImg.layer.cornerRadius = 35/2;
        _userImg.layer.masksToBounds = YES;
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

- (UILabel*)typeLab
{
    if (_typeLab == nil) {
        _typeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLab.text = @"赞赏了我的碑它";
        _typeLab.textColor = Color_Black;
        _typeLab.font = systemFont(12);
    }
    return _typeLab;
}

- (LhkhLabel*)brandLab
{
    if (_brandLab == nil) {
        _brandLab = [[LhkhLabel alloc] initWithFrame:CGRectZero];
        _brandLab.layer.cornerRadius = 5.f;
        _brandLab.layer.masksToBounds = YES;
        _brandLab.layer.borderColor = [UIColor colorWithHexString:@"#D4D4D4"].CGColor;
        _brandLab.layer.borderWidth = 1.f;
        _brandLab.textColor = Color_SubText;
        _brandLab.font = systemFont(12);
        _brandLab.textAlignment = NSTextAlignmentCenter;
    }
    return _brandLab;
}

- (UILabel*)timeLab
{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLab.text = @"2018-06-29";
        _timeLab.textColor = Color_SubText;
        _timeLab.font = systemFont(12);
    }
    return _timeLab;
}

- (UIButton*)attenBtn
{
    if (_attenBtn == nil) {
        _attenBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _attenBtn.layer.cornerRadius = 5.f;
        _attenBtn.layer.masksToBounds = YES;
        _attenBtn.layer.borderColor = [UIColor colorWithHexString:@"#D4D4D4"].CGColor;
        _attenBtn.layer.borderWidth = 1.f;
        [_attenBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_attenBtn setTitleColor:Color_Black forState:UIControlStateNormal];
        _attenBtn.titleLabel.font = systemFont(12);
        _attenBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        [_attenBtn addTarget:self action:@selector(attenClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attenBtn;
}

- (UIImageView*)itemImg
{
    if (_itemImg == nil) {
        _itemImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _itemImg.image = [UIImage imageNamed:@"3"];
    }
    return _itemImg;
}

- (UIImageView*)youImg
{
    if (_youImg == nil) {
        _youImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _youImg.image = [UIImage imageNamed:@"red_dot"];
    }
    return _youImg;
}

- (UIButton*)contentBtn
{
    if (_contentBtn == nil) {
        _contentBtn = [[UIButton alloc]init];
        [_contentBtn addTarget:self action:@selector(contentClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contentBtn;
}

- (UIButton*)contentImgBtn
{
    if (_contentImgBtn == nil) {
        _contentImgBtn = [[UIButton alloc]init];
        [_contentImgBtn addTarget:self action:@selector(contentImgClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contentImgBtn;
}

- (UIButton*)imgBtn
{
    if (_imgBtn == nil) {
        _imgBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_imgBtn addTarget:self action:@selector(imgClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgBtn;
}

- (FWAttenAlertVC*)alertVC
{
    if (_alertVC == nil) {
        _alertVC = [FWAttenAlertVC new];
    }
    return _alertVC;
}

#pragma mark - Getters



@end
