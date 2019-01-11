//
//  FWMyFacesSubVC.m
//  FaceWarrant
//
//  Created by FW on 2018/10/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMyFacesSubVC.h"
#import "FWPersonalHomePageVC.h"
#import "FWFaceLibraryCell.h"
#import "FWFaceLibraryManager.h"
#import "FWFaceLibraryModel.h"
#import "RTDragCellTableView.h"
@interface FWMyFacesSubVC ()<RTDragCellTableViewDelegate,RTDragCellTableViewDataSource,UIScrollViewDelegate>
{
    NSString *_groupId;
    BOOL isFirst;
}
@property (strong, nonatomic) RTDragCellTableView *tableView;
@property (strong, nonatomic) NSMutableArray *faceLiabraryList;
@property (strong, nonatomic) NSMutableArray *facechangeLiabraryList;
@end
static int page = 1;
@implementation FWMyFacesSubVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topClick) name:@"topClick" object:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSString *changeStatus = [USER_DEFAULTS objectForKey:UD_FaceLibraryChange];
    if ([changeStatus isEqualToString:@"1"]) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Layout SubViews
//11.29换新的框架 替换掉原来适配的代码


#pragma mark - System Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.faceLiabraryList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWFaceLibraryModel *model = self.faceLiabraryList[indexPath.row];
    FWFaceLibraryCell *cell = [FWFaceLibraryCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithModel:model indexPath:indexPath selectType:self.groupId];
    if (self.faceLiabraryList.count>=20 && (indexPath.row == self.faceLiabraryList.count-4) && (self.tableView.mj_footer.state != MJRefreshStateNoMoreData)) {
        [self.tableView.mj_footer beginRefreshing];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FWFaceLibraryCell cellHeight];
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
    FWFaceLibraryModel *model = self.faceLiabraryList[indexPath.row];
    FWPersonalHomePageVC *vc = [[FWPersonalHomePageVC alloc] init];
    vc.faceId = model.faceId;
    vc.hidesBottomBarWhenPushed = YES;
    isFirst = YES;
    [self.navigationController pushViewController:vc animated:NO];
}


- (NSArray *)originalArrayDataForTableView:(RTDragCellTableView *)tableView{
    return self.facechangeLiabraryList;
}

- (void)tableView:(RTDragCellTableView *)tableView newArrayDataForDataSource:(NSArray *)newArray{
    [self.facechangeLiabraryList removeAllObjects];
    [self.facechangeLiabraryList addObjectsFromArray: newArray];
}

- (void)cellDidEndMovingInTableView:(RTDragCellTableView *)tableView fromIndex:(NSIndexPath *)fromIndex toIndex:(NSIndexPath *)toIndex
{
    DLog(@"EndMoving--fromIndex-->%ld--toIndex--%ld",(long)fromIndex.row,(long)toIndex.row);
    FWFaceLibraryModel *fmodel = self.faceLiabraryList[fromIndex.row];
    FWFaceLibraryModel *tmodel = self.faceLiabraryList[toIndex.row];
    [self changeFaceIndexWithID:fmodel.faceId fIndex:fmodel.userIndex tIndex:tmodel.userIndex];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if ([self.delegate respondsToSelector:@selector(FWMyFacesSubVCDelegateScrollOffsetY:)]) {
        [self.delegate FWMyFacesSubVCDelegateScrollOffsetY:offsetY];
    }
}

#pragma mark - Custom Delegate


#pragma mark - Event Response

- (void)topClick
{
    DLog(@"top");
    [self.tableView setContentOffset:CGPointMake(0, 0) animated:YES];
}


#pragma mark - Network Requests
- (void)loadData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"groupsId":self.groupId,
                            @"page":@"1",
                            @"rows":pageSize
                            };
    [FWFaceLibraryManager loadFaceLibraryListWithParameters:param result:^(NSArray<FWFaceLibraryModel *> *model) {
        [USER_DEFAULTS setObject:@"0" forKey:UD_FaceLibraryChange];
        [self.faceLiabraryList removeAllObjects];
        [self.faceLiabraryList addObjectsFromArray:model];
        [self.facechangeLiabraryList removeAllObjects];
        [self.facechangeLiabraryList addObjectsFromArray:model];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_footer setState:MJRefreshStateIdle];
        });
        if (self.faceLiabraryList.count == 0) {
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoRecomment toView:self.tableView];
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView: self.tableView];
            
            if (model.count < pageSize.integerValue) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                });
            }
        }
        page = 1;
    }];
}

- (void)loadMoreData
{
    page++;
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"groupsId":self.groupId,
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":pageSize
                            };
    [FWFaceLibraryManager loadFaceLibraryListWithParameters:param result:^(NSArray<FWFaceLibraryModel *> *model) {
        
        [self.faceLiabraryList addObjectsFromArray:model];
        [self.facechangeLiabraryList addObjectsFromArray:model];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        if (model.count < pageSize.integerValue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
    }];
}

- (void)changeFaceIndexWithID:(NSString *)faceId fIndex:(NSString*)fromIndex tIndex:(NSString*)toIndex
{
    
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"groupsId":self.groupId,
                            @"faceId":faceId,
                            @"beforeIndex":fromIndex,
                            @"afterIndex":toIndex
                            };
    [FWFaceLibraryManager changeFaceIndexFaceWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self loadData];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setTableView
{
    self.view.backgroundColor = Color_MainBg;
    
    _tableView = ({
        RTDragCellTableView *tableView = [[RTDragCellTableView alloc]init];
        tableView.frame = CGRectZero;
        tableView.backgroundColor = Color_MainBg;
        tableView.allowsSelection = YES;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(5);
        make.right.mas_equalTo(self.view).offset(-5);
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).offset(-TabBar_H);
    }];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    LhkhWeakSelf(self);
    self.tableView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    
    self.tableView.mj_footer = [RefreshCatGifFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - Setters

- (NSMutableArray *)faceLiabraryList
{
    if (_faceLiabraryList == nil) {
        _faceLiabraryList = [NSMutableArray array];
    }
    return _faceLiabraryList;
}

- (NSMutableArray *)facechangeLiabraryList
{
    if (_facechangeLiabraryList == nil) {
        _facechangeLiabraryList = [NSMutableArray array];
    }
    return _facechangeLiabraryList;
}


#pragma mark - Getters



@end
