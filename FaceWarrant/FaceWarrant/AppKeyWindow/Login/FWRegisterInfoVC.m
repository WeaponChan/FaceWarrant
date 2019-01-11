//
//  FWRegisterInfoVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/5.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWRegisterInfoVC.h"
#import "FWXieYiVC.h"
#import "LhkhImagePickerController.h"
#import "OSSUploadFileManager.h"
#import "FWPickerView.h"
#import "JSKeyboardToolbar.h"
#import "FWLoginManager.h"
#import "JSDatePicker.h"
@interface FWRegisterInfoVC ()<JSKeyboardToolbarDelegate>
{
    UIImage *_userImage;
    NSString *_headImageUrl;
    NSString *_pid;
    NSString *_cid;
    MBProgressHUD *_hud;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;

@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view23spaceH;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UIView *view4;

@property (weak, nonatomic) IBOutlet UIImageView *userImg;
@property (weak, nonatomic) IBOutlet LhkhTextField *userName;
@property (weak, nonatomic) IBOutlet LhkhTextField *proviceText;
@property (weak, nonatomic) IBOutlet LhkhTextField *cityText;
@property (weak, nonatomic) IBOutlet LhkhTextField *inviteCodeText;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (strong, nonatomic) FWPickerView *pickerPView;
@property (strong, nonatomic) FWPickerView *pickerCView;
@property (nonatomic, strong) JSKeyboardToolbar *keyboardToolBar;

@end

@implementation FWRegisterInfoVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setSubView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.countryCode isEqualToString:@"86"] || [self.countryCode isEqualToString:@"852"] || [self.countryCode isEqualToString:@"853"] || [self.countryCode isEqualToString:@"886"]) {
        [self loadProvincesData];
    }else{
        [self loadOtherCountryCityData];
    }
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Layout SubViews




#pragma mark - System Delegate



#pragma mark - Custom Delegate

- (void)toolbar:(JSKeyboardToolbar *)toolbar DidClicked:(JSKeyboardToolbarItem)item
{
    
    if([self.proviceText isFirstResponder]) {
        self.proviceText.text = self.pickerPView.selectedTitle;
        _pid = self.pickerPView.selectedId;
        self.cityText.text = @"";
        _cid = @"";
        [self loadCityData:self.pickerPView.selectedId];
        
    }else if([self.cityText isFirstResponder]) {
        self.cityText.text = self.pickerCView.selectedTitle;
        _cid = self.pickerCView.selectedId;
    }
    
    if (item == JSKeyboardToolbarItemDone) {
        [self.view endEditing:YES];
    }
}


#pragma mark - Event Response

- (void)textFieldTextChange:(NSNotification *)notif
{
    if (self.userName.text.length >30) {
        [MBProgressHUD showTips:@"姓名长度不能超过30个字符额"];
        self.userName.text = [self.userName.text substringToIndex:30];
    }
}


//头像
- (IBAction)imgClick:(id)sender {

    LhkhImagePickerController *vc = [[LhkhImagePickerController alloc]init];
    vc.type = @"head";
    vc.imagePickerBlock = ^(UIImage *image) {
        self->_userImage = image;
        self.userImg.image = image;
    };
    vc.view.backgroundColor = [UIColor clearColor];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:vc  animated:NO completion:^(void)
     {
         vc.view.superview.backgroundColor = [UIColor clearColor];
     }];
}

//省份
- (IBAction)proviceClick:(id)sender {
    
}

//城市
- (IBAction)cityClick:(id)sender {
    
}



//注册
- (IBAction)registerClick:(id)sender {
    if (self.userName.text.length == 0 || [self.userName.text isEqualToString:@""] || self.userName.text == nil) {
        [MBProgressHUD showTips:@"请填写姓名"];
        return;
    }
    
    if (self.userName.text.length > 30) {
        [MBProgressHUD showTips:@"姓名长度不能超过30个字符额"];
        return;
    }
    
    if ([self.countryCode isEqualToString:@"86"] || [self.countryCode isEqualToString:@"852"] || [self.countryCode isEqualToString:@"853"] || [self.countryCode isEqualToString:@"886"]) {
        if (self.proviceText.text.length == 0 || [self.proviceText.text isEqualToString:@""] || self.proviceText.text == nil) {
            [MBProgressHUD showTips:@"请选择省份"];
            return;
        }
    }
    
    if (self.cityText.text.length == 0 || [self.cityText.text isEqualToString:@""] || self.cityText.text == nil) {
        [MBProgressHUD showTips:@"请选择城市"];
        return;
    }
    
    [self registerClick];
}
#pragma mark - Network requests

- (void)loadProvincesData
{
    [FWLoginManager loadMyCountryProvincesWithParameters:nil result:^(NSArray <FWProvinceModel *> *model) {
        [self.pickerPView pickerView:model];
    }];
}

- (void)loadCityData:(NSString*)pid
{
    NSDictionary *param = @{@"provinceId":pid};
    [FWLoginManager loadMyCountryCityWithParameters:param result:^(NSArray <FWCityModel*> *model) {
        [self.pickerCView pickerView:model];
    }];
}

