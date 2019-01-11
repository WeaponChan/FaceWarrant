//
//  FWMessageCommentVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMessageCommentVC.h"
#import "FWMCommentFCell.h"
#import "FWMCommentSCell.h"
#import "FWMessageManager.h"
#import "FWMessageAModel.h"

@interface FWMessageCommentVC ()<UITableViewDelegate, UITableViewDataSource>
{
    UIBarButtonItem *right;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *messageList;

@end
static int page = 1;
@implementation FWMessageCommentVC

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
    [self loadMessageList];
}

#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码


#pragma mark - System Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.messageList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWMessageAModel *model = self.messageList[indexPath.section];
    if ([model.type isEqualToString:@"0"]) {
        FWMCommentFCell *cell = [FWMCommentFCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithModel:model];
        return cell;
    }else{
        FWMCommentSCell *cell = [FWMCommentSCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithModel:model];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return [UIView new];
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 10;
    }else{
        return 0;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 2;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                             FWMessageAModel *model = self.messageList[indexPath.section];
                                                                             [self deleteMessageWithId:model.messageId];
                                                                         }];
    
    
    NSArray *arr = @[rowAction];
    return arr;
}

#pragma mark - Custom Delegate




#pragma mark - Event Response

- (void)allRead
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"messageType":@"C",
                            @"type":@"1"
                            };
    [FWMessageManager allReadAndDeleteMessageWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self loadMessageList];
        }
    }];
}


#pragma mark - Network requests

- (void)loadMessageList
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"messageType":@"C",
                            @"page":@"1",
                            @"rows":pageSize
                            };
    [FWMessageManager loadMessageListWithParameters:param result:^(NSArray <FWMessageAModel*> *model, NSString *count) {
        
        [self.tableView.mj_footer setState:MJRefreshStateIdle];
        if (![count isEqual:@0]) {
            self->right.enabled = YES;
        }else{
            self->right.enabled = NO;
        }
        [self.messageList removeAllObjects];
        [self.messageList addObjectsFromArray:model];
        [self.tableView reloadData];
        if (model.count<pageSize.floatValue) {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        if (model.count == 0) {
            [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoMessage toView:self.tableView];
        }else{
            [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView: self.tableView];
        }
        [self.tableView.mj_header endRefreshing];
        page = 1;
    }];
}

- (void)loadMoreMessageList
{
    page++;
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"messageType":@"C",
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":pageSize
                            };
    [FWMessageManager loadMessageListWithParameters:param result:^(NSArray <FWMessageAModel*> *model,NSString *count) {
        [self.messageList addObjectsFromArray:model];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        if (model.count<pageSize.floatValue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
    }];
}

- (void)deleteMessageWithId:(NSString *)messageId
{
    [UIAlertController js_alertAviewWithTarget:self andAlertTitle:@"确认删除？" andMessage:nil andDefaultActionTitle:@"确认" dHandler:^(UIAlertAction *action) {
        
        NSDictionary *param = @{
                                @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                                @"type":@"2",
                                @"messageId":messageId
                                };
        [FWMessageManager editMessageWithParameters:param result:^(id response) {
            [self loadMessageList];
        }];
        
    } andCancelActionTitle:@"取消" cHandler:nil completion:nil];
}

#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setNav
{
    self.navigationItem.title = @"评论与回复";
    right = [[UIBarButtonItem alloc] initWithTitle:@"全部已读" style:UIBarButtonItemStylePlain target:self action:@selector(allRead)];
    [right setTintColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]];
    [right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,Color_Theme_Pink,NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    [right setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,Color_SubText,NSForegroundColorAttributeName, nil] forState:UIControlStateDisabled];
    self.navigationItem.rightBarButtonItem = right;
    if (self.countStr.floatValue>0) {
        right.enabled = YES;
    }else{
        right.enabled = NO;
    }
}


#pragma mark - Private Methods

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
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
    __weak typeof (self) weakself = self;
    self.tableView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadMessageList];
    }];
    
    self.tableView.mj_footer = [RefreshCatGifFooter footerWithRefreshingBlock:^{
        [weakself loadMoreMessageList];
    }];
}



#pragma mark - Setters



- (NSMutableArray*)messageList
{
    if (_messageList == nil) {
        _messageList = [NSMutableArray array];
    }
    return _messageList;
}


#pragma mark - Getters




@end
