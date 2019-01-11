//
//  FWFaceHomeHeaderView.m
//  FaceWarrantDel
//
//  Created by FW on 2018/11/9.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import "FWFaceHomeHeaderView.h"
#import "FWFaceHomeModel.h"
#import "FWWarrantManager.h"
#import "FWHomeManager.h"
#import "FWAttenAlertVC.h"
@interface FWFaceHomeHeaderView()
{
    NSString *_sortType;
    CGRect myframe;
}
@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *userDesc;
@property (weak, nonatomic) IBOutlet UILabel *fansLab;
@property (weak, nonatomic) IBOutlet UILabel *attenLab;
@property (weak, nonatomic) IBOutlet UILabel *zanLab;
@property (weak, nonatomic) IBOutlet UILabel *goodsLab;
@property (weak, nonatomic) IBOutlet UIButton *attenBtn;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@property (weak, nonatomic) IBOutlet UIButton *hotBtn;
@property (weak, nonatomic) IBOutlet UIButton *xinBtn;
@property (strong, nonatomic)FWAttenAlertVC *alertVC;
@property (strong, nonatomic)FWFaceHomeModel *model;
@end

@implementation FWFaceHomeHeaderView

#pragma mark - Life Cycle

- (instancetype)initFaceHomeHeaderViewWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self = [[NSBundle mainBundle] loadNibNamed:@"FWFaceHomeHeaderView" owner:self options:nil].firstObject;
        myframe = frame;
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.userImg.contentMode = UIViewContentModeScaleAspectFill;
    self.userImg.layer.cornerRadius = 40.f;
    self.userImg.layer.masksToBounds = YES;
    self.attenBtn.layer.cornerRadius = 12.f;
    self.attenBtn.layer.masksToBounds = YES;
    self.attenBtn.enabled = NO;
}

-(void)drawRect:(CGRect)rect
{
    self.frame = myframe;
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response
- (IBAction)cellClick:(UIButton *)sender {
    if (sender.tag == 0) {
        [[self superViewController:self].navigationController popViewControllerAnimated:NO];
    }else if (sender.tag == 1){
        DLog(@"share");
    }else{
        DLog(@"attention");
        if([sender.titleLabel.text isEqualToString:@"已关注"]){
            [self AttenClick:@"1"];
        }else{
            [self AttenClick:@"0"];
        }
    }
}

- (IBAction)moreClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(FWFaceHomeHeaderViewDelegateMoreBrandClick)]) {
        [self.delegate FWFaceHomeHeaderViewDelegateMoreBrandClick];
    }
}

- (IBAction)newClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.hotBtn.selected = !sender.selected;
    _sortType = @"0";
    [USER_DEFAULTS setObject:_sortType forKey:UD_SortType];
    if ([self.delegate respondsToSelector:@selector(FWFaceHomeHeaderViewDelegateMoregoodsClick:)]) {
        [self.delegate FWFaceHomeHeaderViewDelegateMoregoodsClick:_sortType];
    }
}

- (IBAction)hotClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.xinBtn.selected = !sender.selected;
    _sortType = @"1";
    [USER_DEFAULTS setObject:_sortType forKey:UD_SortType];
    if ([self.delegate respondsToSelector:@selector(FWFaceHomeHeaderViewDelegateMoregoodsClick:)]) {
        [self.delegate FWFaceHomeHeaderViewDelegateMoregoodsClick:_sortType];
    }
}

#pragma mark - Network Requests
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
                [self->_attenBtn setTitleColor:Color_White forState:UIControlStateNormal];
                self->_attenBtn.backgroundColor = [UIColor colorWithHexString:@"#D4D4D4"];
                if (response[@"result"] && [response[@"result"] isEqualToString:@"1"]) {
                    [MBProgressHUD showTips:response[@"resultDesc"]];
                }else{
                    [MBProgressHUD showTips:@"关注成功，把TA加入一个群组呗"];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        self.alertVC.faceId = self.model.faceId;
                        self.alertVC.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
                        self.alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                        [[self superViewController:self] presentViewController:self.alertVC animated:YES completion:^(void)
                         {
                             self.alertVC.view.superview.backgroundColor = [UIColor clearColor];
                             
                         }];
                    });
                }
                [[NSNotificationCenter defaultCenter] postNotificationName:@"attenAction" object:self.indexPath userInfo:@{@"isAttention":@"1",@"type":@"1"}];
            }else{
                [MBProgressHUD showTips:response[@"resultDesc"]];
                [self->_attenBtn setTitle:@"关注" forState:UIControlStateNormal];
                [self->_attenBtn setTitleColor:Color_White forState:UIControlStateNormal];
                [self->_attenBtn setImage:[UIImage imageNamed:@"facehome_add"] forState:UIControlStateNormal];
                self->_attenBtn.backgroundColor = Color_Theme_Pink;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"attenAction" object:self.indexPath userInfo:@{@"isAttention":@"0",@"type":@"0"}];
            }
            
        }else{
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }
    }];
}

#pragma mark - Public Methods

- (void)configCellWithModel:(FWFaceHomeModel*)model
{
    self.model = model;
    [self.userImg sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image_placeHolder100];
    
    [self.bgImg sd_setImageWithURL:URL(model.backgroundImg) placeholderImage:Image(@"facehome_bg")];
    self.userName.text = model.faceName;
    self.userDesc.text = model.standing;
    self.fansLab.text = model.fansCount;
    self.attenLab.text = model.attentionCount;
    self.zanLab.text = model.favouriteCount;
    self.goodsLab.text = model.releaseGoodsCount;
    self.attenBtn.enabled = YES;
    if ([[USER_DEFAULTS objectForKey:UD_UserID] isEqualToString:model.faceId] || model.releaseGoodsCount.floatValue == 0) {
        self.attenBtn.hidden = YES;
    }else{
        self.attenBtn.hidden = NO;
    }
    
    if ([model.isAttention isEqualToString:@"1"]) {
        [self.attenBtn setTitle:@"已关注" forState:UIControlStateNormal];
        [self.attenBtn setImage:nil forState:UIControlStateNormal];
        self->_attenBtn.backgroundColor = [UIColor colorWithHexString:@"#D4D4D4"];
    }else{
        [self.attenBtn setTitle:@"关注" forState:UIControlStateNormal];
        [self.attenBtn setImage:Image(@"facehome_add") forState:UIControlStateNormal];
        self->_attenBtn.backgroundColor = Color_Theme_Pink;
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

- (FWAttenAlertVC*)alertVC
{
    if (_alertVC == nil) {
        _alertVC = [FWAttenAlertVC new];
    }
    return _alertVC;
}
#pragma mark - Getters



@end
