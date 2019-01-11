//
//  FWWarrantBrandCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantBrandCell.h"
#import "FWWarrantDetailModel.h"
@interface FWWarrantBrandCell ()
@property (strong ,nonatomic)UIImageView *itemImg;
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UILabel *itemSubLab1;
@property (strong, nonatomic)UILabel *itemSubLab2;
@property (strong, nonatomic)UILabel *itemSubLab3;
@property (strong, nonatomic)UILabel *itemDetailLab1;
@property (strong, nonatomic)UILabel *itemDetailLab2;
@property (strong, nonatomic)UILabel *itemDetailLab3;
@end

@implementation FWWarrantBrandCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWWarrantBrandCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWWarrantBrandCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWWarrantBrandCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self.contentView addSubview:self.itemImg];
//        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.itemSubLab1];
        [self.contentView addSubview:self.itemSubLab2];
        [self.contentView addSubview:self.itemSubLab3];
        [self.contentView addSubview:self.itemDetailLab1];
        [self.contentView addSubview:self.itemDetailLab2];
        [self.contentView addSubview:self.itemDetailLab3];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
//    [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.offset(20);
//        make.left.top.equalTo(self.contentView).offset(10);
//    }];
//
//    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(20);
//        make.top.equalTo(self.contentView).offset(10);
//        make.left.equalTo(self.self.itemImg.mas_right).offset(5);
//        make.right.equalTo(self.contentView).offset(-10);
//    }];
    
    [self.itemSubLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.itemDetailLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.width.offset(200);
        make.left.equalTo(self.itemSubLab1.mas_right).offset(10);
        make.centerY.equalTo(self.itemSubLab1.mas_centerY);
    }];
    
    [self.itemSubLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.itemSubLab1.mas_bottom).offset(5);
    }];
    
    [self.itemDetailLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.itemSubLab2.mas_right).offset(10);
        make.width.offset(200);
        make.centerY.equalTo(self.itemSubLab2.mas_centerY);
    }];
    
    [self.itemSubLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.itemSubLab2.mas_bottom).offset(5);
    }];
    
    [self.itemDetailLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.itemSubLab3.mas_right).offset(10);
        make.width.offset(200);
        make.centerY.equalTo(self.itemSubLab3.mas_centerY);
    }];
}

#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response


#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 85;
}


- (void)configCellWithModel:(FWWarrantDetailModel*)model
{
    self.itemDetailLab1.text = model.brandName;
    self.itemDetailLab2.text = [NSString stringWithFormat:@"%@ %@",model.goodsBtype , model.goodsStype];
    self.itemDetailLab3.text = model.goodsName;
}

#pragma mark - Private Methods


#pragma mark - Setters
- (UIImageView*)itemImg
{
    if (_itemImg == nil) {
        _itemImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _itemImg.image = [UIImage imageNamed:@"xin"];
    }
    return _itemImg;
}

- (UILabel *)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.text = @"";
        _itemLab.font = systemFont(14);
        _itemLab.textColor = [UIColor blueColor];
    }
    return _itemLab;
}

- (UILabel *)itemSubLab1
{
    if (_itemSubLab1 == nil) {
        _itemSubLab1 = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemSubLab1.text = @"品牌";
        _itemSubLab1.font = systemFont(14);
        _itemSubLab1.textColor = Color_MainText;
    }
    return _itemSubLab1;
}

- (UILabel *)itemSubLab2
{
    if (_itemSubLab2 == nil) {
        _itemSubLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemSubLab2.text = @"品类";
        _itemSubLab2.font = systemFont(14);
        _itemSubLab2.textColor = Color_MainText;
    }
    return _itemSubLab2;
}

- (UILabel *)itemSubLab3
{
    if (_itemSubLab3 == nil) {
        _itemSubLab3 = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemSubLab3.text = @"用品";
        _itemSubLab3.font = systemFont(14);
        _itemSubLab3.textColor = Color_MainText;
    }
    return _itemSubLab3;
}

- (UILabel *)itemDetailLab1
{
    if (_itemDetailLab1 == nil) {
        _itemDetailLab1 = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemDetailLab1.font = systemFont(14);
        _itemDetailLab1.textColor = Color_SubText;
    }
    return _itemDetailLab1;
}

- (UILabel *)itemDetailLab2
{
    if (_itemDetailLab2 == nil) {
        _itemDetailLab2 = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemDetailLab2.font = systemFont(14);
        _itemDetailLab2.textColor = Color_SubText;
    }
    return _itemDetailLab2;
}

- (UILabel *)itemDetailLab3
{
    if (_itemDetailLab3 == nil) {
        _itemDetailLab3 = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemDetailLab3.font = systemFont(14);
        _itemDetailLab3.textColor = Color_SubText;
    }
    return _itemDetailLab3;
}

#pragma mark - Getters


@end
