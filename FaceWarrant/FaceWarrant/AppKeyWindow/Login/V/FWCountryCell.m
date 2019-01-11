//
//  FWCountryCell.m
//  FaceWarrant
//
//  Created by FW on 2018/8/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWCountryCell.h"
#import "FWCountryModel.h"
@interface FWCountryCell ()
@property (strong, nonatomic)UILabel *itemLab;
@end

@implementation FWCountryCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWCountryCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWCountryCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWCountryCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.itemLab];
        [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
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


#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithModel:(FWCountryListModel*)model indexPath:(NSIndexPath*)indexPath
{
    self.itemLab.text = model.name;
}

#pragma mark - Private Methods


#pragma mark - Setters
- (UILabel*)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.font = systemFont(16);
        _itemLab.textColor = Color_MainText;
    }
    return _itemLab;
}

#pragma mark - Getters


@end
