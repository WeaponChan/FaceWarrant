//
//  FWMessageSubVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMessageSubVC.h"
#import "FWMFaceCell.h"
#import "FWMAttentionCell.h"
#import "FWMSystemCell.h"
#import "FWMAppreciateCell.h"
#import "FWMFavoriteCell.h"
#import "RefreshCatGifHeader.h"
#import "FWMQuestionCell.h"
#import "FWMVQuestionCell.h"
#import "FWMQReplyCell.h"
#import "FWMessageManager.h"
#import "FWMessageAModel.h"
#import "FWQuestionDetailVC.h"
#import "LGAudioKit.h"
@interface FWMessageSubVC ()<UITableViewDelegate, UITableViewDataSource,LGAudioPlayerDelegate,FWMQuestionCellDelegate,FWMVQuestionCellDelegate>
{
    NSMutableDictionary *cellHDic;
    UIBarButtonItem *right;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *messageList;

@end
static int page = 1;

@implementation FWMessageSubVC

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
    [self.tableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"releasePlayerDealloc" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [[LGAudioPlayer sharePlayer] stopAudioPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AttentionClick" object:nil];
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
    
    if ([self.typeStr isEqualToString:@"系统"]) {
        FWMSystemCell *cell = [FWMSystemCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if([self.typeStr isEqualToString:@"赏脸"] || [self.typeStr isEqualToString:@"收藏"]){
        FWMAppreciateCell *cell = [FWMAppreciateCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *type = @"";
        if ([self.typeStr isEqualToString:@"赏脸"]) {
            type = @"赏脸";
        }else{
            type = @"收藏";
        }
        [cell configCellWithModel:model type:type];
        return cell;
    }else if([self.typeStr isEqualToString:@"回答我的"]){
        if ([model.answerType isEqualToString:@"1"]) {
            FWMVQuestionCell *cell = [FWMVQuestionCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configCellWithModel:model];
            return cell;
        }else{
            FWMQuestionCell *cell = [FWMQuestionCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configCellWithModel:model indexPath:indexPath];
            return cell;
        }
    }else if([self.typeStr isEqualToString:@"对我提问"]){
        FWMQReplyCell *cell = [FWMQReplyCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithModel:model vctype:@""];
        return cell;
    }else if([self.typeStr isEqualToString:@"点赞"]){
        FWMFavoriteCell *cell = [FWMFavoriteCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithModel:model indexPath:indexPath];
        return cell;
    }else{
        FWMAttentionCell *cell = [FWMAttentionCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithModel:model indexPath:indexPath];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.typeStr isEqualToString:@"赏脸"]  || [self.typeStr isEqualToString:@"收藏"]) {
        return [FWMAppreciateCell cellHeight];;
    }else if ([self.typeStr isEqualToString:@"回答我的"] || [self.typeStr isEqualToString:@"对我提问"]){
        FWMessageAModel *model = self.messageList[indexPath.section];
        if ([model.answerType isEqualToString:@"1"]) {
            return 130;
        }else{
            if (model.isSpread) {
                return UITableViewAutomaticDimension;
            }
            return 120;
        }
    }else if([self.typeStr isEqualToString:@"点赞"]){
        return [FWMFavoriteCell cellHeight];
    }else{
        return [FWMAttentionCell cellHeight];
    }
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.typeStr isEqualToString:@"赏脸"]) {
        return 110;
    }else if ([self.typeStr isEqualToString:@"回答我的"] || [self.typeStr isEqualToString:@"对我提问"]){
        return 120;
    }else{
        return 65;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.typeStr isEqualToString:@"回答我的"]){
        FWMessageAModel *model = self.messageList[indexPath.section];
        if ([model.answerStatus isEqualToString:@"0"] && [model.questionStatus isEqualToString:@"0"]) {
            FWQuestionDetailVC *vc = [[FWQuestionDetailVC alloc] init];
            vc.questionId = model.questionId;
            vc.touserId = model.fromUserId;
            vc.messageId = model.messageId;
            vc.type = @"2";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }else if ([self.typeStr isEqualToString:@"对我提问"]){
        FWMessageAModel *model = self.messageList[indexPath.section];
        if ([model.questionStatus isEqualToString:@"0"]) {
            FWQuestionDetailVC *vc = [[FWQuestionDetailVC alloc] init];
            vc.questionId = model.questionId;
            vc.touserId = model.fromUserId;
            vc.messageId = model.messageId;
            vc.type = @"2";
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}

#pragma mark - Custom Delegate

#pragma mark - FWMQuestionCellDelegate

- (void)FWMQuestionCellDelegatespreadClick:(NSIndexPath *)indexPath
{
    FWMessageAModel *model = self.messageList[indexPath.section];
    model.isSpread = !model.isSpread;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - FWMVQuestionCellDelegate
- (void)FWMVQuestionCellDelegateTapClick:(FWMVQuestionCell *)cell
{
    [LGAudioPlayer sharePlayer].delegate = self;

    [cell setVoicePlayState:LGVoicePlayStatePlaying];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FWMessageAModel *model = self.messageList[indexPath.section];

    NSURL *url = [[NSURL alloc]initWithString:model.answerContent];
    NSData * audioData = [NSData dataWithContentsOfURL:url];

    // 将amr数据data写入到文件中
    NSString *filePath = [DocumentPath stringByAppendingPathComponent:@"amrSoundFile"];
    NSString *fileName = [NSString stringWithFormat:@"/audio-%5.2f.amr", [[NSDate date] timeIntervalSince1970] ];

    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:&error];
        if (error) {
            NSLog(@"%@", error);
        }
    }
    NSString *amrfilePath = [filePath stringByAppendingPathComponent:fileName];
    [audioData writeToFile:amrfilePath atomically:YES];
    [[LGAudioPlayer sharePlayer] playAudioWithURLString:amrfilePath atIndex:indexPath.section];

    NSURL *pathurl = [NSURL fileURLWithPath:amrfilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (amrfilePath) {
        [fileManager removeItemAtURL:pathurl error:NULL];
    }
}


#pragma mark - LGAudioPlayerDelegate

- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:index];
    FWMVQuestionCell *voiceMessageCell = [self.tableView cellForRowAtIndexPath:indexPath];
    LGVoicePlayState voicePlayState;
    switch (audioPlayerState) {
        case LGAudioPlayerStateNormal:
            voicePlayState = LGVoicePlayStateNormal;
            break;
        case LGAudioPlayerStatePlaying:
            voicePlayState = LGVoicePlayStatePlaying;
            break;
        case LGAudioPlayerStateCancel:
            voicePlayState = LGVoicePlayStateCancel;
            break;

        default:
        break;    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [voiceMessageCell setVoicePlayState:voicePlayState];
    });
}

#pragma mark - Event Response

- (void)allRead
{
    NSString *type = @"";
    if ([self.typeStr isEqualToString:@"回答我的"]) {
        type = @"A";
    }else if ([self.typeStr isEqualToString:@"对我提问"]){
        type = @"Q";
    }else if ([self.typeStr isEqualToString:@"赏脸"]){
        type = @"F";
    }else if ([self.typeStr isEqualToString:@"点赞"]){
        type = @"LC";
    }else if ([self.typeStr isEqualToString:@"收藏"]){
        type = @"CO";
    }else if ([self.typeStr isEqualToString:@"关注"]){
        type = @"AT";
    }
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"messageType":type,
                            @"type":@"1"
                            };
    [FWMessageManager allReadAndDeleteMessageWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self loadMessageList];
        }
    }];
}

