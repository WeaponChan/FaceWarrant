//
//  FWWarrantFCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantFCell.h"
#import "FWWarrantDetailModel.h"
#import "FWWarrantManager.h"
#import "FWHomeManager.h"
#import "FWAttenAlertVC.h"
#import "FWPersonalHomePageVC.h"
@interface FWWarrantFCell ()<UIAlertViewDelegate>
@property (strong, nonatomic)UIImageView *userImg;
@property (strong, nonatomic)UILabel *userName;
@property (strong, nonatomic)UILabel *userDesc;
@property (strong, nonatomic)UIButton *attenBtn;
@property (strong, nonatomic)UIButton *imgBtn;
@property (strong, nonatomic)FWWarrantDetailModel *model;
@property (strong, nonatomic)FWAttenAlertVC *alertVC;
@end

@implementation FWWarrantFCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWWarrantFCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWWarrantFCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWWarrantFCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.userImg];
        [self.contentView addSubview:self.imgBtn];
        [self.contentView addSubview:self.userName];
//        [self.contentView addSubview:self.userDesc];
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
    
    [self.imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(self.userImg);
    }];
    
    [self.attenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(24);
        make.width.offset(60);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.userImg.mas_right).offset(10);
//        make.top.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.userImg.centerY);
        make.right.equalTo(self.attenBtn.mas_left);
    }];
    
//    [self.userDesc mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(20);
//        make.left.equalTo(self.userName.mas_left);
//        make.right.equalTo(self.attenBtn.mas_left);
//        make.top.equalTo(self.userName.mas_bottom).offset(5);
//    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = Color_MainBg;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - System Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self deleteWarrant];
    }
}

#pragma mark - Custom Delegate


#pragma mark - Event Response
- (void)attenClick:(UIButton*)sender
{
    if ([sender.titleLabel.text isEqualToString:@"删除"]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"确定删除此碑它吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
        
//        LhkhAlertShow(@"确定删除此碑它吗？", @"取消", @"确定");
        
        
    }else if([sender.titleLabel.text isEqualToString:@"已关注"]){
        [self AttenClick:@"1"];
    }else{
        [self AttenClick:@"0"];
    }
}

- (void)imgClick:(UIButton*)sender
{
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.faceId = self.model.faceId;
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}

#pragma mark - Network requests

- (void)deleteWarrant
{
    NSDictionary *param = @{
                            @"releaseGoodIds":self.model.releaseGoodsId,
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID]
                            };
    [FWWarrantManager deleteWarrantgoodsWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [MBProgressHUD showTips:response[@"resultDesc"]];
            [[self superViewController:self].navigationController popViewControllerAnimated:YES];
        }else{
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }
    }];
}

- (void)AttenClick:(NSString*)isAttention
{
    NSDictionary *param = @{
                            @"faceId":self.model.faceId,
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"isAttention":isAttention
                            };
    [FWHomeManager actionHomeAttentedFaceWithParameter:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            
            if ([isAttention isEqualToString:@"0"]) {
               
                [self->_attenBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [self->_attenBtn setImage:nil forState:UIControlStateNormal];
                self->_attenBtn.backgroundColor = [UIColor colorWithHexString:@"#D4D4D4"];
                if (response[@"result"] && [response[@"result"] isEqualToString:@"1"]) {
                    [MBProgressHUD showTips:response[@"resultDesc"]];
                }else{
                    [MBProgressHUD showTips:@"关注成功，把TA加入一个群组呗"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.alertVC.faceId = self.model.faceId;
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
                [self->_attenBtn setImage:[UIImage imageNamed:@"facehome_add"] forState:UIControlStateNormal];
                self->_attenBtn.backgroundColor = Color_Theme_Pink;
            }
            
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

- (void)configCellWithModel:(FWWarrantDetailModel *)model
{
    self.model = model;
    [self.userImg sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image_placeHolder80];
    self.userName.text = model.faceName;
    self.userDesc.text = model.releaseGoodsTime;
    DLog(@"%@",[USER_DEFAULTS objectForKey:UD_UserID]);
    if ([[USER_DEFAULTS objectForKey:UD_UserID] isEqualToString:model.faceId]) {
        [_attenBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_attenBtn setImage:nil forState:UIControlStateNormal];
    }else if ([model.isAttention isEqualToString:@"1"]) {
        [_attenBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [_attenBtn setImage:nil forState:UIControlStateNormal];
        _attenBtn.backgroundColor = [UIColor colorWithHexString:@"#D4D4D4"];
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

- (UIButton*)imgBtn
{
    if (_imgBtn == nil) {
        _imgBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_imgBtn addTarget:self action:@selector(imgClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgBtn;
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
        _attenBtn.layer.cornerRadius = 12.f;
        _attenBtn.layer.masksToBounds = YES;
        _attenBtn.backgroundColor = Color_Theme_Pink;
        [_attenBtn setTitle:@"关注" forState:UIControlStateNormal];
        [_attenBtn setTitleColor:Color_White forState:UIControlStateNormal];
        _attenBtn.titleLabel.font = systemFont(12);
        [_attenBtn setImage:[UIImage imageNamed:@"facehome_add"] forState:UIControlStateNormal];
        _attenBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 2);
        [_attenBtn addTarget:self action:@selector(attenClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attenBtn;
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
