//
//  FWWarrantInfoVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/24.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantInfoVC.h"
#import "FWWarrantInfoImgCell.h"
#import "FWWarrantInfoItemCell.h"
#import "FWWarrantExperienceCell.h"
#import "ItemListImageModel.h"
#import "FWBrandVC.h"
#import "FWWarrantManager.h"
#import "FWBrandModel.h"
#import "FWBrandBigClassModel.h"
#import "FWBrandSmallClassModel.h"
#import "FWBrandGoodsModel.h"
#import "OSSUploadFileManager.h"
#import "FWVoiceView.h"
#import <VODUpload/VODUploadSVideoClient.h>
#import "FWOSSConfigManager.h"
#import "FWWindowManager.h"
@interface FWWarrantInfoVC ()<UITableViewDelegate,UITableViewDataSource,FWWarrantExperienceCellDelegate,FWWarrantInfoItemCellDelegate,FWVoiceViewDelegate,VODUploadSVideoClientDelegate>
{
    CGFloat _imgCellH;
    BOOL isFirst;
    NSString *_experience;//体验
    NSString *_useDetail;//最终体验
    NSDictionary *_tempDic;
    NSString *_brand;//品牌
    NSString *_bigClass;//大分类
    NSString *_smallClass;//小分类
    NSString *_goods;//商品
    NSString *_brandID;//品牌
    NSString *_bigClassID;//大分类
    NSString *_smallClassID;//小分类
    NSString *_goodsID;//商品
    MBProgressHUD *hud;
    NSString *_aKey;
    NSString *_aSec;
    NSString *_aToken;
    NSString *_Idinfo;//个人信息
    NSString *_modifyIdinfo;//个人信息
    NSString *_standing;//修改过后的个人信息
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UIButton *warrantBtn;
@property (strong, nonatomic) NSMutableArray *keyArr;
@property (strong, nonatomic) NSMutableArray *brandArr;
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;//毛玻璃视图
@property (strong, nonatomic) FWVoiceView *voiceView;
@property (strong, nonatomic) VODUploadSVideoClient *client;
@end

@implementation FWWarrantInfoVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setTableView];
    [self setSubView];
    [self loadBaseInfo];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


#pragma mark - Layout SubViews

//- (void)viewDidLayoutSubviews
//{
//    [super viewDidLayoutSubviews];
//    if (!iOS11Later) {
//        self.view.frame = CGRectMake(0, 0, Screen_W, Screen_H);
//    }
//}

