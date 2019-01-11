//
//  FWIntegralCell.m
//  FaceWarrant
//
//  Created by LHKH on 2018/7/2.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWIntegralCell.h"
#import "FWIntegralModel.h"
@interface FWIntegralCell ()
@property (strong, nonatomic) UILabel *itemLab;
@property (strong, nonatomic) UILabel *integralLab;
@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) FWPointsDetailListModel *model;
@end

@implementation FWIntegralCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWIntegralCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWIntegralCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWIntegralCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.integralLab];
        [self.contentView addSubview:self.timeLab];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutCustomViews
{
    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.itemLab.mas_bottom).offset(10);
    }];
    
    [self.integralLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = Color_MainBg;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(5);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}


#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response




#pragma mark - Network requests




#pragma mark - Public Methods


+ (CGFloat)cellHeight
{
    return 75;
}

- (void)configCellWithModel:(FWPointsDetailListModel*)model indexPath:(NSIndexPath*)indexPath
{
    self.model = model;
    if ([model.operateType isEqualToString:@"1"]  && [model.useType isEqualToString:@"0"]) {
        self.itemLab.text = @"签到成功";
        self.integralLab.text = StringConnect(@"+", model.points);
        self.integralLab.textColor = [UIColor colorWithHexString:@"#1AD016"];
    }else if ([model.operateType isEqualToString:@"1"]  && [model.useType isEqualToString:@"2"]){
        self.itemLab.text = @"注册成功";
        self.integralLab.text = StringConnect(@"+", model.points);
        self.integralLab.textColor = [UIColor colorWithHexString:@"#1AD016"];
    } else{
        self.itemLab.text = @"兑换脸值";
        self.integralLab.text = StringConnect(@"-", model.points);
        self.integralLab.textColor = [UIColor colorWithHexString:@"#FF2020"];
    }
    self.timeLab.text = model.createTime;
}

#pragma mark - Private Methods




#pragma mark - Setters

- (UILabel*)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.textColor = Color_MainText;
        _itemLab.font = systemFont(18);
    }
    return _itemLab;
}

- (UILabel*)integralLab
{
    if (_integralLab == nil) {
        _integralLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _integralLab.font = systemFont(20);
        _itemLab.textColor = Color_MainText;
        _integralLab.textAlignment = NSTextAlignmentRight;
    }
    return _integralLab;
}

- (UILabel*)timeLab
{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLab.font = systemFont(12);
        _timeLab.textColor = Color_SubText;
    }
    return _timeLab;
}


#pragma mark - Getters



@end
