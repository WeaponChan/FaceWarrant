//
//  FWCommentListVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/20.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWCommentListVC.h"
#import "FWCommentCell.h"
#import "FWCommentManager.h"
#import "FWCommentModel.h"
#import "FWCommentBottomView.h"
#import "FWReplyListVC.h"
@interface FWCommentListVC ()<UITableViewDelegate,UITableViewDataSource,FWCommentCellDelegate,FWCommentBottomViewDelegate>
{
    NSString *_replyType;
    NSString *_replyCommentId;
    NSString *_toUserId;
    NSString *_replyId;
    NSString *_commentId;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FWCommentBottomView *bottomView;
@property (strong, nonatomic) FWCommentModel *model;
@property (strong, nonatomic) NSMutableArray *commentList;
@property (strong, nonatomic) NSMutableArray *moreReplyList;

@end

static int page = 1;
@implementation FWCommentListVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setTableView];
    [self setBottomView];
}


#pragma mark - Layout SubViews

- (void)updateViewConstraints
{
    [self.tableView setContentOffset:CGPointMake(0, (self.indexTag-1)*280-NavigationBar_H) animated:YES];
    [super updateViewConstraints];
//    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
}

#pragma mark - System Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentList.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWCommentCell *cell = [FWCommentCell cellWithTableView:tableView];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    FWCommendReplyModel *model = self.commentList[indexPath.row];
    [cell configCellWithData:self.dModel model:model moreReplyData:self.moreReplyList indexPath:indexPath];
    if (self.commentList.count >=20 && (indexPath.row == self.commentList.count-4) && (self.tableView.mj_footer.state != MJRefreshStateNoMoreData)) {
        [self.tableView.mj_footer beginRefreshing];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickBlank" object:nil];
}



#pragma mark - Custom Delegate
#pragma mark - FWCommentBottomViewDelegate

- (void)FWCommentBottomViewDelegateSendMessage:(NSString *)messageText indexPath:(NSIndexPath *)indexPath
{
    if ([self.commentType isEqualToString:@"1"]) {
        [self sendCommentMessage:messageText commentId:@""];
    }else{
        [self sendReplyMessage:messageText indexPath:indexPath];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"replyOrcommentEnd" object:nil userInfo:nil];
}

#pragma mark - FWCommentCellDelegate
//点击的评论上面的评论按钮
- (void)FWCommentCellDelegateClickWithModel:(FWCommendReplyModel*)model indexPath:(NSIndexPath *)indexPath
{
    self.commentType = @"2";
    _replyType = @"1";
    _replyCommentId = model.commentId;
    _toUserId = model.commentFromUserId;
    _commentId = model.commentId;
    _replyId = @"";
    [self.bottomView.textView becomeFirstResponder];
    self.bottomView.indexPath = indexPath;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reply" object:nil userInfo:@{@"name":model.commentFromUser,@"type":@"0"}];
}

//点击的回复上面的评论按钮
- (void)FWCommentCellDelegateReplyClickWithModel:(FWReplyModel *)rmodel indexPath:(NSIndexPath *)indexPath
{
    self.commentType = @"3";
    _replyType = @"2";
    _commentId = rmodel.commentId;
    _toUserId = rmodel.replyFromUserId;
    _replyCommentId = rmodel.replyId;
    _replyId = @"";
    [self.bottomView.textView becomeFirstResponder];
    self.bottomView.indexPath = indexPath;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reply" object:nil userInfo:@{@"name":rmodel.replyFromUser,@"type":@"1"}];
}

- (void)FWCommentCellDelegateCommentDeleteClick:(FWCommendReplyModel *)model indexPath:(NSIndexPath *)indexPath
{
    [self sendCommentMessage:@"" commentId:model.commentId];
}

- (void)FWCommentCellDelegateReplyDeleteClick:(FWReplyModel *)rmodel indexPath:(NSIndexPath *)indexPath
{
    _replyId = rmodel.replyId;
    _commentId = rmodel.commentId;
    [self sendReplyMessage:@"" indexPath:indexPath];
}
#pragma mark - Event Response