#pragma mark - System Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1){
        return 5;
    }else{
        return 1;
    }
    
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FWWarrantInfoImgCell *cell = [FWWarrantInfoImgCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithData:self.image];
        return cell;
    }else if (indexPath.section == 2){
        FWWarrantExperienceCell *cell = [FWWarrantExperienceCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell cellConfigWithExperience:_experience?:@"" indexPath:indexPath];
        _experience = nil;
        return cell;
    }else{
        FWWarrantInfoItemCell *cell = [FWWarrantInfoItemCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_modifyIdinfo && _modifyIdinfo.length>0) {
            _standing = _modifyIdinfo;
        }else{
            _standing = _Idinfo;
        }
        [cell configCellWithBrand:_brand bigSort:_bigClass smallSort:_smallClass name:_goods idinfo:_standing IndexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        CGFloat fixelW = CGImageGetWidth(self.image.CGImage);
        CGFloat fixelH = CGImageGetHeight(self.image.CGImage);
        return fixelH/fixelW*Screen_W;
        
    }else if (indexPath.section == 2){
        return [FWWarrantExperienceCell cellHeight];
    }
    return 44;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        FWBrandVC *vc = [FWBrandVC new];
        if (indexPath.row == 0) {
            vc.vcType = @"FWWarrantInfoVC";
            vc.block = ^(NSString *name, NSString *ID) {
                self->_brand = name;
                self->_brandID = ID;
                [self reloadBaseInfo:@"0"];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 1){
            vc.vcType = @"1";
            vc.brandId = _brandID;
            vc.block = ^(NSString *name, NSString *ID) {
                self->_bigClass = name;
                self->_bigClassID = ID;
                [self reloadBaseInfo:@"1"];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 2){
            vc.vcType = @"2";
            vc.brandId = _brandID;
            vc.bigClassId = _bigClassID;
            vc.block = ^(NSString *name, NSString *ID) {
                self->_smallClassID = ID;
                self->_smallClass = name;
                [self reloadBaseInfo:@"2"];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else if(indexPath.row == 3){
            vc.vcType = @"3";
            vc.brandId = _brandID;
            vc.bigClassId = _bigClassID;
            vc.smallClassId = _smallClassID;
            vc.block = ^(NSString *name, NSString *ID) {
                self->_goods = name;
                self->_goodsID = ID;
                [self reloadBaseInfo:@"3"];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 滚动时结束编辑
    [self.view endEditing:YES];
}

#pragma mark - Custom Delegate
#pragma mark - FWWarrantInfoItemCellDelegate

- (void)FWWarrantInfoItemCellDelegate:(NSString *)text
{
    DLog(@"--111->%@",text);
    _modifyIdinfo = text;
    _standing = text;
    [self.tableView reloadData];
}

#pragma mark - FWWarrantExperienceCellDelegate

- (void)FWWarrantExperienceCellDelegateText:(NSString *)text
{
    DLog(@"--222->%@",text);
    _experience = text;
    [self.tableView reloadData];
}

- (void)FWWarrantExperienceCellDelegateMicCkick
{
    self.voiceView.hidden = self.visualEffectView.hidden = NO;
    [self.view endEditing:YES];
    CGFloat fixelW = CGImageGetWidth(self.image.CGImage);
    CGFloat fixelH = CGImageGetHeight(self.image.CGImage);
    CGFloat imgH =  fixelH/fixelW*Screen_W;
    [self.tableView setContentOffset:CGPointMake(0,imgH) animated:YES];
}

#pragma mark - FWVoiceViewDelegate
- (void)FWVoiceViewDelegateWithText:(NSString *)text
{
    _experience = text;
    self.voiceView.hidden = self.visualEffectView.hidden = YES;
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [self.tableView reloadData];
}


#pragma mark - VODUploadSVideoClientDelegate

-(void)uploadFailedWithCode:(NSString *)code message:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        DLog(@"faild---code=%@---message==%@",code,message);
    });
}

-(void)uploadSuccessWithResult:(VodSVideoUploadResult *)result {
    DLog(@"wz successvid:%@, imageurl:%@",result.videoId, result.imageUrl);
    dispatch_async(dispatch_get_main_queue(), ^{
        [self warrantGoods:result.imageUrl videoUrl:result.videoId];
    });
}


-(void)uploadProgressWithUploadedSize:(long long)uploadedSize totalSize:(long long)totalSize {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}



#pragma mark - Event Response
- (void)warrantClick
{
    if (self.image == nil) {
        [MBProgressHUD showTips:@"请选择要碑它的图片"];
        return;
    }
    if (_brand == nil || _brand.length == 0 || [_brand isEqualToString:@""]) {
        [MBProgressHUD showTips:@"请选择要碑它的品牌"];
        return;
    }
    if (_bigClass == nil || _bigClass.length == 0 || [_bigClass isEqualToString:@""]) {
        [MBProgressHUD showTips:@"请选择要碑它的大类名称"];
        return;
    }
    if (_smallClass == nil || _smallClass.length == 0 || [_smallClass isEqualToString:@""]) {
        [MBProgressHUD showTips:@"请选择要碑它的小雷名称"];
        return;
    }
    if (_goods == nil || _goods.length == 0 || [_goods isEqualToString:@""]) {
        [MBProgressHUD showTips:@"请选择要碑它的商品名称"];
        return;
    }
    _useDetail = [USER_DEFAULTS objectForKey:@"experience"];
    if (_useDetail == nil || _useDetail.length == 0 || [_useDetail isEqualToString:@""]) {
        [MBProgressHUD showTips:@"请填写您碑它的商品使用体会"];
        return;
    }
    if (_standing == nil || _standing.length == 0 || [_standing isEqualToString:@""]) {
        [MBProgressHUD showTips:@"请填写您的身份信息"];
        return;
    }
    
    [self uploadImageAndVideo];
}

- (void)singleTapDetected
{
    self.voiceView.hidden = self.visualEffectView.hidden = YES;
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - Network Requests

- (void)loadBaseInfo
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID]
                            };
    [FWWarrantManager loadWarrantBaseInfoWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            self->_brand = response[@"result"][@"brandName"];
            self->_brandID = response[@"result"][@"brandId"];
            self->_bigClass = response[@"result"][@"btypeName"];
            self->_bigClassID = response[@"result"][@"btypeId"];
            self->_smallClass = response[@"result"][@"stypesName"];
            self->_smallClassID = response[@"result"][@"stypesId"];
            self->_goods = response[@"result"][@"goodName"];
            self->_goodsID = response[@"result"][@"goodsId"];
            self->_Idinfo = response[@"result"][@"standing"];
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

- (void)reloadBaseInfo:(NSString*)type
{
    NSString *brandID = @"";
    NSString *bigClassID = @"";
    NSString *smallClassID = @"";
    if ([type isEqualToString:@"0"]) {
        brandID  = _brandID;
    }else if([type isEqualToString:@"1"]){
        brandID  = _brandID;
        bigClassID = _bigClassID;
    }else if ([type isEqualToString:@"2"]){
        brandID  = _brandID;
        bigClassID = _bigClassID;
        smallClassID = _smallClassID;
    }
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"brandId":brandID,
                            @"btypeId":bigClassID,
                            @"stypeId":smallClassID
                            };
    [FWWarrantManager loadWarrantBaseInfoWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            if ([type isEqualToString:@"0"]) {
                self->_bigClass = response[@"result"][@"btypeName"];
                self->_bigClassID = response[@"result"][@"btypeId"];
                self->_smallClass = response[@"result"][@"stypesName"];
                self->_smallClassID = response[@"result"][@"stypesId"];
                self->_goods = response[@"result"][@"goodName"];
                self->_goodsID = response[@"result"][@"goodsId"];
                self->_Idinfo = response[@"result"][@"standing"];
            }else if([type isEqualToString:@"1"]){
                self->_smallClass = response[@"result"][@"stypesName"];
                self->_smallClassID = response[@"result"][@"stypesId"];
                self->_goods = response[@"result"][@"goodName"];
                self->_goodsID = response[@"result"][@"goodsId"];
                self->_Idinfo = response[@"result"][@"standing"];
            }else if ([type isEqualToString:@"2"]){
                self->_goods = response[@"result"][@"goodName"];
                self->_goodsID = response[@"result"][@"goodsId"];
                self->_Idinfo = response[@"result"][@"standing"];
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}


- (void)loadVODSTSToken
{
    [FWOSSConfigManager loadOSSGetVideoSTSToken:nil result:^(id response) {
        
        if (response[@"StatusCode"] && [response[@"StatusCode"] isEqualToString:@"200"]) {
            self->_aKey = response[@"AccessKeyId"];
            self->_aSec = response[@"AccessKeySecret"];
            self->_aToken = response[@"SecurityToken"];
            [self videoPath:self.videoPath imagePath:self.imagePath];
        }
    }];
}


- (void)videoPath:(NSString*)videoPath imagePath:(NSString*)imagePath
{
    VodSVideoInfo *info = [VodSVideoInfo new];
    info.title = @"碑它短视频";
    _client = [[VODUploadSVideoClient alloc] init];
    _client.delegate = self;
    [_client uploadWithVideoPath:videoPath imagePath:imagePath svideoInfo:info accessKeyId:_aKey accessKeySecret:_aSec accessToken:_aToken];
}


- (void)uploadImageAndVideo
{
    hud = [MBProgressHUD showHUDwithMessage:@"正在保存..."];
    if ([self.type isEqualToString:@"0"]) {
        [[OSSUploadFileManager sharedOSSManager] asyncOSSUploadImage:self.image type:@"WarrantImage" phone:[USER_DEFAULTS objectForKey:UD_UserPhone] complete:^(NSString *imageUrl, UploadImageState state) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self warrantGoods:imageUrl videoUrl:@""];
            });
        }];
    }else{
        [self loadVODSTSToken];
    }
}

