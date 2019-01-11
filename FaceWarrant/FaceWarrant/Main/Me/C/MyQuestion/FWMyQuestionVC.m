//
//  FWMyQuestionVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMyQuestionVC.h"
#import "FWMeQuestionCell.h"
#import "FWMeAnswerCell.h"
#import "FWMeVoiceAnswerCell.h"
#import "FWMeManager.h"
#import "FWMeQuestionModel.h"
#import "FWMeAnswerModel.h"
#import "FWQuestionDetailVC.h"
#import "LGAudioKit.h"

@interface FWMyQuestionVC ()<UITableViewDelegate, UITableViewDataSource,FWMeVoiceAnswerCellDelegate,LGAudioPlayerDelegate>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;

@end
static int page = 1;
@implementation FWMyQuestionVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setTableView];
    [LGAudioPlayer sharePlayer].delegate = self;
}

- (void)dealloc
{
    [[LGAudioPlayer sharePlayer] stopAudioPlayer];
}

#pragma mark - Layout SubViews
//11.29换新的框架 替换掉原来适配的代码


#pragma mark - System Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.vctype isEqualToString:@"我的提问"]) {
        FWMeQuestionModel *model = self.dataList[indexPath.section];
        FWMeQuestionCell *cell = [FWMeQuestionCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithModel:model indexPath:indexPath];
        return cell;
    }else{
        FWMeAnswerModel *model = self.dataList[indexPath.section];
        if ([model.answerType isEqualToString:@"1"]) {
            FWMeVoiceAnswerCell * cell = [FWMeVoiceAnswerCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configCellWithModel:model indexPath:indexPath];
            return cell;
        }else{
            FWMeAnswerCell *cell = [FWMeAnswerCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configCellWithModel:model indexPath:indexPath];
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
    FWQuestionDetailVC *vc = [[FWQuestionDetailVC alloc] init];
    vc.type = @"3";
    if ([self.vctype isEqualToString:@"我的提问"]) {
        FWMeQuestionModel *model = self.dataList[indexPath.section];
        vc.questionId = model.questionId;
    }else{
        FWMeAnswerModel *model = self.dataList[indexPath.section];
        vc.questionId = model.questionId;
    }

    [self.navigationController pushViewController:vc animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  YES;
}

-(NSArray<UITableViewRowAction*>*)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *rowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
                                                                             [UIAlertController js_alertAviewWithTarget:self andAlertTitle:@"确认删除？" andMessage:nil andDefaultActionTitle:@"确认" dHandler:^(UIAlertAction *action) {
                                                                                 if ([self.vctype isEqualToString:@"我的提问"]) {
                                                                                     FWMeQuestionModel *model = self.dataList[indexPath.section];
                                                                                     [self deleteQandAWithId:model.questionId];
                                                                                 }else{
                                                                                     FWMeAnswerModel *model = self.dataList[indexPath.section];
                                                                                     [self deleteQandAWithId:model.answerId];
                                                                                 }
                                                                                 
                                                                             } andCancelActionTitle:@"取消" cHandler:nil completion:nil];
                                                                         }];
    
    
    NSArray *arr = @[rowAction];
    return arr;
}

#pragma mark - Custom Delegate
#pragma mark - FWMeVoiceAnswerCellDelegate

- (void)FWMeVoiceAnswerCellDelegateTapClick:(FWMeVoiceAnswerCell *)cell
{
    [cell setVoicePlayState:LGVoicePlayStatePlaying];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    FWMeAnswerModel *model = self.dataList[indexPath.section];
    
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
    FWMeVoiceAnswerCell *voiceMessageCell = [self.tableView cellForRowAtIndexPath:indexPath];
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


#pragma mark - Network Requests

- (void)loadData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"page":@"1",
                            @"rows":pageSize
                            };
    [self.tableView.mj_footer setState:MJRefreshStateIdle];
    if ([self.vctype isEqualToString:@"我的提问"]) {
        [FWMeManager loadMyQuestionListWithParameters:param result:^(NSArray <FWMeQuestionModel*> *model) {
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:model];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            if (self.dataList.count == 0) {
                [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoQuestion toView:self.tableView];
            }else{
                [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView: self.tableView];
                
                if (self.dataList.count < pageSize.floatValue) {
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                }
            }
            page = 1;
        }];
    }else{
        [FWMeManager loadMyAnswerListWithParameters:param result:^(NSArray <FWMeAnswerModel*> *model) {
            [self.dataList removeAllObjects];
            [self.dataList addObjectsFromArray:model];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            if (self.dataList.count == 0) {
                [[LhkhEmptyViewManager sharedTipsManager] showTipsViewType:TipsType_HaveNoAnswer toView:self.tableView];
            }else{
                [[LhkhEmptyViewManager sharedTipsManager] removeTipsViewFromView: self.tableView];
                if (self.dataList.count < pageSize.floatValue) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                    });
                }
            }
            
            page = 1;
        }];
    }
}


- (void)loadMoreData
{
    page++;
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":pageSize
                            };
    if ([self.vctype isEqualToString:@"我的提问"]) {
        [FWMeManager loadMyQuestionListWithParameters:param result:^(NSArray <FWMeQuestionModel*> *model) {
            [self.dataList addObjectsFromArray:model];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            if (model.count < pageSize.floatValue) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                });
            }
        }];
    }else{
        [FWMeManager loadMyAnswerListWithParameters:param result:^(NSArray <FWMeAnswerModel*> *model) {
            [self.dataList addObjectsFromArray:model];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            if (model.count < pageSize.floatValue) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                });
            }
        }];
    }
}

- (void)deleteQandAWithId:(NSString*)QandAId
{
    
    if ([self.vctype isEqualToString:@"我的提问"]) {
        NSDictionary *param = @{
                                @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                                @"questionId":QandAId
                                };
        [FWMeManager deleteQuestionWithParameters:param result:^(id response) {
            [self loadData];
        }];
    }else{
        NSDictionary *param = @{
                                @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                                @"answerId":QandAId
                                };
        [FWMeManager deleteAnswerWithParameters:param result:^(id response) {
            [self loadData];
        }];
    }
}

#pragma mark - Public Methods


#pragma mark - Private Methods

- (void)setNav
{
    self.navigationItem.title = self.vctype;
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
        make.top.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    
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

- (NSMutableArray *)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}


#pragma mark - Getters


@end
