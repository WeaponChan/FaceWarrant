//
//  FWFaceGroupsListVC.m
//  FaceWarrant
//
//  Created by FW on 2018/8/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFaceGroupsListVC.h"
#import "FWEditFacesVC.h"
#import "FWGroupUserCell.h"
#import "FWMeManager.h"
#import "FWAttentionModel.h"
#import "FWFaceAlertVC.h"
#import "FWAddAttentionVC.h"
@interface FWFaceGroupsListVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
{
    NSString *_type;
}
@property (strong, nonatomic)UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) LhkhTextField *searchText;
@property (strong, nonatomic)FWFaceAlertVC *faceAlertVC;
@end

@implementation FWFaceGroupsListVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setSubView];
    [self setCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}
#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码


#pragma mark - System Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([self.model.groupsName isEqualToString:@"大Face"]) {
        if ([_type isEqualToString:@"1"]) {
            return self.dataArr.count;
        }else{
            return self.dataArr.count+1;
        }
    }else{
        if ([_type isEqualToString:@"1"]) {
            return self.dataArr.count;
        }else{
            return self.dataArr.count+2;
        }
    }
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FWGroupUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([FWGroupUserCell class]) forIndexPath:indexPath];
    [cell configCellWithData:self.dataArr indexPath:indexPath type:_type faceGroupName:self.model.groupsName];
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
    DLog(@"---->%ld",indexPath.row);
    if ([self.model.groupsName isEqualToString:@"大Face"]) {
        if (indexPath.row == self.dataArr.count) {
            FWEditFacesVC *vc = [FWEditFacesVC new];
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
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
            FWEditFacesVC *vc = [FWEditFacesVC new];
            vc.type = @"2";
            vc.model = self.model;
            [self.navigationController pushViewController:vc animated:YES];
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



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.text.length == 0) {
       [self loadData];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loadSearchData:textField.text];
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    [self loadData];
    return YES;
}

#pragma mark - Custom Delegate


#pragma mark - Event Response




#pragma mark - Network Requests
- (void)loadData
{
    NSDictionary *param = @{
                            @"groupsId":self.model.groupsId,
                            @"requestType":@"1"
                            };
    [FWMeManager loadGroupsFaceListWithParameters:param result:^(NSArray < FWAttentionModel*> *model) {
        self->_type = @"0";
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:model];
        [self.collectionView reloadData];
        if (model.count > 0) {
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.collectionView];
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoSearchResult toView:self.collectionView];
        }
    }];
}

- (void)loadSearchData:(NSString *)text
{
    NSDictionary *param = @{
                            @"groupsId":self.model.groupsId,
                            @"requestType":@"1",
                            @"searchCondition":text
                            };
    [FWMeManager loadGroupsFaceListWithParameters:param result:^(NSArray < FWAttentionModel*> *model) {
        self->_type = @"1";
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:model];
        [self.collectionView reloadData];
        if (model.count > 0) {
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.collectionView];
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoSearchResult toView:self.collectionView];
        }
    }];
}



#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.title = [NSString stringWithFormat:@"%@(%@)",self.model.groupsName,self.model.faceNum];
}

- (void)setSubView
{
    UIView *searchView = [[UIView alloc] initWithFrame:CGRectZero];
    searchView.backgroundColor = Color_White;
    [self.view addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(NavigationBar_H+1);
        make.left.right.equalTo(self.view);
        make.height.offset(50);
    }];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.image = Image(@"search");
    [searchView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.left.equalTo(searchView).offset(20);
        make.centerY.equalTo(searchView.mas_centerY);
    }];
    
    [searchView addSubview:self.searchText];
    [self.searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.top.equalTo(searchView);
        make.left.equalTo(imageView.mas_right).offset(10);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = Color_MainBg;
    [searchView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.equalTo(searchView).offset(20);
        make.right.equalTo(searchView).offset(-20);
        make.bottom.equalTo(searchView);
    }];
}

- (void)setCollectionView
{
    _collectionView = ({
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        collectionView.backgroundColor = Color_White;
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[FWGroupUserCell class] forCellWithReuseIdentifier:NSStringFromClass([FWGroupUserCell class])];
        [self.view addSubview:collectionView];
        collectionView;
    });
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(NavigationBar_H+60);
        
    }];
}

#pragma mark - Setters

- (LhkhTextField*)searchText
{
    if (_searchText == nil) {
        _searchText = [[LhkhTextField alloc] initWithFrame:CGRectZero];
        _searchText.delegate = self;
        _searchText.font = systemFont(12);
        _searchText.placeholder = @"搜索";
        _searchText.textAlignment = NSTextAlignmentLeft;
        _searchText.returnKeyType = UIReturnKeySearch;
        _searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _searchText;
}

- (NSMutableArray*)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}

- (FWFaceAlertVC*)faceAlertVC
{
    if (_faceAlertVC == nil) {
        _faceAlertVC = [FWFaceAlertVC new];
    }
    return _faceAlertVC;
}

#pragma mark - Getters

@end
