//
//  FWFaceGroupEditVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/23.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFaceGroupEditVC.h"
#import "FWFaceGroupsListVC.h"
#import "FWEditFacesVC.h"
#import "FWGroupUserCell.h"
#import "FWMeManager.h"
#import "FWAttentionModel.h"
#import "FWFaceAlertVC.h"
#import "FWAddAttentionVC.h"
#define cellWidth (Screen_W-60)/5
@interface FWFaceGroupEditVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic)UIButton *moreBtn;
@property (strong, nonatomic)UIView *groupView;
@property (strong, nonatomic)UILabel *groupLab;
@property (strong, nonatomic)UILabel *groupNameLab;
@property (strong, nonatomic)UIButton *editBtn;
@property (strong, nonatomic)FWFaceAlertVC *faceAlertVC;
@property (strong, nonatomic) NSMutableArray *dataArr;

@end

@implementation FWFaceGroupEditVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setCollectionView];
    [self setSubView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码

- (void)reMakeViewFrame
{
    float hang = (self.dataArr.count + 6)/5;
    
    [self.collectionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        float H = 0;
        if ([self.model.groupsName isEqualToString:@"大Face"]) {
            if (self.dataArr.count>=0 && self.dataArr.count!=4 && self.dataArr.count!=9 && self.dataArr.count!=14 && self.dataArr.count!=19) {
                H = hang*(cellWidth+45);
            }else{
                H = (hang-1)*(cellWidth+45);
            }
        }else{
            H = hang*(cellWidth+45);
        }
        if (iOS11Later) {
            make.height.offset(H);
        }else{
            make.height.offset(H+60);
        }
        make.left.right.equalTo(self.view);
        if (iOS11Later) {
            make.top.mas_equalTo(self.view).offset(NavigationBar_H+10);
        }else{
            make.top.mas_equalTo(self.view).offset(10);
        }
    }];

    if ([self.model.groupsName isEqualToString:@"大Face"]) {
        if (self.dataArr.count>0 && self.dataArr.count == 19) {
            self.moreBtn.hidden = NO;
            [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(30);
                make.top.equalTo(self.collectionView.mas_bottom);
                make.left.right.equalTo(self.view);
            }];
        }else{
            self.moreBtn.hidden = YES;
            [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.offset(0);
                make.top.equalTo(self.collectionView.mas_bottom);
                make.left.right.equalTo(self.view);
            }];
        }
    }else if (self.dataArr.count>0 && self.dataArr.count == 18){
        self.moreBtn.hidden = NO;
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(30);
            make.top.equalTo(self.collectionView.mas_bottom);
            make.left.right.equalTo(self.view);
        }];
    }else{
        self.moreBtn.hidden = YES;
        [self.moreBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(0);
            make.top.equalTo(self.collectionView.mas_bottom);
            make.left.right.equalTo(self.view);
        }];
    }
}


#pragma mark - System Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.model.groupsName isEqualToString:@"大Face"]) {
         return self.dataArr.count+1;
    }else{
        return self.dataArr.count+2;
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWGroupUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FWGroupUserCell class]) forIndexPath:indexPath];
    [cell configCellWithData:self.dataArr indexPath:indexPath type:@"0" faceGroupName:self.model.groupsName];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [FWGroupUserCell cellSize];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.model.groupsName isEqualToString:@"大Face"]) {
        if (indexPath.row == self.dataArr.count) {
            if (self.dataArr.count == 0) {
                [UIAlertController js_alertAviewWithTarget:self andAlertTitle:@"" andMessage:@"还没群成员额，赶紧去添加吧" andDefaultActionTitle:@"去添加" dHandler:^(UIAlertAction *action) {
                    FWAddAttentionVC *vc = [FWAddAttentionVC new];
                    vc.model = self.model;
                    [self.navigationController pushViewController:vc animated:YES];
                } andCancelActionTitle:@"取消" cHandler:nil completion:nil];
            }else{
                FWEditFacesVC *vc = [FWEditFacesVC new];
                vc.type = @"2";
                vc.model = self.model;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            FWAttentionModel *model = self.dataArr[indexPath.row];
            self.faceAlertVC.model = model;
            [self.faceAlertVC configViewWithModel:model];
            self.faceAlertVC.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            self.faceAlertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:self.faceAlertVC animated:NO completion:^(void)
             {
                 self.faceAlertVC.view.superview.backgroundColor = [UIColor clearColor];
                 
             }];
        }
    }else{
        
        if (indexPath.row == self.dataArr.count) {
            DLog(@"Add");
            FWAddAttentionVC *vc = [FWAddAttentionVC new];
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
            
        }else if (indexPath.row == self.dataArr.count +1){
            if (self.dataArr.count == 0) {
                [UIAlertController js_alertAviewWithTarget:self andAlertTitle:@"" andMessage:@"还没群成员额，赶紧去添加吧" andDefaultActionTitle:@"去添加" dHandler:^(UIAlertAction *action) {
                    FWAddAttentionVC *vc = [FWAddAttentionVC new];
                    vc.model = self.model;
                    [self.navigationController pushViewController:vc animated:YES];
                } andCancelActionTitle:@"取消" cHandler:nil completion:nil];
            }else{
                FWEditFacesVC *vc = [FWEditFacesVC new];
                vc.type = @"2";
                vc.model = self.model;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }else{
            FWAttentionModel *model = self.dataArr[indexPath.row];
            self.faceAlertVC.model = model;
            [self.faceAlertVC configViewWithModel:model];
            self.faceAlertVC.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
            self.faceAlertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            [self presentViewController:self.faceAlertVC animated:NO completion:^(void)
             {
                 self.faceAlertVC.view.superview.backgroundColor = [UIColor clearColor];
                 
             }];
        }
    }
    
}

