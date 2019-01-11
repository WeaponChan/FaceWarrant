//
//  FWAddAttentionVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/16.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWAddAttentionVC.h"
#import "FWAttentionCell.h"
#import "FWSearchView.h"
#import "FWVoiceView.h"
#import "FWFaceLibraryManager.h"
#import <AddressBook/AddressBook.h>
#import "FWAttentionModel.h"
#import "FWContactModel.h"
#import "FWRecommendModel.h"
#import "UIButton+Lhkh.h"
#import "FWAddAttentionMoreVC.h"
@interface FWAddAttentionVC ()<UITableViewDataSource,UITableViewDelegate,FWSearchViewDelegate,FWAttentionCellDelegate,FWVoiceViewDelegate>
{
    NSString *_selectTag;
    NSString *_contactStr;
    NSString *_requestType;
    NSString *_searchType;
    NSString *_moreType;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FWSearchView *searchView;
@property (strong, nonatomic) FWVoiceView *voiceView;
@property (strong, nonatomic) NSMutableArray *facelist;
@property (strong, nonatomic) NSMutableArray *contactsFaceList;
@property (strong, nonatomic) NSMutableArray *recommendFaceList;
@end

@implementation FWAddAttentionVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setTableView];
    [self setSubView];
}


#pragma mark - Layout SubViews
//11.29换新的框架 替换掉原来适配的代码


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - System Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.model.groupsName isEqualToString:@"大Face"]) {
        return 1;
    }else{
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.facelist.count;
    }else{
        if ([self.model.groupsName isEqualToString:@"亲友Face"]) {
            return self.contactsFaceList.count;
        }else{
            return self.recommendFaceList.count;
        }
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWAttentionCell *cell = [FWAttentionCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = self;
    
    if (indexPath.section == 0) {
        FWAttentionModel *model = self.facelist[indexPath.row];
        [cell configCellWithModel:model cmodel:nil rmodel:nil  indexPath:indexPath type:@"FWAddAttentionVC" tag:_selectTag];
    }else{
        if ([self.model.groupsName isEqualToString:@"亲友Face"]) {
            FWContactModel *model = self.contactsFaceList[indexPath.row];
            [cell configCellWithModel:nil cmodel:model rmodel:nil indexPath:indexPath type:@"FWAddAttentionVC" tag:_selectTag];
        }else{
            FWRecommendModel *model = self.recommendFaceList[indexPath.row];
            [cell configCellWithModel:nil cmodel:nil rmodel:model indexPath:indexPath type:@"FWAddAttentionVC" tag:_selectTag];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 40)];
    view.backgroundColor = Color_MainBg;
    
    UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_W-60, 6, 50, 28)];
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    moreBtn.titleLabel.font = systemFont(14);
    [moreBtn setTitleColor:Color_SubText forState:UIControlStateNormal];
    [moreBtn setImage:Image(@"you") forState:UIControlStateNormal];
    [moreBtn changeImageAndTitle];
    [view addSubview:moreBtn];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Screen_W-10, 40)];
    label.font = systemFont(16);
    label.textColor = Color_SubText;
    [view addSubview:label];
    if (section == 0) {
        [moreBtn addTarget:self action:@selector(moreFClick) forControlEvents:UIControlEventTouchUpInside];
        if ([self.model.groupsName isEqualToString:@"大Face"]) {
            label.text = @"推荐";
        }else{
            label.text = @"我的关注";
        }
    }else if(section == 1){
        [moreBtn addTarget:self action:@selector(moreSClick) forControlEvents:UIControlEventTouchUpInside];
        if ([self.model.groupsName isEqualToString:@"亲友Face"]) {
            label.text = @"我的通讯录";
        }else{
            label.text = @"推荐";
        }
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
#pragma mark - Custom Delegate

#pragma mark - FWSearchViewDelegate
- (void)FWSearchViewDelegateWithText:(NSString *)text
{
    if (text.length>0 && ![text isEqualToString:@""]) {
        FWAddAttentionMoreVC *vc = [FWAddAttentionMoreVC new];
        vc.model = self.model;
        vc.searchText = text;
        vc.searchType = @"0";
        vc.contactStr = _contactStr;
        vc.type = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self.view endEditing:YES];
}

- (void)FWSearchViewDelegateWithTextViewBeginEditing
{
    self.voiceView.hidden = YES;
}

- (void)FWSearchViewDelegateVoiceClick
{
    [self.searchView.searchText resignFirstResponder];
    self.voiceView.hidden = NO;
}

#pragma mark - FWVoiceViewDelegate
-(void)FWVoiceViewDelegateWithText:(NSString *)text
{
    self.searchView.searchText.text = text;
    self.voiceView.hidden = YES;
    if (text.length>0 && ![text isEqualToString:@""]) {
        FWAddAttentionMoreVC *vc = [FWAddAttentionMoreVC new];
        vc.model = self.model;
        vc.searchText = text;
        vc.searchType = @"0";
        vc.contactStr = _contactStr;
        vc.type = @"0";
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - FWAttentionCellDelegate
- (void)FWAttentionCellDelegateAddClick:(NSString *)faceId indexPath:(NSIndexPath *)indexPath
{
    [self addAttention:faceId indexPath:indexPath];
}

- (void)FWAttentionCellDelegateInviteClick:(NSString *)phoneNum countryCode:(NSString *)code indexPath:(NSIndexPath *)indexPath
{
    [self inviteFace:phoneNum code:code indexPath:indexPath];
}

#pragma mark - Event Response
- (void)moreFClick
{
    if ([self.model.groupsName isEqualToString:@"大Face"]) {
        _moreType = @"0";
    }else{
        _moreType = @"1";
    }
    FWAddAttentionMoreVC *vc = [FWAddAttentionMoreVC new];
    vc.model = self.model;
    vc.searchType = _searchType;
    vc.contactStr = _contactStr;
    vc.moreType = _moreType;
    vc.type = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)moreSClick
{
    if ([self.model.groupsName isEqualToString:@"亲友Face"]) {
        _moreType = @"2";
    }else{
        _moreType = @"3";
    }
    FWAddAttentionMoreVC *vc = [FWAddAttentionMoreVC new];
    vc.model = self.model;
    vc.searchType = _searchType;
    vc.contactStr = _contactStr;
    vc.moreType = _moreType;
    vc.type = @"1";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showKeyboard:(NSNotification*)notif
{
    NSString *type = notif.userInfo[@"type"];
    if ([type isEqualToString:@"0"]) {
        self.voiceView.hidden = YES;
        [self.searchView.searchText becomeFirstResponder];
    }else{
        [self.view endEditing:YES];
        self.voiceView.hidden = NO;
    }
}

#pragma mark - Network Requests
- (void)loadData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"groupsId":self.model.groupsId,
                            @"groupsType":self.model.groupsType,
                            @"requestType":_requestType,
                            @"phoneInfo":_contactStr?:@"",
                            @"isoCode":[USER_DEFAULTS objectForKey:UD_ISO]?:@""
                            };
    [FWFaceLibraryManager loadFaceHomeOtherFaceWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self.facelist removeAllObjects];
            self.facelist = [FWAttentionModel mj_objectArrayWithKeyValuesArray:response[@"result"][@"facesList"]];
            if ([self.model.groupsName isEqualToString:@"亲友Face"]) {
                self.contactsFaceList = [FWContactModel mj_objectArrayWithKeyValuesArray:response[@"result"][@"contactsFaceList"]];
            }else{
                self.recommendFaceList = [FWRecommendModel mj_objectArrayWithKeyValuesArray:response[@"result"][@"recommendFaceList"]];
            }
            [self.tableView reloadData];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)addAttention:(NSString*)faceId indexPath:(NSIndexPath *)indexPath
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"groupsId":self.model.groupsId,
                            @"groupsType":self.model.groupsType,
                            @"faceId":faceId
                            };
    [FWFaceLibraryManager addFaceToGroupWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [USER_DEFAULTS setObject:@"1" forKey:UD_FaceLibraryChange];
            [MBProgressHUD showSuccess:response[@"resultDesc"]];
            if (indexPath.section == 0) {
                FWAttentionModel *model = self.facelist[indexPath.row];
                model.isAttened = !model.isAttened;
            }else{
                FWRecommendModel *rmodel = self.recommendFaceList[indexPath.row];
                rmodel.isAttened = !rmodel.isAttened;
            }
            NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

- (void)inviteFace:(NSString*)phone code:(NSString*)code indexPath:(NSIndexPath*)indexPath
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"contactPhone":phone,
                            @"countryCode":code
                            };
    [FWFaceLibraryManager inviteFaceToGroupWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [MBProgressHUD showSuccess:response[@"resultDesc"]];
            FWContactModel *cmodel = self.contactsFaceList[indexPath.row];
            cmodel.isInvited = !cmodel.isInvited;
            NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.title = @"添加Face";
    [self.view addSubview:self.searchView];
    if ([self.model.groupsName isEqualToString:@"大Face"]) {
        _selectTag = @"0";
    }else if([self.model.groupsName isEqualToString:@"亲友Face"]){
        _selectTag = @"1";
    }else{
        _selectTag = @"2";
    }
    _requestType = @"0";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showKeyboard:) name:@"showKeyboard" object:nil];
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
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(NavigationBar_H+50);
        make.bottom.mas_equalTo(self.view);
    }];
    
    LhkhWeakSelf(self);
    self.tableView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        if([weakself.model.groupsName isEqualToString:@"亲友Face"]){
            self->_searchType = @"1";
            DLog(@"---11111---%@",[self getCurrentTimes]);
            [weakself getContact];
            
        }else{
            self->_searchType = @"0";
            [weakself loadData];
        }
    }];
}