- (void)refreshData
{
    [self loadMessageList];
}

#pragma mark - Network requests

- (void)loadMessageList
{
    NSString *type = @"";
    if ([self.typeStr isEqualToString:@"回答我的"]) {
        type = @"A";
    }else if ([self.typeStr isEqualToString:@"对我提问"]){
        type = @"Q";
    }else if ([self.typeStr isEqualToString:@"赏脸"]){
        type = @"F";
    }else if ([self.typeStr isEqualToString:@"点赞"]){
        type = @"LC";
    }else if ([self.typeStr isEqualToString:@"收藏"]){
        type = @"CO";
    }else if ([self.typeStr isEqualToString:@"关注"]){
        type = @"AT";
    }
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"messageType":type,
                            @"page":@"1",
                            @"rows":pageSize
                            };
    [FWMessageManager loadMessageListWithParameters:param result:^(NSArray <FWMessageAModel*> *model,NSString *count) {
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
            if ([self.typeStr isEqualToString:@"赏脸"]) {
                [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoShanglian toView:self.tableView];
            }else{
                [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoMessage toView:self.tableView];
            }
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
    NSString *type = @"";
    if ([self.typeStr isEqualToString:@"回答我的"]) {
        type = @"A";
    }else if ([self.typeStr isEqualToString:@"对我提问"]){
        type = @"Q";
    }else if ([self.typeStr isEqualToString:@"赏脸"]){
        type = @"F";
    }else if ([self.typeStr isEqualToString:@"点赞"]){
        type = @"LC";
    }else if ([self.typeStr isEqualToString:@"收藏"]){
        type = @"CO";
    }else if ([self.typeStr isEqualToString:@"关注"]){
        type = @"AT";
    }else if ([self.typeStr isEqualToString:@"评论"]){
        type = @"C";
    }
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"messageType":type,
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":pageSize
                            };
    [FWMessageManager loadMessageListWithParameters:param result:^(NSArray <FWMessageAModel*> *model,NSString *count) {
        
        [self.tableView.mj_footer endRefreshing];
        if (model.count<pageSize.floatValue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
        
        [self.messageList addObjectsFromArray:model];
        [self.tableView reloadData];
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

- (void)setNav
{
    self.navigationItem.title = self.typeStr;
    if ([self.typeStr isEqualToString:@"收藏"]) {
        self.navigationItem.title = @"心愿单";
    }
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"AttentionClick" object:nil];
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
