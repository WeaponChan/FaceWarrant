//
//  FWModifyHeaderCell.m
//  FaceWarrant
//
//  Created by FW on 2018/9/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWModifyHeaderCell.h"

@interface FWModifyHeaderCell ()
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UIImageView *headerImg;
@property (strong, nonatomic)UIImageView *youImg;
@end

@implementation FWModifyHeaderCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWModifyHeaderCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWModifyHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWModifyHeaderCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.headerImg];
        [self.contentView addSubview:self.youImg];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.bottom.equalTo(self.contentView);
        make.width.offset(120);
    }];
    
    [self.youImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(8);
        make.height.offset(14);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.youImg.mas_left).offset(-10);
        make.centerY.equalTo(self.contentView);
        make.height.width.offset(40);
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = Color_MainBg;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
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
    return 60;
}

- (void)configCellWithheaderUrl:(NSString*)url
{
    [self.headerImg sd_setImageWithURL:URL(url) placeholderImage:Image_placeHolder80];
}

#pragma mark - Private Methods


#pragma mark - Setters
- (UILabel*)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.text = @"头像";
        _itemLab.textColor = Color_MainText;
        _itemLab.font = systemFont(14);
    }
    return _itemLab;
}

- (UIImageView*)headerImg
{
    if (_headerImg == nil) {
        _headerImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headerImg.contentMode = UIViewContentModeScaleAspectFill;
        _headerImg.layer.cornerRadius = 20.f;
        _headerImg.layer.masksToBounds = YES;
    }
    return _headerImg;
}

- (UIImageView*)youImg
{
    if (_youImg == nil) {
        _youImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _youImg.image = [UIImage imageNamed:@"you"];
    }
    return _youImg;
}

#pragma mark - Getters


@end