- (void)setSubView
{
    self.voiceView.hidden = YES;
    self.voiceView.delegate = self;
    [self.view addSubview:self.voiceView];
    
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(200);
        make.left.right.bottom.equalTo(self.view);
    }];
}

- (void)getContact
{
    ABAddressBookRef addressRef = ABAddressBookCreateWithOptions(nil, nil);
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressRef, ^(bool granted, CFErrorRef error) {
            if (!error) {
                if (granted) {
                    // 授权成功
                    DLog(@"允许");
                    NSArray *contacts = [self fetchContactWithAddressBook:addressRef];
                    NSError *error = nil;
                    NSData *data = [NSJSONSerialization dataWithJSONObject:contacts options:NSJSONWritingPrettyPrinted error:&error];
                    NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    self->_contactStr = jsonStr;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self loadData];
                    });
                }else{
                    // 授权失败
                    DLog(@"拒绝");
                    [self loadData];
                }
            }else{
                DLog(@"错误error=%@",error);
                [self loadData];
            }
        });
    }else{
        if (status != kABAuthorizationStatusAuthorized) {
            [UIAlertController js_alertAviewWithTarget:self andAlertTitle:@"提示" andMessage:@"请在设备的\"设置>隐私>通讯录\"中允许访问通讯录。" andDefaultActionTitle:@"确定" dHandler:^(UIAlertAction *action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            } andCancelActionTitle:@"取消" cHandler:^(UIAlertAction *action) {
                return;
            } completion:^{
                [self loadData];
            }];
        }else{
            NSArray *contacts = [self fetchContactWithAddressBook:addressRef];
            NSError *error = nil;
            NSData *data = [NSJSONSerialization dataWithJSONObject:contacts options:NSJSONWritingPrettyPrinted error:&error];
            NSString *jsonStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            _contactStr = jsonStr;
            //jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\""];
            dispatch_async(dispatch_get_main_queue(), ^{
                DLog(@"---2222---%@",[self getCurrentTimes]);
                [self loadData];
            });
        }
    }
}

