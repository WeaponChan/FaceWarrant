//
//  FWCommentView.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/19.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWCommentView.h"
#import "FWCommentListVC.h"
#import "FWCommentSubCell.h"
#import "FWCommentFooterCell.h"
#import "FWWarrantDetailModel.h"
#import "FWCommentModel.h"
#import "FWCommentManager.h"
#import "FWReplyListVC.h"
@interface FWCommentView()<UITableViewDelegate,UITableViewDataSource,FWCommentFooterCellDelegate,FWCommentSubCellDelegate>
{
    BOOL _isSpread;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) FWWarrantDetailModel *dmodel;
@property (nonatomic, strong) FWCommendReplyModel *model;
@property (nonatomic, strong) NSMutableArray *replyList;
@end

@implementation FWCommentView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTableView];
    }
    return self;
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.model.replyResponseDtoList.count == 2) {
        return 2;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.model.replyResponseDtoList.count;
    }else{
        return 1;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        FWCommentSubCell *cell = [FWCommentSubCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        FWReplyModel *rmodel = [FWReplyModel mj_objectWithKeyValues:self.model.replyResponseDtoList[indexPath.row]];
        [cell configCellWithCommentModel:self.model replyModel:rmodel indexPath:indexPath];
        return cell;
    }else{
        FWCommentFooterCell *cell = [FWCommentFooterCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithNum:self.model indexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }else{
        return [FWCommentFooterCell cellHeight];
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
 
}

#pragma mark 获取当前View所在的ViewController
- (UIViewController *)superViewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}

#pragma mark - Custom Delegate
#pragma mark - FWCommentFooterCellDelegate
- (void)FWCommentFooterCellDelegateClick:(NSString *)commentId
{
    FWReplyListVC *vc = [FWReplyListVC new];
    vc.model = self.model;
    vc.dModel = self.dmodel;
    [[self superViewController:self].navigationController pushViewController:vc animated:YES];
}

#pragma mark - FWCommentSubCellDelegate
- (void)FWCommentSubCellDelegateCommentClick:(FWReplyModel*)rmodel indexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(FWCommentViewDelegateSubCellClickWithModel:indexPath:)]) {
        [self.delegate FWCommentViewDelegateSubCellClickWithModel:rmodel indexPath:indexPath];
    }
}

- (void)FWCommentSubCellDelegateCommentDeleteClick:(FWReplyModel *)model indexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(FWCommentViewDelegateSubCellDeleteClickWithModel:indexPath:)]) {
        [self.delegate FWCommentViewDelegateSubCellDeleteClickWithModel:model indexPath:indexPath];
    }
}

#pragma mark - Event Response


#pragma mark - Network Requests


#pragma mark - Public Methods
- (void)configViewWithModel:(FWWarrantDetailModel*)dmodel model: (FWCommendReplyModel*)model moreReplyArr:(NSArray*)moreReplyArr
{
    self.dmodel = dmodel;
    self.model = model;
    [self.replyList addObjectsFromArray:moreReplyArr];
    [self.tableView reloadData];
}

#pragma mark - Private Methods
- (void)setTableView
{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        [self addSubview:tableView];
        tableView;
    });
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self);
    }];
}

#pragma mark - Setters
- (NSMutableArray *)replyList
{
    if (_replyList == nil) {
        _replyList = [NSMutableArray array];
    }
    return _replyList;
}

#pragma mark - Getters



@end
