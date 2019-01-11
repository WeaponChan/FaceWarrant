//
//  FWMeQuestionCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMeQuestionCell.h"
#import "FWMeQuestionModel.h"
@interface FWMeQuestionCell ()
@property(strong, nonatomic)UILabel *qLab;
@property(strong, nonatomic)UILabel *aLab;
@property(strong, nonatomic)UILabel *timeLab;
@end

@implementation FWMeQuestionCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMeQuestionCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMeQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWMeQuestionCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.qLab];
        [self.contentView addSubview:self.aLab];
        [self.contentView addSubview:self.timeLab];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    [self.qLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(self.qLab.mas_bottom).offset(10);
        make.bottom.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.aLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(self.qLab.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    
}

#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response


#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithModel:(FWMeQuestionModel*)model indexPath:(NSIndexPath*)indexPath
{
    self.qLab.text = model.questionContent;
    
    self.timeLab.text = model.createTime;
    self.aLab.text = StringConnect(model.answerCount, @"个回答");
}

#pragma mark - Private Methods


#pragma mark - Setters

- (UILabel*)qLab
{
    if (_qLab == nil) {
        _qLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _qLab.textColor = Color_MainText;
        _qLab.numberOfLines = 0;
        _qLab.font = systemFont(14);
    }
    return _qLab;
}

- (UILabel*)aLab
{
    if (_aLab == nil) {
        _aLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _aLab.textColor = Color_SubText;
        _aLab.font = systemFont(12);
    }
    return _aLab;
}

- (UILabel*)timeLab
{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLab.textColor = Color_SubText;
        _timeLab.font = systemFont(12);
    }
    return _timeLab;
}

#pragma mark - Getters


@end
