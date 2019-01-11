//
//  FWEditFacesCell.m
//  FaceWarrant
//
//  Created by FW on 2018/8/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWEditFacesCell.h"
#import "FWAttentionModel.h"
@interface FWEditFacesCell ()
@property (strong, nonatomic)UILabel *nameLab;
@property (strong, nonatomic)UIButton *checkBtn;
@property (strong, nonatomic)NSIndexPath *indexPath;
@end

@implementation FWEditFacesCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWEditFacesCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWEditFacesCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWEditFacesCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
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
    if ([self.delegate respondsToSelector:@selector(FWEditFacesCellDelegateClick:)]) {
        [self.delegate FWEditFacesCellDelegateClick:self.indexPath];
    }
}


#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithModel:(FWAttentionModel*)model indexPath:(NSIndexPath*)indexPath
{
    self.indexPath = indexPath;
    self.nameLab.text = model.faceName;
    if (model.isSelect == YES) {
        [self.checkBtn setImage:Image(@"checkBoxSel") forState:UIControlStateNormal];
    }else{
        [self.checkBtn setImage:Image(@"checkBox") forState:UIControlStateNormal];
    }
}

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

#pragma mark - Getters


@end