- (void)loadOtherCountryCityData
{
    NSDictionary *param = @{@"countryId":self.countryId};
    [FWLoginManager loadOtherCountryCityWithParameters:param result:^(NSArray <FWCityModel*> *model) {
        [self.pickerCView pickerView:model];
    }];
}


- (void)registerClick
{
    _hud = [MBProgressHUD showHUDwithMessage:@"正在保存。。。"];
    if (_userImage && _userImage != nil ) {
        [[OSSUploadFileManager sharedOSSManager]asyncOSSUploadImage:_userImage type:@"HeadImage" phone:self.phoneNo complete:^(NSString *imageUrls, UploadImageState state) {
            self->_headImageUrl = imageUrls;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSDictionary *param = @{
                                        @"headImageUrl":self->_headImageUrl,
                                        @"name":self.userName.text,
                                        @"phoneNo":self.phoneNo,
                                        @"countryCode":self.countryCode,
                                        @"countryId":self.countryId?:[USER_DEFAULTS objectForKey:UD_CountryID],
                                        @"country":self.countryName?:@"",
                                        @"provinceId":self->_pid?:@"",
                                        @"province":self.proviceText.text?:@"",
                                        @"cityId":self->_cid?:@"",
                                        @"city":self.cityText.text?:@"",
                                        @"password":self.pwd?:@"",
                                        @"inviteCode":self.inviteCodeText.text?:@"",
                                        @"registerType":@"2",
                                        @"type":@"0",
                                        @"openId":@"",
                                        };
                [FWLoginManager registerWithParameters:param result:^(id response) {
                    [self->_hud hide];
                    if (response[@"success"] && [response[@"success"] isEqual:@1]) {
                        [MBProgressHUD showSuccess:response[@"resultDesc"]];
                        NSString *userId = response[@"result"][@"id"];
                        NSString *countryCode = response[@"result"][@"countryCode"];
                        NSString *userImg = response[@"result"][@"headImageUrl"];
                        [USER_DEFAULTS setObject:self.phoneNo forKey:UD_UserPhone];
                        [USER_DEFAULTS setObject:self.pwd forKey:UD_UserPwd];
                        [USER_DEFAULTS setObject:userId forKey:UD_UserID];
                        [USER_DEFAULTS setObject:userImg forKey:UD_UserHeadImg];
                        [USER_DEFAULTS setObject:countryCode forKey:UD_Code];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        });
                    }else{
                        [self->_hud hide];
                        [MBProgressHUD showError:response[@"resultDesc"]];
                    }
                }];
            });
        }];
    }else{
        [self->_hud hide];
        [MBProgressHUD showTips:@"请选择头像"];
    }
}

#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setSubView
{
    if (IS_iPhoneX_Later) {
        self.topH.constant = -44;
    }else{
        self.topH.constant = -20;
    }
    
    if ([self.countryCode isEqualToString:@"86"] || [self.countryCode isEqualToString:@"852"] || [self.countryCode isEqualToString:@"853"] || [self.countryCode isEqualToString:@"886"]) {
        self.view2H.constant = 44;
        self.view23spaceH.constant = 16;
    }else{
        self.view2H.constant = 0;
        self.view23spaceH.constant = 0;
    }
    
    self.view.backgroundColor = Color_White;
    
    self.view1.layer.cornerRadius = 22.f;
    self.view1.layer.masksToBounds = YES;
    self.view1.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.view1.layer.borderWidth = 1.f;
    self.view2.layer.cornerRadius = 22.f;
    self.view2.layer.masksToBounds = YES;
    self.view2.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.view2.layer.borderWidth = 1.f;
    self.view3.layer.cornerRadius = 22.f;
    self.view3.layer.masksToBounds = YES;
    self.view3.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.view3.layer.borderWidth = 1.f;
    self.view4.layer.cornerRadius = 22.f;
    self.view4.layer.masksToBounds = YES;
    self.view4.layer.borderColor = [UIColor colorWithHexString:@"#999999"].CGColor;
    self.view4.layer.borderWidth = 1.f;
    
    self.userImg.contentMode = UIViewContentModeScaleAspectFill;
    self.userImg.layer.cornerRadius = 40.f;
    self.userImg.layer.masksToBounds = YES;
    self.registerBtn.layer.cornerRadius = 22.f;
    self.registerBtn.layer.masksToBounds = YES;
    
    self.proviceText.inputAccessoryView = self.keyboardToolBar;
    self.proviceText.inputView = self.pickerPView;
    self.cityText.inputAccessoryView = self.keyboardToolBar;
    self.cityText.inputView = self.pickerCView;
}


#pragma mark - Setters

- (JSKeyboardToolbar *)keyboardToolBar
{
    if (!_keyboardToolBar) {
        _keyboardToolBar = [JSKeyboardToolbar keyboardToolbarWithDoneItem];
        _keyboardToolBar.toolbarDelegate = self;
    }
    return _keyboardToolBar;
}

- (FWPickerView *)pickerPView
{
    if (!_pickerPView) {
        _pickerPView = [FWPickerView pickerView];
    }
    return _pickerPView;
}

- (FWPickerView *)pickerCView
{
    if (!_pickerCView) {
        _pickerCView = [FWPickerView pickerView];
    }
    return _pickerCView;
}

#pragma mark - Getters




@end
