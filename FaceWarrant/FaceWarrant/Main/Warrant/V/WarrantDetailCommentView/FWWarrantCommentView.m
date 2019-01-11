//
//  FWWarrantCommentView.m
//  FaceWarrant
//
//  Created by FW on 2018/8/2.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantCommentView.h"
#import "FWCommentListVC.h"
#import "FWWarrantSubCommentCell.h"
#import "FWWarrantSubFooterCell.h"
#import "FWCommentFooterCell.h"
#import "FWWarrantDetailModel.h"
//#import "UITableView+FDTemplateLayoutCell.h"
@interface FWWarrantCommentView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CommendReplyModel *model;
@property (nonatomic, strong) NSMutableArray *replyResponseDtoList;
@end

@implementation FWWarrantCommentView

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
    return 2;
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
        FWWarrantSubCommentCell *cell = [FWWarrantSubCommentCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ReplyModel *rmodel = [ReplyModel mj_objectWithKeyValues:self.model.replyResponseDtoList[indexPath.row]];
        [cell configCellWithReply:rmodel indexPath:indexPath];
        return cell;
    }else{
        FWWarrantSubFooterCell *cell = [FWWarrantSubFooterCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithNum:self.model.replyCount];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }else{
        return [FWWarrantSubFooterCell cellHeight];
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        FWCommentListVC *vc = [FWCommentListVC new];
        vc.commentType = @"2";
        vc.fromWarrant = @"1";
        vc.indexTag = self.tag;
        vc.dModel = self.dModel;
        vc.cModel = self.model;
        [[self superViewController:self].navigationController pushViewController:vc animated:NO];
    }
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


#pragma mark - Event Response


#pragma mark - Network Requests


#pragma mark - Public Methods
- (void)configViewWithModel:(CommendReplyModel*)model
{
    self.model = model;
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
- (NSMutableArray *)replyResponseDtoList
{
    if (_replyResponseDtoList == nil) {
        _replyResponseDtoList = [NSMutableArray array];
    }
    return _replyResponseDtoList;
}

#pragma mark - Getters



@end

