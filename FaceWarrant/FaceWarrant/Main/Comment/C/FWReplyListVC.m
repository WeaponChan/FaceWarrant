//
//  FWReplyListVC.m
//  FaceWarrant
//
//  Created by FW on 2018/10/9.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWReplyListVC.h"
#import "FWCommentBottomView.h"
#import "FWAllReplyCell.h"
#import "FWCommentManager.h"
#import "FWCommentModel.h"
@interface FWReplyListVC ()<UITableViewDelegate,UITableViewDataSource,FWCommentBottomViewDelegate,FWAllReplyCellDelegate>
{
    NSString *_replyType;
    NSString *_replyCommentId;
    NSString *_toUserId;
    NSString *_replyId;
    NSString *_commentId;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FWCommentBottomView *bottomView;
@property (strong, nonatomic) NSMutableArray *replyList;
@end

@implementation FWReplyListVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setTableView];
    [self setBottomView];
    
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return self.replyList.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWAllReplyCell *cell = [FWAllReplyCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        [cell configCellWithData:self.model replyData:nil indexPath:indexPath];
    }else{
        FWReplyModel *rmodel = self.replyList[indexPath.row];
        [cell configCellWithData:self.model replyData:rmodel indexPath:indexPath];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

#pragma mark - Custom Delegate

#pragma mark - FWCommentBottomViewDelegate

- (void)FWCommentBottomViewDelegateSendMessage:(NSString *)messageText indexPath:(NSIndexPath *)indexPath
{
    [self sendReplyMessage:messageText indexPath:indexPath];
    self.bottomView.textView.text = @"";
    self.bottomView.placeholderLB.text = @"既然来了，不说点什么吗";
}

#pragma mark - FWAllReplyCellDelegate

- (void)FWAllReplyCellDelegateCommentAndReplyDeleteClick:(FWCommendReplyModel *)model rmodel:(FWReplyModel *)rmodel indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self sendCommentMessage:@"" commentId:model.commentId];
    }else{
        _commentId = rmodel.commentId;
        _replyId = rmodel.replyId;
        [self sendReplyMessage:@"" indexPath:indexPath];
    }
}

- (void)FWAllReplyCellDelegateCommentAndReplyClick:(FWCommendReplyModel *)model rmodel:(FWReplyModel *)rmodel indexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        _replyType = @"1";
        _replyCommentId = model.commentId;
        _toUserId = model.commentFromUserId;
        _commentId = model.commentId;
        _replyId = @"";
    }else{
        _replyType = @"2";
        _replyCommentId = rmodel.replyId;
        _toUserId = rmodel.replyFromUserId;
        _commentId = rmodel.commentId;
        _replyId = @"";
    }
    self.bottomView.indexPath = indexPath;
    [self.bottomView.textView becomeFirstResponder];
}
#pragma mark - Event Response


#pragma mark - Network Requests
- (void)loadData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"commentId":self.model.commentId
                            };
    [FWCommentManager loadMoreReplyListWithParameter:param result:^(NSArray<FWReplyModel *> *model) {
        [self.replyList removeAllObjects];
        [self.replyList addObjectsFromArray:model];
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)sendReplyMessage:(NSString*)text indexPath:(NSIndexPath*)indexPath
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"replyType":_replyType?:@"",
                            @"replyCommentId":_replyCommentId?:@"",
                            @"toUserId":_toUserId?:@"",
                            @"replyContent":text?:@"",
                            @"replyId":_replyId?:@"",
                            @"commentId":_commentId?:@""
                            };
    [FWCommentManager sendReplyMessageTextWithParameter:param result:^(id response) {
        if ([response[@"success"] isEqual:@1]) {
            [MBProgressHUD showSuccess:response[@"resultDesc"]];
            [self.tableView.mj_header beginRefreshing];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

- (void)sendCommentMessage:(NSString*)text commentId:(NSString*)commentId
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"faceId":self.dModel.faceId,
                            @"commentContent":@"",
                            @"commentId":commentId,
                            @"releaseGoodsId":self.dModel.releaseGoodsId
                            };
    [FWCommentManager sendCommentMessageTextWithParameter:param result:^(id response) {
        if ([response[@"success"] isEqual:@1]) {
            [MBProgressHUD showSuccess:response[@"resultDesc"]];
            [self.tableView.mj_header beginRefreshing];
        }else if ([response[@"resultCode"] isEqual:@4002]){
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.title = @"全部回复";
    self.view.backgroundColor = Color_White;
    
    //初始化这些值  防止直接回复 造成的接口错误
    _replyType = @"1";
    _replyCommentId = self.model.commentId;
    _toUserId = self.model.commentFromUserId;
    _commentId = self.model.commentId;
    _replyId = @"";
}

- (void)setTableView
{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = Color_White;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-60);
    }];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    __weak typeof(self) weakself = self;
    self.tableView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setBottomView
{
    [self.view addSubview:self.bottomView];
    self.bottomView.placeholderLB.text = @"既然来了，不说点什么吗";
}

#pragma mark - Setters

- (FWCommentBottomView*)bottomView
{
    if (_bottomView == nil) {
        _bottomView = [[FWCommentBottomView alloc]initWithFrame:CGRectZero];
        _bottomView.delegate = self;
    }
    return _bottomView;
}


- (NSMutableArray*)replyList
{
    if (_replyList == nil) {
        _replyList = [NSMutableArray array];
    }
    return _replyList;
}
#pragma mark - Getters
@end
