//
//  FWMeHeaderCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMeHeaderCell.h"
#import "FWMeInfoModel.h"
#import "LhkhImagePickerController.h"
#import "OSSUploadFileManager.h"
#import "UIButton+Lhkh.h"
#import "FWMeManager.h"
#define CellH 240*Screen_W/375
@interface FWMeHeaderCell ()
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UILabel *fansLab;
@property (weak, nonatomic) IBOutlet UILabel *shanglianLab;
@property (weak, nonatomic) IBOutlet UIButton *qiandaoBtn;
@property (strong, nonatomic) FWMeInfoModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIButton *bgBtn;
@property (weak, nonatomic) IBOutlet UILabel *fans;
@property (weak, nonatomic) IBOutlet UILabel *shanglian;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1BottomH;

@end

@implementation FWMeHeaderCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMeHeaderCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMeHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return cell;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    self.userImg.contentMode = UIViewContentModeScaleAspectFill;
    self.userImg.layer.cornerRadius = 25.f;
    self.userImg.layer.masksToBounds = YES;
    self.qiandaoBtn.layer.cornerRadius = 12.f;
    self.qiandaoBtn.layer.masksToBounds = YES;
    
    NSString *isShow = [USER_DEFAULTS objectForKey:UD_IsShowBuy];
    if ([isShow isEqualToString:@"1"]) {
        self.view2.hidden = YES;
    }else{
        self.view2.hidden = NO;
    }
    self.view2.layer.cornerRadius = 5.f;
    self.view2.layer.masksToBounds = YES;
    self.view2.layer.borderColor = Color_MainBg.CGColor;
    self.view2.layer.borderWidth = 1.f;
    
    self.userName.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.userName.shadowOffset = CGSizeMake(0, 2);
    self.fansLab.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.fansLab.shadowOffset = CGSizeMake(0, 2);
    self.fans.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.fans.shadowOffset = CGSizeMake(0, 2);
    self.shanglianLab.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.shanglianLab.shadowOffset = CGSizeMake(0, 2);
    self.shanglian.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.shanglian.shadowOffset = CGSizeMake(0, 2);
}


#pragma mark - Layout SubViews




#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response

- (IBAction)headImgClick:(id)sender {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        LhkhImagePickerController *vc = [[LhkhImagePickerController alloc]init];
        vc.type = @"head";
        vc.imagePickerBlock = ^(UIImage *image) {
            [[OSSUploadFileManager sharedOSSManager]asyncOSSUploadImage:image type:@"HeadImage" phone:[USER_DEFAULTS objectForKey:UD_UserPhone] complete:^(NSString *imageUrls, UploadImageState state) {
                if (state == 1) {
                    [self modifyHeaderImgWithUrl:imageUrls];
                }else{
                    [MBProgressHUD showTips:@"更换头像失败，请重新更换"];
                }
            }];
        };
        vc.view.backgroundColor = [UIColor clearColor];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [[self superViewController:self] presentViewController:vc  animated:NO completion:^(void)
         {
             vc.view.superview.backgroundColor = [UIColor clearColor];
             
         }];
    });
}


- (IBAction)cellClick:(UIButton*)sender {
    if ([self.delegate respondsToSelector:@selector(FWMeHeaderCellDelegateWith:)]) {
        [self.delegate FWMeHeaderCellDelegateWith:sender.tag];
    }
}
- (IBAction)bgClick:(id)sender {
    dispatch_async(dispatch_get_main_queue(), ^{
        LhkhImagePickerController *vc = [[LhkhImagePickerController alloc]init];
        vc.type = @"bg";
        vc.imagePickerBlock = ^(UIImage *image) {
            [[OSSUploadFileManager sharedOSSManager]asyncOSSUploadImage:image type:@"BGImage" phone:[USER_DEFAULTS objectForKey:UD_UserPhone] complete:^(NSString *imageUrls, UploadImageState state) {
                if (state == 1) {
                    [self uploadBgImg:imageUrls];
                }else{
                    [MBProgressHUD showTips:@"更换背景失败，请重新更换"];
                }
            }];
        };
        vc.view.backgroundColor = [UIColor clearColor];
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [[self superViewController:self] presentViewController:vc  animated:NO completion:^(void)
         {
             vc.view.superview.backgroundColor = [UIColor clearColor];
             
         }];
    });
}



#pragma mark - Network requests

- (void)modifyHeaderImgWithUrl:(NSString *)url
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"headImageUrl":url,
                            @"loginType":[USER_DEFAULTS objectForKey:UD_LoginType]
                            };
    [FWMeManager modifyHeaderImgWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notif_ChangeHeaderbgImg object:nil];
            if (![self.model.headUrl isEqual:self.model.defaultHeadUrl]) {
                [[OSSUploadFileManager sharedOSSManager] asyncOSSDeleteImageWithImageUrl:self.model.headUrl];
            }
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}


- (void)uploadBgImg:(NSString*)imgUrl
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"backgroundPicture":imgUrl
                            };
    [FWMeManager changeHeaderBgImgWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Notif_ChangeHeaderbgImg object:nil];
            if (![self.model.backgroundPicture isEqualToString:@""] && self.model.backgroundPicture != nil) {
                [[OSSUploadFileManager sharedOSSManager] asyncOSSDeleteImageWithImageUrl:self.model.backgroundPicture];
            }
        }else{
            [MBProgressHUD showTips:@"更换背景失败，请重新更换"];
        }
    }];
}


#pragma mark - Public Methods

+ (CGFloat)cellHeight
{
    return CellH;
}

- (void)configCellWithModel:(FWMeInfoModel*)model
{
    self.model = model;
    [self.userImg sd_setImageWithURL:URL(self.model.headUrl) placeholderImage:Image_placeHolder80];
    [self.bgImg sd_setImageWithURL:URL(self.model.backgroundPicture) placeholderImage:Image(@"facehome_bg")];
    self.userName.text = self.model.name;
    self.fansLab.text = self.model.fansCount;
    self.shanglianLab.text = self.model.favouriteCount;
    if ([model.isSignOn isEqualToString:@"0"]) {
        [self.qiandaoBtn setTitle:@"签到" forState:UIControlStateNormal];
        [self.qiandaoBtn setImage:Image(@"me_qiandao") forState:UIControlStateNormal];
        self.qiandaoBtn.backgroundColor = Color_Theme_Pink;
        self.qiandaoBtn.enabled = YES;
    }else{
        [self.qiandaoBtn setTitle:@"已签到" forState:UIControlStateNormal];
        [self.qiandaoBtn setImage:Image(@"me_qiandao") forState:UIControlStateNormal];
        self.qiandaoBtn.backgroundColor = [UIColor colorWithHexString:@"#d4d4d4"];
        self.qiandaoBtn.enabled = NO;
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




#pragma mark - Getters



@end
