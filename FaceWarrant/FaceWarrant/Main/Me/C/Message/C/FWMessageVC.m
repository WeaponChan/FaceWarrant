//
//  FWMessageVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/26.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMessageVC.h"
#import "FWMessageCell.h"
#import "FWMessageSubVC.h"
#import "FWMessageCommentVC.h"
#import "FWMessageManager.h"
#import "FWMessageModel.h"

@interface FWMessageVC ()<UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) FWMessageModel *model;

@end

@implementation FWMessageVC

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
    [self loadMessage];
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
        return 2;
    }else {
        return 5;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWMessageCell *cell = [FWMessageCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell configCellWithModel:self.model indexPath:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
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
    if (indexPath.section == 0) {
        FWMessageSubVC *vc = [FWMessageSubVC new];
        if (indexPath.row == 0) {
            vc.typeStr = @"回答我的";
            vc.countStr = self.model.answerToMeCount;
        }else{
            vc.typeStr = @"对我提问";
            vc.countStr = self.model.questionToMeCount;
        }
        [self.navigationController pushViewController:vc animated:NO];
        
    }else if (indexPath.section == 1){
        if (indexPath.row == 4) {
            FWMessageCommentVC *vc = [FWMessageCommentVC new];
            vc.countStr = self.model.commendNewCount;
            [self.navigationController pushViewController:vc animated:NO];
        }else{
            FWMessageSubVC *vc = [FWMessageSubVC new];
            if (indexPath.row == 0) {
                vc.typeStr = @"赏脸";
                vc.countStr = self.model.favoriteNewCount;
            }else if (indexPath.row == 1){
                vc.typeStr = @"点赞";
                vc.countStr = self.model.likeNewCount;
            }else if (indexPath.row == 2){
                vc.typeStr = @"收藏";
                vc.countStr = self.model.collectionCount;
            }else if (indexPath.row == 3){
                vc.typeStr = @"关注";
                vc.countStr = self.model.attentionNewCount;
            }
            [self.navigationController pushViewController:vc animated:NO];
        }
    }
}

#pragma mark - Custom Delegate




#pragma mark - Event Response




#pragma mark - Network requests
- (void)loadMessage
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID]
                            };
    [FWMessageManager loadMessageWithParameters:param result:^(FWMessageModel *model) {
        self.model = model;
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }];
}



#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setNav
{
    self.navigationItem.title = @"消息";
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
    
    __weak typeof (self) weakself = self;
    self.tableView.mj_header = [RefreshCatGifHeader headerWithRefreshingBlock:^{
        [weakself loadMessage];
    }];
//        [self.tableView.mj_header beginRefreshing];
}

#pragma mark - Setters




#pragma mark - Getters




@end
