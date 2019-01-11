//
//  FWFaceLibraryAllBrandVC.m
//  FaceWarrant
//
//  Created by FW on 2018/9/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFaceLibraryAllBrandVC.h"
#import "FWFaceLibraryBrandCell.h"
#import "FWBrandModel.h"
#import "LGUIView.h"
#import "FWFacelibrarySearchModel.h"
#import "FWFaceLibraryManager.h"
@interface FWFaceLibraryAllBrandVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSDictionary *_tempDic;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *keyArr;
@property (strong, nonatomic) NSMutableArray *dataArr;
@property (strong, nonatomic) LGUIView *syView;
@end

@implementation FWFaceLibraryAllBrandVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadData];
}

#pragma mark - Layout SubViews


#pragma mark - System Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.keyArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        self.dataArr = [FWBrandModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[section]]];
        return self.dataArr.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FWFaceLibraryBrandCell *cell = [FWFaceLibraryBrandCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        [cell configCellWithName:@"全部" indexPath:indexPath];
    }else{
        self.dataArr = [FWBrandModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section]]];
        FWBrandModel *model = self.dataArr[indexPath.row];
        [cell configCellWithName:model.brandName indexPath:indexPath];
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [FWFaceLibraryBrandCell cellHeight];
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }else{
        UIView *view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, 40)];
        view.backgroundColor = Color_MainBg;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Screen_W-10, 40)];
        label.text = self.keyArr[section];
        label.textColor = Color_Black;
        label.font = systemFont(14);
        [view addSubview:label];
        return view;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (self.brandidblock) {
            self.brandidblock(nil,@"全部");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }else{
        self.dataArr = [FWBrandModel mj_objectArrayWithKeyValuesArray:self->_tempDic[self.keyArr[indexPath.section]]];
        FWBrandModel *model = self.dataArr[indexPath.row];
        if (self.brandidblock) {
            self.brandidblock(model,@"");
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (IBAction)sureClick:(UIButton *)sender {
    
}

- (IBAction)backClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Network Requests
- (void)loadData
{
    if (self.syView) {
        UIView *view = [self.view viewWithTag:100001];
        [view removeFromSuperview];
    }
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"searchCondition":self.searchText,
                            @"requestType":@"1"
                            };
    [FWFaceLibraryManager loadFaceLibrarySearchDataWithParameters:param result:^(id response) {
        self->_tempDic = response[@"result"];
        NSArray *tempArr = response[@"result"];
        [self.keyArr removeAllObjects];
        [self.dataArr removeAllObjects];
        
        NSMutableArray *arr = [NSMutableArray array];
        for (NSString *key in tempArr) {
            [arr addObject:key];
        }
        for (id _obj in [arr sortedArrayUsingSelector:@selector(compare:)]) {
            [self.keyArr addObject:_obj];
        }
        [self.keyArr insertObject:@"↑" atIndex:0];
        [self.tableView reloadData];
        [self setSYView];
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Public Methods


#pragma mark - Private Methods
- (void)setTableView
{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)setSYView
{
    self.syView = [[LGUIView alloc] initWithFrame:CGRectMake(Screen_W-40, (Screen_H-15*(self.keyArr.count+1))/2, 40, 15*(self.keyArr.count+1)) indexArray:self.keyArr];
    self.syView.tag = 100001;
    [self.view addSubview:self.syView];
    
    [self.syView selectIndexBlock:^(NSInteger section)
     {
         if (section == 0) {
             [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                                         animated:NO
                                   scrollPosition:UITableViewScrollPositionTop];
         }else{
             [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section-1]
                                         animated:NO
                                   scrollPosition:UITableViewScrollPositionTop];
         }
     }];
}


#pragma mark - Setters
- (NSMutableArray*)keyArr
{
    if (_keyArr == nil) {
        _keyArr = [NSMutableArray new];
    }
    return _keyArr;
}

- (NSMutableArray*)dataArr
{
    if (_dataArr == nil) {
        _dataArr = [NSMutableArray new];
    }
    return _dataArr;
}

#pragma mark - Getters


@end