#pragma mark - Network Requests

- (void)loadData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"releaseGoodsId":self.dModel.releaseGoodsId?:self.releaseGoodsId,
                            @"page":@"1",
                            @"rows":pageSize
                            };
    [FWCommentManager loadCommentListWithParameters:param result:^(FWCommentModel *model,NSString *resultCode) {
        [self.tableView.mj_footer setState:MJRefreshStateIdle];
        if ([resultCode isEqual:@200]) {
            [self.commentList removeAllObjects];
            if (model.commendReplyResponseDtoList.count == 0) {
                [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoComment toView:self.tableView];
            }else{
                [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView:self.tableView];
                self.commentList = [FWCommendReplyModel mj_objectArrayWithKeyValuesArray:model.commendReplyResponseDtoList];
                [self.tableView reloadData];
            }
            
            if (self.commentList.count < pageSize.floatValue) {
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            }
            
        }else{
            [MBProgressHUD showTips:@"此碑它已被取消"];
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoComment toView:self.tableView];
        }
        page = 1;
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData
{
    page++;
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"releaseGoodsId":self.dModel.releaseGoodsId?:self.releaseGoodsId,
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":pageSize
                            };
    [FWCommentManager loadCommentListWithParameters:param result:^(FWCommentModel *model,NSString *resultCode) {
        [self.tableView.mj_footer endRefreshing];
        if ([resultCode isEqual:@200]) {
            [self.commentList addObjectsFromArray:[FWCommendReplyModel mj_objectArrayWithKeyValuesArray:model.commendReplyResponseDtoList]];
            [self.tableView reloadData];
            if (model.commendReplyResponseDtoList.count < pageSize.floatValue) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                });
            }
        }else{
            [MBProgressHUD showTips:@"此碑它已被取消"];
        }
    }];
}


- (void)sendReplyMessage:(NSString*)text indexPath:(NSIndexPath*)indexPath
{
    
    if ([self.fromWarrant isEqualToString:@"1"]) {
        _replyType = @"1";
        _commentId = self.cModel.commentId;
        _toUserId = self.cModel.commentFromUserId;
        _replyCommentId = self.cModel.commentId;
    }
    
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
            [MBProgressHUD showTips:response[@"resultDesc"]];
            [self.tableView.mj_header beginRefreshing];
//            NSArray <NSIndexPath *> *indexPathArray = @[indexPath];
//            [self.tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
            self.commentType = @"1";
        }else{
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }
    }];
}

- (void)sendCommentMessage:(NSString*)text commentId:(NSString*)commentId
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"faceId":self.dModel.faceId,
                            @"commentContent":text,
                            @"commentId":commentId,
                            @"releaseGoodsId":self.dModel.releaseGoodsId
                            };
    [FWCommentManager sendCommentMessageTextWithParameter:param result:^(id response) {
        if ([response[@"success"] isEqual:@1]) {
            [MBProgressHUD showTips:response[@"resultDesc"]];
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
    self.navigationItem.title = @"全部评论";
    self.view.backgroundColor = Color_White;
}

- (void)setTableView
{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = [UIColor clearColor];
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
    LhkhWeakSelf(self);
    self.tableView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
    
    self.tableView.mj_footer = [RefreshCatGifFooter footerWithRefreshingBlock:^{
        [weakself loadMoreData];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

- (void)setBottomView
{
    [self.view addSubview:self.bottomView];

    self.bottomView.placeholderLB.text = @"既然来了，不说点什么吗";
    if ([self.commentType isEqualToString:@"2"] && [self.fromWarrant isEqualToString:@"1"]) {
        [self.bottomView.textView becomeFirstResponder];
    }
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

- (NSMutableArray*)commentList
{
    if (_commentList == nil) {
        _commentList = [NSMutableArray array];
    }
    return _commentList;
}

- (NSMutableArray*)moreReplyList
{
    if (_moreReplyList == nil) {
        _moreReplyList = [NSMutableArray array];
    }
    return _moreReplyList;
}
#pragma mark - Getters


@end
