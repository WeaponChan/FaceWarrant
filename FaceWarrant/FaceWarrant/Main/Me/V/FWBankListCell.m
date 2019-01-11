//
//  FWBankListCell.m
//  FaceWarrant
//
//  Created by FW on 2018/8/22.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBankListCell.h"
#import "FWBankModel.h"
@interface FWBankListCell ()
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UILabel *itemSubLab;
@property (strong, nonatomic)UIImageView *itemImg;
@end

@implementation FWBankListCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWBankListCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWBankListCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWBankListCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self.contentView addSubview:self.itemLab];
//        [self.contentView addSubview:self.itemSubLab];
        [self.contentView addSubview:self.itemImg];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(24);
        make.width.offset(120);
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
//    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.itemImg.mas_right).offset(15);
//        make.centerY.equalTo(self.itemImg.mas_centerY);
//        make.height.offset(20);
//    }];
    
//    [self.itemSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.itemLab.mas_left);
//        make.bottom.equalTo(self.itemImg.mas_bottom);
//        make.height.offset(15);
//    }];
}

#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response


#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 60;
}

- (void)configCellWithData:(FWBankModel*)model indexPath:(NSIndexPath*)indexPath
{
    [self.itemImg sd_setImageWithURL:URL(model.value) placeholderImage:nil];
//    self.itemLab.text = model.name;
}

#pragma mark - Private Methods


#pragma mark - Setters

- (UILabel*)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.font = systemFont(18);
        _itemLab.textColor = Color_MainText;
    }
    return _itemLab;
}

- (UILabel*)itemSubLab
{
    if (_itemSubLab == nil) {
        _itemSubLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemSubLab.font = systemFont(14);
        _itemSubLab.textColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _itemSubLab;
}

- (UIImageView*)itemImg
{
    if (_itemImg == nil) {
        _itemImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _itemImg;
}


#pragma mark - Getters


@end