- (void)warrantGoods:(NSString*)imageUrl videoUrl:(NSString *)videoUrl
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"btypeId":self->_bigClassID,
                            @"stypeId":self->_smallClassID,
                            @"goodsId":self->_goodsID,
                            @"goodsName":self->_goods,
                            @"useDetail":self->_useDetail,
                            @"fwType":self.type,
                            @"fwUrl":imageUrl,
                            @"videoUrl":videoUrl,
                            @"standing":self->_standing?:@""
                            };
    [FWWarrantManager warrantgoodsWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self->hud hide];
            [MBProgressHUD showSuccess: response[@"resultDesc"]];
            [USER_DEFAULTS setObject:self->_standing forKey:UD_IdInfo];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
        }else{
            [self->hud hide];
            [MBProgressHUD showError: response[@"resultDesc"]];
        }
    }];
}


#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.title = @"碑它";
}

- (void)setTableView
{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = Color_MainBg;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    isFirst = YES;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-90);
    }];
}

- (void)setSubView
{
    [self.view addSubview:self.warrantBtn];
    [self.warrantBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(44);
        make.left.equalTo(self.view).offset(28);
        make.right.equalTo(self.view).offset(-28);
        make.bottom.equalTo(self.view).offset(-25);
    }];
    
    //实现模糊效果
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //毛玻璃视图
    self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    self.visualEffectView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
    self.visualEffectView.alpha = 0.5;
    self.visualEffectView.hidden = YES;
    [self.view addSubview:self.visualEffectView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.visualEffectView setUserInteractionEnabled:YES];
    [self.visualEffectView addGestureRecognizer:singleTap];
    self.voiceView.hidden = YES;
    [self.view addSubview:self.voiceView];
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(200);
        make.left.right.bottom.equalTo(self.view);
    }];
}