#pragma mark - Custom Delegate


#pragma mark - Event Response

- (void)moreClick
{
    FWFaceGroupsListVC *vc = [FWFaceGroupsListVC new];
    vc.model = self.model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editClick
{
    if ([self.model.groupsName isEqualToString:@"大Face"] || [self.model.groupsName isEqualToString:@"亲友Face"]) {
        [MBProgressHUD showTips:[NSString stringWithFormat:@"%@是默认群组，不可修改名称",self.model.groupsName]];
    }else{
        FWEditFacesVC *vc = [FWEditFacesVC new];
        vc.type = @"1";
        vc.model = self.model;
        vc.groupblock = ^(NSString *str) {
            self.groupNameLab.text = str;
            self.navigationItem.title = str;
        };
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Network Requests

- (void)loadData
{
    NSDictionary *param = @{
                            @"groupsId":self.model.groupsId,
                            @"requestType":@"0"
                            };
    [FWMeManager loadGroupsFaceListWithParameters:param result:^(NSArray < FWAttentionModel*> *model) {
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:model];
        [self.collectionView reloadData];
        [self reMakeViewFrame];
    }];
}


#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.title = self.model.groupsName;
}

- (void)setCollectionView
{
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = Color_White;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        collectionView.scrollEnabled = NO;
        [collectionView registerClass:[FWGroupUserCell class] forCellWithReuseIdentifier:NSStringFromClass([FWGroupUserCell class])];
        [self.view addSubview:collectionView];
        collectionView;
    });
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset((Screen_W-60)/5);
        make.left.right.equalTo(self.view);
        if (iOS11Later) {
            make.top.mas_equalTo(self.view).offset(NavigationBar_H);
        }else{
            make.top.mas_equalTo(self.view);
        }
    }];
}

- (void)setSubView
{
    self.groupView = [[UIView alloc] initWithFrame:CGRectZero];
    self.groupView.backgroundColor = Color_White;
    [self.view addSubview:self.moreBtn];
    [self.view addSubview:self.groupView];
    [self.groupView addSubview:self.groupLab];
    [self.groupView addSubview:self.groupNameLab];
    [self.groupView addSubview:self.editBtn];
    
    self.moreBtn.hidden = YES;
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(0);
        make.top.equalTo(self.collectionView.mas_bottom);
        make.left.right.equalTo(self.view);
    }];
    [self.groupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(50);
        make.top.equalTo(self.moreBtn.mas_bottom).offset(15);
        make.left.right.equalTo(self.view);
    }];
    
    [self.groupLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.groupView).offset(10);
        make.width.offset(80);
        make.top.bottom.equalTo(self.groupView);
    }];
    
    [self.groupNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.groupLab.mas_right).offset(20);
        make.top.bottom.equalTo(self.groupView);
        make.right.equalTo(self.groupView).offset(-15);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.groupView);
    }];
}


#pragma mark - Setters

- (UIButton*)moreBtn
{
    if (_moreBtn == nil) {
        _moreBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _moreBtn.backgroundColor = Color_White;
        _moreBtn.titleLabel.font = systemFont(16);
        [_moreBtn setTitle:@"查看全部成员" forState:UIControlStateNormal];
        [_moreBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

- (UILabel*)groupLab
{
    if (_groupLab == nil) {
        _groupLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _groupLab.text = @"群名称";
        _groupLab.font = systemFont(14);
        _groupLab.textColor = Color_SubText;
    }
    return _groupLab;
}

- (UILabel*)groupNameLab
{
    if (_groupNameLab == nil) {
        _groupNameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _groupNameLab.text = self.model.groupsName;
        _groupNameLab.font = systemFont(14);
        _groupNameLab.textColor = Color_MainText;
        _groupNameLab.textAlignment = NSTextAlignmentRight;
    }
    return _groupNameLab;
}

- (UIButton *)editBtn
{
    if (_editBtn == nil) {
        _editBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_editBtn addTarget:self action:@selector(editClick) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _editBtn;
}

- (FWFaceAlertVC*)faceAlertVC
{
    if (_faceAlertVC == nil) {
        _faceAlertVC = [FWFaceAlertVC new];
    }
    return _faceAlertVC;
}

- (NSMutableArray*)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

#pragma mark - Getters


@end
