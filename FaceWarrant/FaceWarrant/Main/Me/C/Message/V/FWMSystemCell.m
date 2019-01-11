//
//  FWMSystemCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMSystemCell.h"

@interface FWMSystemCell ()
@property (nonatomic, strong) UIImageView *itemImg;
@property (nonatomic, strong) UILabel *itemLab;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UILabel *timeLab;
@end
@implementation FWMSystemCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMSystemCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMSystemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWMSystemCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.itemImg];
        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.descLab];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutCustomViews
{
    
    [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(35);
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.itemImg.mas_right).offset(10);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.itemLab.mas_centerY);
    }];
    
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.itemLab.mas_left);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.itemLab.mas_bottom).offset(5);
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


#pragma mark - Private Methods




#pragma mark - Setters

- (UIImageView*)itemImg
{
    if (_itemImg == nil) {
        _itemImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _itemImg;
}

- (UILabel*)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.text = @"平台消息";
        _itemLab.textColor = Color_MainText;
        _itemLab.font = systemFont(14);
    }
    return _itemLab;
}

- (UILabel*)descLab
{
    if (_descLab == nil) {
        _descLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLab.text = @"猪妈妈的心肝宝贝";
        _descLab.textColor = Color_SubText;
        _descLab.font = systemFont(12);
    }
    return _descLab;
}

- (UILabel*)timeLab
{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLab.text = @"06-29";
        _timeLab.textColor = Color_SubText;
        _timeLab.font = systemFont(12);
    }
    return _timeLab;
}

#pragma mark - Getters



@end