#pragma mark - Setters

- (UIButton*)warrantBtn
{
    if (_warrantBtn == nil) {
        _warrantBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        _warrantBtn.layer.cornerRadius = 5.f;
        _warrantBtn.layer.masksToBounds = YES;
        [_warrantBtn setTitle:@"碑它" forState:UIControlStateNormal];
        [_warrantBtn setTitleColor:Color_White forState:UIControlStateNormal];
        [_warrantBtn setBackgroundColor:Color_Theme_Pink];
        _warrantBtn.titleLabel.font = systemFont(18);
        [_warrantBtn addTarget:self action:@selector(warrantClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _warrantBtn;
}

- (NSMutableArray*)keyArr
{
    if (_keyArr == nil) {
        _keyArr = [NSMutableArray array];
    }
    return _keyArr;
}

- (NSMutableArray*)brandArr
{
    if (_brandArr == nil) {
        _brandArr = [NSMutableArray array];
    }
    return _brandArr;
}

- (FWVoiceView*)voiceView
{
    if (_voiceView == nil) {
        _voiceView = [[FWVoiceView alloc] initWithFrame:CGRectZero];
        _voiceView.backgroundColor = Color_White;
        _voiceView.vctype = @"1";
        _voiceView.delegate = self;
    }
    return _voiceView;
}

#pragma mark - Getters


@end
