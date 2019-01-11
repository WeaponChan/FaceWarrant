//
//  FWHashCell.m
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWHashCell.h"

@interface FWHashCell ()
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UIImageView *itemImg;
@end

@implementation FWHashCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWHashCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWHashCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWHashCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.itemImg];
        
        [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(10);
            make.height.offset(20);
            make.centerY.equalTo(self.contentView.mas_centerY);
            
        }];
        
        [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.itemLab.mas_right).offset(10);
            make.width.offset(12);
            make.height.offset(15);
            make.centerY.equalTo(self.contentView.mas_centerY);
            
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
- (void)configCellWithitem:(NSString*)itemStr isSearch:(BOOL)isSearch indexPath:(NSIndexPath*)indexPath
{
    self.itemLab.text = itemStr;
    if (indexPath.row == 0 && isSearch == NO) {
        self.itemImg.hidden = NO;
    }else{
        self.itemImg.hidden = YES;
    }
}

#pragma mark - Private Methods


#pragma mark - Setters

- (UILabel*)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.font = systemFont(16);
        _itemLab.textColor = Color_Black;
    }
    return _itemLab;
}

- (UIImageView *)itemImg
{
    if (_itemImg == nil) {
        _itemImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _itemImg.image = Image(@"facelibrary_hot");
    }
    return _itemImg;
}

#pragma mark - Getters


@end
