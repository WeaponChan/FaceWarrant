//
//  FWAiteFaceCell.m
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWAiteFaceCell.h"
#import "FWAiteFaceModel.h"
@interface FWAiteFaceCell ()
@property (strong, nonatomic)UILabel *nameLab;
@property (strong, nonatomic)UIButton *checkBtn;
@property (strong, nonatomic)NSMutableArray *faceIdList;
@property (strong, nonatomic)NSMutableArray *groupIdList;
@property (strong, nonatomic)NSIndexPath *indexPath;
@end

@implementation FWAiteFaceCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWAiteFaceCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWAiteFaceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWAiteFaceCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.checkBtn];
        
        [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.top.bottom.equalTo(self.contentView);
            make.right.equalTo(self.checkBtn.mas_left).offset(-10);
        }];
        
        [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.offset(20);
            make.centerY.equalTo(self.nameLab.mas_centerY);
            make.right.equalTo(self.contentView).offset(-45);
        }];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = Color_MainBg;
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(1);
            make.left.right.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response
- (void)selectClick:(UIButton*)sender
{
//    sender.selected = !sender.selected;
//    if (sender.selected == YES) {
//        [self.checkBtn setImage:Image(@"checkBoxSel") forState:UIControlStateNormal];
//    }else{
//        [self.checkBtn setImage:Image(@"checkBox") forState:UIControlStateNormal];
//    }
    if ([self.delegate respondsToSelector:@selector(FWAiteFaceCellDelegateClick:)]) {
        [self.delegate FWAiteFaceCellDelegateClick:self.indexPath];
    }
}

#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithModel:(FWAiteGroupsListModel*)gmodel fmodel:(FWAiteFacesListModel*)fmodel indexPath:(NSIndexPath *)indexPath
{
    self.indexPath = indexPath;
    if (indexPath.section == 0) {
        self.nameLab.text = [NSString stringWithFormat:@"%@（%@）",gmodel.groupsName,gmodel.faceNum]  ;
        if ([gmodel.faceNum isEqualToString:@"0"]) {
            self.nameLab.textColor = [UIColor colorWithHexString:@"#cccccc"];
        }else{
            self.nameLab.textColor = Color_MainText;
        }
        
        if (gmodel.isSelect) {
            [self.checkBtn setImage:Image(@"checkBoxSel") forState:UIControlStateNormal];
        }else{
            [self.checkBtn setImage:Image(@"checkBox") forState:UIControlStateNormal];
        }
        
    }else{
        self.nameLab.text = fmodel.faceName;
        self.nameLab.textColor = Color_MainText;
        
        if (fmodel.isSelect) {
            [self.checkBtn setImage:Image(@"checkBoxSel") forState:UIControlStateNormal];
        }else{
            [self.checkBtn setImage:Image(@"checkBox") forState:UIControlStateNormal];
        }
    }
}

//- (void)selectCheckBtnWithIndexPath:(NSIndexPath*)indexPath
//{
////    if (self.selectIndexPath) {
////        if (self.selectIndexPath == indexPath) {
////
////        }
////    }
//    self.checkBtn.selected = !self.checkBtn.selected;
//    if (self.checkBtn.selected == YES) {
//        [self.checkBtn setImage:Image(@"checkBoxSel") forState:UIControlStateNormal];
//    }else{
//        [self.checkBtn setImage:Image(@"checkBox") forState:UIControlStateNormal];
//    }
//    self.selectIndexPath = indexPath;
//
//}

#pragma mark - Private Methods


#pragma mark - Setters

- (UILabel*)nameLab
{
    if (_nameLab == nil) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLab.font = systemFont(16);
        _nameLab.textColor = Color_MainText;
    }
    return _nameLab;
}

- (UIButton*)checkBtn
{
    if (_checkBtn == nil) {
        _checkBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_checkBtn setImage:Image(@"checkBox") forState:UIControlStateNormal];
//        _checkBtn.userInteractionEnabled = NO;
        [_checkBtn addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
}

- (NSMutableArray *)faceIdList
{
    if (_faceIdList == nil) {
        _faceIdList = [NSMutableArray array];
        
    }
    return _faceIdList;
}

- (NSMutableArray *)groupIdList
{
    if (_groupIdList == nil) {
        _groupIdList = [NSMutableArray array];
        
    }
    return _groupIdList;
}

#pragma mark - Getters


@end
