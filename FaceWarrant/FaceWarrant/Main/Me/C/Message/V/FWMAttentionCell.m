//
//  FWMAttentionCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMAttentionCell.h"
#import "FWMessageAModel.h"
#import "FWPersonalHomePageVC.h"
#import "FWHomeManager.h"
#import "FWAttenAlertVC.h"
#import "FWMessageManager.h"
@interface FWMAttentionCell ()
@property (nonatomic, strong) UIImageView *userImg;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIButton *attenBtn;
@property (nonatomic, strong) UIImageView *youImg;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) FWMessageAModel *model;
@property (nonatomic, strong) FWAttenAlertVC *alertVC;
@end

@implementation FWMAttentionCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMAttentionCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWMAttentionCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.userImg];
        [self.contentView addSubview:self.userName];
        [self.contentView addSubview:self.typeLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.imgBtn];
        [self.contentView addSubview:self.attenBtn];
        [self.contentView addSubview:self.youImg];
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
    
    [self.imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
    
    [self.attenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.offset(60);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.attenBtn.mas_left).offset(-5);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.userImg.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.typeLab.mas_left).offset(-5);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.userName.mas_left);
        make.right.equalTo(self.attenBtn.mas_left);
        make.top.equalTo(self.userName.mas_bottom).offset(5);
    }];
    
    [self.youImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(10);
        make.height.offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(10);
    }];
}


#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response
- (void)attentionClick:(UIButton*)sender
{
    if([sender.titleLabel.text isEqualToString:@"已关注"]){
        [self AttenClick:@"1"];
    }else{
        [self AttenClick:@"0"];
    }
}

- (void)imgClick
{
    [self readedMessage];
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
                
                [self.attenBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [self.attenBtn setImage:nil forState:UIControlStateNormal];
                [self.attenBtn setTitleColor:Color_SubText forState:UIControlStateNormal];
                if (response[@"result"] && [response[@"result"] isEqualToString:@"1"]) {
                    [MBProgressHUD showTips:response[@"resultDesc"]];
                }else{
                    [MBProgressHUD showTips:@"关注成功，把TA加入一个群组呗"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.alertVC.faceId = self.model.fromUserId;
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
                [self.attenBtn setTitle:@"关注" forState:UIControlStateNormal];
                [self.attenBtn setTitleColor:Color_Black forState:UIControlStateNormal];
                [self.attenBtn setImage:[UIImage imageNamed:@"me_add"] forState:UIControlStateNormal];
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
    return 65;
}

- (void)configCellWithModel:(FWMessageAModel*)model indexPath:(NSIndexPath*)indexPath
{
    self.model = model;
    [self.userImg sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image(@"contactHeader")];
    self.userName.text = model.fromUser;
    self.timeLab.text = model.createTime;
    if ([model.hasAttention isEqualToString:@"1"]) {
        self.attenBtn.hidden = NO;
        if ([model.isAttention isEqualToString:@"0"]) {
            [self.attenBtn setTitle:@"关注" forState:UIControlStateNormal];
            [self.attenBtn setImage:[UIImage imageNamed:@"me_add"] forState:UIControlStateNormal];
            [self.attenBtn setTitleColor:Color_Black forState:UIControlStateNormal];
        }else{
            [self.attenBtn setTitle:@"已关注" forState:UIControlStateNormal];
            [self.attenBtn setImage:nil forState:UIControlStateNormal];
            [self.attenBtn setTitleColor:Color_SubText forState:UIControlStateNormal];
        }
    }else{
        self.attenBtn.hidden = YES;
    }
    self.typeLab.text = @"关注了我";
    if ([model.status isEqualToString:@"0"]) {
        self.youImg.hidden = NO;
    }else{
        self.youImg.hidden = YES;
    }
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
        _typeLab.textColor = Color_SubText;
        _typeLab.font = systemFont(12);
    }
    return _typeLab;
}

- (UILabel*)timeLab
{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
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
        _attenBtn.layer.borderColor = [UIColor colorWithHexString:@"d4d4d4"].CGColor;
        _attenBtn.layer.borderWidth = 1.f;
        [_attenBtn setTitleColor:Color_Black forState:UIControlStateNormal];
        _attenBtn.titleLabel.font = systemFont(12);
        _attenBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 5);
        [_attenBtn addTarget:self action:@selector(attentionClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attenBtn;
}

- (UIImageView*)youImg
{
    if (_youImg == nil) {
        _youImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _youImg.image = [UIImage imageNamed:@"red_dot"];
    }
    return _youImg;
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
