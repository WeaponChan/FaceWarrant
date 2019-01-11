//
//  FWQuestionDetailVC.m
//  FaceWarrant
//
//  Created by FW on 2018/8/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWQuestionDetailVC.h"
#import "FWQDetailFCell.h"
#import "FWQDetailVCell.h"
#import "FWMeManager.h"
#import "FWMessageManager.h"
#import "FWQAndADetailModel.h"
#import "FWReplyTextView.h"
#import "LGAudioKit.h"
#import "LhkhVoiceView.h"
#define DocumentPath  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
@interface FWQuestionDetailVC ()<UITableViewDelegate, UITableViewDataSource,FWReplyTextViewDelegate,FWQDetailVCellDelegate,LGAudioPlayerDelegate,LhkhVoiceViewDelegate>
{
    MBProgressHUD *_hud;
}
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;
@property (strong, nonatomic) FWQAndADetailModel *model;
@property (strong, nonatomic) FWReplyTextView *replyTextView;
@property (strong, nonatomic) LhkhVoiceView *voiceView;
@end
static int page = 1;
@implementation FWQuestionDetailVC



#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setTableView];
    [self setSubView];
    [LGAudioPlayer sharePlayer].delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码


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
        return self.dataList.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 0) {
        FWQDetailFCell *cell = [FWQDetailFCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell configCellWithModel:self.model subModel:nil indexPath:indexPath];
        return cell;
    }else{
        AnswerInfoListModel *aModel = self.dataList[indexPath.row];
        if ([aModel.answerType isEqualToString:@"0"]) {
            FWQDetailFCell *cell = [FWQDetailFCell cellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configCellWithModel:nil subModel:aModel indexPath:indexPath];
            return cell;
        }else{
            FWQDetailVCell *cell = [FWQDetailVCell cellWithTableView:tableView];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell configCellWithModel:nil subModel:aModel indexPath:indexPath];
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
    if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 40)];
        view.backgroundColor = Color_White;
        UILabel *allLab = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Screen_W-10, 40)];
        [view addSubview:allLab];
        if (self.model.answerCount == nil) {
            allLab.text = @"全部回答(0)";
        }else{
            allLab.text = [NSString stringWithFormat:@"全部回答(%@)",self.model.answerCount];
        }
        allLab.textColor = Color_Black;
        allLab.font = systemFont(14);
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39, Screen_W, 1)];
        lineView.backgroundColor = Color_MainBg;
        [view addSubview:lineView];
        return view;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 40;
    }
    return 5;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.replyTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.height.offset(60);
        }];
        self.voiceView.frame = CGRectMake(0, Screen_H, Screen_W, 250);
    }];
}

#pragma mark - Custom Delegate
#pragma mark - FWReplyTextViewDelegate
- (void)FWReplyTextViewDelegateSendMessage:(NSString *)messageText
{
    DLog(@"______>%@",messageText);
    [self replyMessageText:messageText answerType:@"0" audioTime:@""];
}

- (void)FWReplyTextViewDelegateRecordClick
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{

        [self.replyTextView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.offset(60);
            make.bottom.equalTo(self.view).offset(-250);
        }];
        self.voiceView.frame = CGRectMake(0, Screen_H-250, Screen_W, 250);
    }];
}

- (void)FWReplyTextViewDelegateEditEndClick
{
    self.voiceView.frame = CGRectMake(0, Screen_H, Screen_W, 250);
}


#pragma mark - LhkhVoiceViewDelegate

- (void)LhkhVoiceViewDelegateWithText:(NSString *)text
{
    DLog(@"______>%@",text);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"voiceRecognitionEnd" object:nil userInfo:@{@"text":text}];
}

- (void)LhkhVoiceViewDelegateAudio:(NSString *)audioUrl audioTime:(NSString *)audioTime
{
    [self replyMessageText:audioUrl answerType:@"1" audioTime:audioTime];
}

#pragma mark - FWQDetailVCellDelegate

