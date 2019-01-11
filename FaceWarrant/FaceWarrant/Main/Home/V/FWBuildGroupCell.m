//
//  FWBuildGroupCell.m
//  FaceWarrant
//
//  Created by FW on 2018/9/14.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBuildGroupCell.h"

@interface FWBuildGroupCell ()
@property (strong, nonatomic)UIImageView *itemImg;
@property (strong, nonatomic)UILabel *itemLab;
@end

@implementation FWBuildGroupCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWBuildGroupCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWBuildGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWBuildGroupCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.itemImg];
        [self.contentView addSubview:self.itemLab];
        [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(15);
            make.left.equalTo(self.contentView).offset(25);
            make.centerY.equalTo(self.contentView.mas_centerY);
        }];
        
        [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.offset(15);
            make.left.equalTo(self.itemImg.mas_right).offset(10);
            make.centerY.equalTo(self.contentView.mas_centerY);
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


#pragma mark - Private Methods


#pragma mark - Setters
- (UILabel*)itemLab
{
    if(_itemLab == nil){
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.text = @"新建群组";
        _itemLab.textColor = Color_MainText;
        _itemLab.font = systemFont(14);
    }
    return _itemLab;
}

- (UIImageView*)itemImg
{
    if (_itemImg == nil) {
        _itemImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _itemImg.image = Image(@"warrant_add");
    }
    return _itemImg;
}

#pragma mark - Getters


@end
