//
//  FWWarrantUseExpeCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantUseExpeCell.h"
#import "FWWarrantDetailModel.h"
@interface FWWarrantUseExpeCell ()
@property (strong ,nonatomic)UIImageView *itemImg;
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UILabel *itemSubLab;
@end

@implementation FWWarrantUseExpeCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWWarrantUseExpeCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWWarrantUseExpeCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWWarrantUseExpeCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView  mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        [self.contentView addSubview:self.itemImg];
        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.itemSubLab];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.left.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.self.itemImg.mas_right).offset(5);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.itemSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.itemLab.mas_bottom).offset(10);
        make.bottom.right.equalTo(self.contentView).offset(-10);
    }];
}

#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response


#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return UITableViewAutomaticDimension;
}

- (void)configCellWithModel:(FWWarrantDetailModel*)model
{
    self.itemSubLab.text = model.useDetail;
//    if (self.itemSubLab.text.length>0) {
//        [UILabel changeSpaceForLabel:self.itemSubLab withLineSpace:5 WordSpace:0];
//    }
}

#pragma mark - Private Methods


#pragma mark - Setters
- (UIImageView*)itemImg
{
    if (_itemImg == nil) {
        _itemImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _itemImg.image = [UIImage imageNamed:@"warrant_tihui"];
    }
    return _itemImg;
}

- (UILabel *)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.text = @"使用体会";
        _itemLab.font = systemFont(15);
        _itemLab.textColor = Color_Black;
    }
    return _itemLab;
}

- (UILabel *)itemSubLab
{
    if (_itemSubLab == nil) {
        _itemSubLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemSubLab.text = @"";
        _itemSubLab.font = systemFont(14);
        _itemSubLab.textColor = Color_Black;
        _itemSubLab.numberOfLines = 0;
    }
    return _itemSubLab;
}
#pragma mark - Getters


@end