- (void)FWQDetailVCellDelegateTapClick:(FWQDetailVCell *)cell
{
    [cell setVoicePlayState:LGVoicePlayStatePlaying];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    AnswerInfoListModel *aModel = self.dataList[indexPath.row];
    
    NSURL *url = [[NSURL alloc]initWithString:aModel.answerContent];
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
    [[LGAudioPlayer sharePlayer] playAudioWithURLString:amrfilePath atIndex:indexPath.row];
    
    NSURL *pathurl = [NSURL fileURLWithPath:amrfilePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (amrfilePath) {
        [fileManager removeItemAtURL:pathurl error:NULL];
    }
}

#pragma mark - LGAudioPlayerDelegate

- (void)audioPlayerStateDidChanged:(LGAudioPlayerState)audioPlayerState forIndex:(NSUInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:1];
    FWQDetailVCell *voiceMessageCell = [self.tableView cellForRowAtIndexPath:indexPath];
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
- (void)setAlertView
{
    [UIAlertController js_alertAviewWithTarget:self andAlertTitle:nil andMessage:@"您还没有碑它过此商品额~" andDefaultActionTitle:@"去碑它" dHandler:^(UIAlertAction *action) {
        [self.tabBarController setSelectedIndex:2];
    } andCancelActionTitle:@"算了" cHandler:^(UIAlertAction *action) {
        
    } completion:nil];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickBlank" object:nil];
//}

#pragma mark - Network Requests

/**
 获取回答列表
 */
- (void)loadData
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"questionId":self.questionId,
                            @"page":@"1",
                            @"rows":pageSize
                            };
    [FWMeManager loadQuestionAndAnswerDetailWithParameters:param result:^(FWQAndADetailModel *model,NSString *resultCode) {
        if ([resultCode isEqual:@200]) {
            self.model = model;
            [self.dataList removeAllObjects];
            self.dataList = [AnswerInfoListModel mj_objectArrayWithKeyValuesArray:model.answerInfoList];
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer setState:MJRefreshStateIdle];
            if (model.answerCount.floatValue < pageSize.floatValue) {
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            }
            if ([self.type isEqualToString:@"1"] || [self.type isEqualToString:@"2"]) {
                [self readedMessage];
            }
            self.replyTextView.placeholderLB.text = [NSString stringWithFormat:@"回答 %@",model.questionUser];
        }else if ([resultCode isEqual:@4002]){
            [MBProgressHUD showTips:@"该提问已被删除!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        page = 1;
    }];
}


/**
 获取更多的回答
 */
- (void)loadMoreData
{
    page++;
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"questionId":self.questionId,
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":pageSize
                            };
    [FWMeManager loadQuestionAndAnswerDetailWithParameters:param result:^(FWQAndADetailModel *model,NSString *resultCode) {
        if ([resultCode isEqual:@200]) {
            
            self.model = model;
            NSArray *arr = [NSArray array];
            arr = [AnswerInfoListModel mj_objectArrayWithKeyValuesArray:model.answerInfoList];
            [self.dataList addObjectsFromArray:arr];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            if (model.answerInfoList.count < pageSize.floatValue) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
                });
            }
        }else if([resultCode isEqual:@4002]){
            [MBProgressHUD showTips:@"该提问已被删除!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
    }];
}


/**
 已读
 */
- (void)readedMessage
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"messageId":self.messageId?:@"",
                            @"type":@"1"
                            };
    [FWMessageManager readedMessageWithParameters:param result:^(id response) {
        
    }];
}

/**
 回答
 @param text 回答的内容
 */
- (void)replyMessageText:(NSString*)text answerType:(NSString*)answerType audioTime:(NSString *)audioTime
{
//    _hud = [MBProgressHUD showHUDwithMessage:@"正在发布。。。"];
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"questionId":self.questionId,
                            @"toUserId":self.touserId?:self.model.questionUserId,
                            @"answerType":answerType,
                            @"answerContentTime":audioTime,
                            @"answerContent":text
                            };
    [FWMeManager replyQuestionWithParameters:param result:^(id response) {
//        [self->_hud hide];
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self.tableView.mj_header beginRefreshing];
            self.type = @"";
            self.replyTextView.textView.text = @"";
            [self loadData];
            if (response[@"result"] && [response[@"result"] isEqual:@0]) {
                [self setAlertView];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"answerEnd" object:nil userInfo:@{@"name":self.model.questionUser}];
        }else{
            [MBProgressHUD showError:response[@"resultDesc"]];
        }
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setNav
{
    self.navigationItem.title = @"问题详情";
}

- (void)setSubView
{
    [self.view addSubview:self.replyTextView];
    [self.replyTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.offset(60);
    }];
    
    [self.view addSubview:self.voiceView];
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
        make.bottom.mas_equalTo(self.view).offset(-60);
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
}

#pragma mark - Setters

- (FWReplyTextView*)replyTextView
{
    if (_replyTextView == nil) {
        _replyTextView = [[FWReplyTextView alloc]initWithFrame:CGRectZero];
        _replyTextView.delegate = self;
    }
    return _replyTextView;
}

- (NSMutableArray*)dataList
{
    if (_dataList == nil) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}



- (LhkhVoiceView*)voiceView
{
    if (_voiceView == nil) {
        _voiceView = [[LhkhVoiceView alloc] initWithFrame:CGRectMake(0, Screen_H, Screen_W, 250) titles:@[@"转文字",@"录音"]];
        _voiceView.backgroundColor = [UIColor redColor];
        _voiceView.vdelegate = self;
    }
    return _voiceView;
}



#pragma mark - Getters


@end
