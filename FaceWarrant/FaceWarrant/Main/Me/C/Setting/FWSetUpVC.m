//
//  FWSetUpVC.m
//  FaceWarrant
//
//  Created by LHKH on 2018/7/2.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWSetUpVC.h"
#import "FWModifyHeaderCell.h"
#import "FWMeSubItemCell.h"
#import "JSCacheManager.h"
#import "FWAccountVC.h"
#import "LhkhImagePickerController.h"
#import "OSSUploadFileManager.h"
#import "FWMeManager.h"
#import "FWOpinionsVC.h"
#import "FWLoginManager.h"
#import "APPVersionManager.h"
@interface FWSetUpVC ()<UITableViewDelegate, UITableViewDataSource>
{
    CGFloat _cacheSize;
    NSString *_headerImg;
    NSString *_isShow;

}
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation FWSetUpVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _isShow = [USER_DEFAULTS objectForKey:UD_IsShowBuy];
}


#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码


#pragma mark - System Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if (section ==1){
        return 1;
    }
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        FWModifyHeaderCell *cell = [FWModifyHeaderCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithheaderUrl:_headerImg];
        return cell;
    }else{
        FWMeSubItemCell *cell = [FWMeSubItemCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithIndexPath:indexPath item:[NSString stringWithFormat:@"%.1f",_cacheSize] vcType:@""];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 0 ) {
        return [FWModifyHeaderCell cellHeight];
    }else{
        return [FWMeSubItemCell cellHeight];
    }
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
    if (indexPath.section == 0){
        if (indexPath.row == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self modifyHeaderImg];
            });
        }else if (indexPath.row == 1) {
            FWAccountVC *vc = [[FWAccountVC alloc] init];
            [self.navigationController pushViewController:vc animated:NO];
        }
    }else if (indexPath.section == 1){
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIAlertController js_alertAviewWithTarget:self andAlertTitle:nil andMessage:@"确认清除全部缓存吗？" andDefaultActionTitle:@"确认" dHandler:^(UIAlertAction *action) {
                [JSCacheManager clearCache:^{
                    [MBProgressHUD showSuccess:@"成功清除缓存"];
                    self->_cacheSize = 0;
                    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                }];
            } andCancelActionTitle:@"取消" cHandler:^(UIAlertAction *action) {
                
            } completion:nil];
        });
    }else{
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[FWOpinionsVC new] animated:YES];
        }else{
            DLog(@"App Store");
            if (![_isShow isEqualToString:@"1"]) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[APPVersionManager sharedInstance] checkVersion:self];
                });
            }
        }
    }
}



#pragma mark - Custom Delegate




#pragma mark - Event Response

- (void)modifyHeaderImg
{
    LhkhImagePickerController *vc = [[LhkhImagePickerController alloc]init];
    vc.type = @"head";
    vc.imagePickerBlock = ^(UIImage *image) {
        [[OSSUploadFileManager sharedOSSManager]asyncOSSUploadImage:image type:@"HeadImage" phone:[USER_DEFAULTS objectForKey:UD_UserPhone] complete:^(NSString *imageUrls, UploadImageState state) {
            self->_headerImg = imageUrls;
            [self modifyHeaderImgWithUrl:imageUrls];
        }];
    };
    vc.view.backgroundColor = [UIColor clearColor];
    vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:vc  animated:YES completion:^(void)
     {
         vc.view.superview.backgroundColor = [UIColor clearColor];
         
     }];
}


- (void)loginOutClick
{
    [UIAlertController js_alertAviewWithTarget:self andAlertTitle:@"确认退出当前账号？" andMessage:nil andDefaultActionTitle:@"确认" dHandler:^(UIAlertAction *action) {
        [self loginOut];
    } andCancelActionTitle:@"取消" cHandler:^(UIAlertAction *action) {
        DLog(@"取消");
    } completion:nil];
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
            [MBProgressHUD showSuccess:response[@"resultDesc"]];
            [self.tableView reloadData];
            if (![self.model.headUrl isEqual:self.model.defaultHeadUrl]) {
                [[OSSUploadFileManager sharedOSSManager] asyncOSSDeleteImageWithImageUrl:self.model.headUrl];
            }
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

- (void)loginOut
{
    NSDictionary *param = @{@"userId":[USER_DEFAULTS objectForKey:UD_UserID]};
    [FWLoginManager loginOutWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [USER_DEFAULTS setObject:@"0" forKey:UD_AppVersionCancel];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:Notif_UserWillLogout object:nil];
            });
        }
    }];
}


#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setNav
{
    self.navigationItem.title = @"设置";
    _headerImg = self.model.headUrl;
    _cacheSize = [JSCacheManager folderSizeAtPath];
    
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
    
    
    UIButton *loginOutBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutBtn setTitleColor:Color_Theme_Pink forState:UIControlStateNormal];
    loginOutBtn.titleLabel.font = systemFont(18);
    loginOutBtn.layer.cornerRadius = 4.f;
    loginOutBtn.layer.masksToBounds = YES;
    loginOutBtn.layer.borderColor = Color_Theme_Pink.CGColor;
    loginOutBtn.layer.borderWidth = 1.f;
    [loginOutBtn addTarget:self action:@selector(loginOutClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginOutBtn];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(loginOutBtn.mas_top).offset(50);
    }];
    
    [loginOutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(44);
        make.left.mas_equalTo(self.view).offset(38);
        make.right.mas_equalTo(self.view).offset(-38);
        make.bottom.mas_equalTo(self.view).offset(-50);
    }];
    
    
}


#pragma mark - Setters




#pragma mark - Getters




@end