-(NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    return currentTimeString;
    
}


- (NSMutableArray *)fetchContactWithAddressBook:(ABAddressBookRef)addressBook{
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {////有权限访问
        //获取联系人数组
        NSArray *array = (__bridge NSArray *)ABAddressBookCopyArrayOfAllPeople(addressBook);
        NSMutableArray *contacts = [NSMutableArray array];
        for (int i = 0; i < array.count; i++) {
            //获取联系人
            ABRecordRef people = CFArrayGetValueAtIndex((__bridge ABRecordRef)array, i);
            //获取联系人详细信息,如:姓名,电话,住址等信息
            NSString *firstName = (__bridge NSString *)ABRecordCopyValue(people, kABPersonFirstNameProperty);
            NSString *lastName = (__bridge NSString *)ABRecordCopyValue(people, kABPersonLastNameProperty);
            
            //判断姓名null
            NSString *allName;
            if ((lastName != nil && ![lastName isEqualToString:@""] && ![lastName isKindOfClass:[NSNull class]]) && (firstName != nil && ![firstName isEqualToString:@""] && ![firstName isKindOfClass:[NSNull class]])) {
                allName = [NSString stringWithFormat:@"%@%@",lastName,firstName];
            }else if((firstName != nil && ![firstName isEqualToString:@""] && ![firstName isKindOfClass:[NSNull class]])){
                allName = firstName;
            }else if ((lastName != nil && ![lastName isEqualToString:@""] && ![lastName isKindOfClass:[NSNull class]])){
                allName = lastName;
            }else{
                allName = @"";
            }
            
            ABMutableMultiValueRef phoneNumRef = ABRecordCopyValue(people, kABPersonPhoneProperty);
            NSArray *phones = ((__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneNumRef));
//                        NSString *phoneNumber =  ((__bridge NSArray *)ABMultiValueCopyArrayOfAllValues(phoneNumRef)).lastObject;
////            判断手机号null
//                        NSString *phone;
//                        if (phoneNumber != nil && (![phoneNumber isEqualToString:@""] && ![phoneNumber isKindOfClass:[NSNull class]])) {
//                            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
//                            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
//                            phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@"·" withString:@""];
//                            phone = phoneNumber;
//                        }else{
//                            phone = @"";
//                        }
            if (phones == nil) {
                phones = @[];
            }
            //如果不加上面的判断，这里加入数组的时候会出错，不会判断(null)这个东西，所以要先排除
            [contacts addObject:@{@"name": allName, @"phoneNumber": phones}];
            
        }
        return contacts;
    }else{//无权限访问
        //提示授权
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\n设置-隐私-通讯录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        return nil;
    }
}



