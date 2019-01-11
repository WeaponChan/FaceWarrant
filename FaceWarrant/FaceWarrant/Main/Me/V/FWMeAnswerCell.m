//
//  FWMeAnswerCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMeAnswerCell.h"
#import "LhkhLabel.h"
#import "FWMeAnswerModel.h"
@interface FWMeAnswerCell ()
@property (nonatomic, strong) UIImageView *itemImg;
@property (nonatomic, strong) UIImageView *youImg;
@property (nonatomic, strong) UILabel *answerLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) LhkhLabel *questionLab;
@end

@implementation FWMeAnswerCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMeAnswerCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMeAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWMeAnswerCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        [self.contentView addSubview:self.answerLab];
//        [self.contentView addSubview:self.youImg];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.questionLab];
        [self layoutCustomViews];
        
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutCustomViews
{
    
//    [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.offset(40);
//        make.top.left.equalTo(self.contentView).offset(10);
//    }];
    
    [self.answerLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(self.answerLab.mas_bottom).offset(5);
        make.left.equalTo(self.answerLab.mas_left);
    }];
    
//    [self.youImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.offset(15);
//        make.right.equalTo(self.contentView).offset(-10);
//        make.centerY.equalTo(self.questionLab.mas_centerY);
//    }];
    
    [self.questionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.answerLab.mas_left);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.timeLab.mas_bottom).offset(10);
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

- (void)configCellWithModel:(FWMeAnswerModel*)model indexPath:(NSIndexPath*)indexPath
{
    self.questionLab.text = model.questionContent;
    self.answerLab.text = model.answerContent;
    self.timeLab.text = model.answerTime;
}
#pragma mark - Private Methods


#pragma mark - Setters

- (UIImageView*)itemImg
{
    if (_itemImg == nil) {
        _itemImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _itemImg;
}

- (UIImageView*)youImg
{
    if (_youImg == nil) {
        _youImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _youImg.image = [UIImage imageNamed:@"you"];
    }
    return _youImg;
}

- (UILabel *)answerLab
{
    if (_answerLab == nil) {
        _answerLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _answerLab.textColor = Color_MainText;
        _answerLab.font = systemFont(14);
        _answerLab.numberOfLines = 0;
    }
    return _answerLab;
}

- (UILabel *)timeLab
{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLab.textColor = Color_SubText;
        _timeLab.font = systemFont(12);
        
    }
    return _timeLab;
}

- (LhkhLabel *)questionLab
{
    if (_questionLab == nil) {
        _questionLab = [[LhkhLabel alloc] initWithFrame:CGRectZero];
        _questionLab.layer.cornerRadius = 4.f;
        _questionLab.layer.masksToBounds = YES;
        _questionLab.textColor = Color_Black;
        _questionLab.backgroundColor = Color_MainBg;
        _questionLab.font = systemFont(12);
        _questionLab.numberOfLines = 0;
        _questionLab.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _questionLab;
}


#pragma mark - Getters


@end