#pragma mark - Setters

- (FWSearchView*)searchView
{
    if (_searchView == nil) {
        _searchView = [[FWSearchView alloc] initWithFrame:CGRectMake(10, NavigationBar_H+10, Screen_W-20, 30)];
        _searchView.vcStr = @"FWAddAttentionVC";
        _searchView.delegate = self;
        _searchView.searchText.placeholder = @"请输入Face名称";
        _searchView.clickBtn.hidden = YES;
        
    }
    return _searchView;
}

- (FWVoiceView*)voiceView
{
    if (_voiceView == nil) {
        _voiceView = [[FWVoiceView alloc] initWithFrame:CGRectMake(0, Screen_H-300, Screen_W, 300)];
        _voiceView.vctype = @"0";
        [self.view addSubview:_voiceView];
        _voiceView.hidden = YES;
    }
    return _voiceView;
}

- (NSMutableArray *)facelist
{
    if (_facelist == nil) {
        _facelist = [NSMutableArray array];
    }
    return _facelist;
}

-(NSMutableArray*)contactsFaceList
{
    if (_contactsFaceList == nil) {
        _contactsFaceList = [NSMutableArray array];
    }
    return _contactsFaceList;
}

-(NSMutableArray*)recommendFaceList
{
    if (_recommendFaceList == nil) {
        _recommendFaceList = [NSMutableArray array];
    }
    return _recommendFaceList;
}

#pragma mark - Getters

@end
