//
//  FWMFaceCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMFaceCell.h"
#import "FWMessageAModel.h"
@interface FWMFaceCell ()
@property (strong, nonatomic)UIImageView *itemImg;
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UIView *bgView;
@end

@implementation FWMFaceCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMFaceCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMFaceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWMFaceCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.bgView];
        [self.contentView addSubview:self.itemImg];
        [self.contentView addSubview:self.itemLab];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutCustomViews
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(60);
        make.left.equalTo(self.contentView).offset(55);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView);
    }];
    
    [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(60);
        make.right.top.bottom.equalTo(self.bgView);
    }];
    
    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(10);
        make.right.equalTo(self.itemImg.mas_left).offset(-10);
        make.top.bottom.equalTo(self.bgView);
    }];
}


#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response




#pragma mark - Network requests




#pragma mark - Public Methods

+ (CGFloat)cellHeight
{
    return 70;
}

- (void)configCellWithModel:(FWMessageAModel*)model indexPath:(NSIndexPath*)indexPath typeStr:(NSString*)typeStr
{
    [self.itemImg sd_setImageWithURL:URL(model.modelUrl) placeholderImage:Image_placeHolder80];
    self.itemLab.text = model.commentContent;
}


#pragma mark - Private Methods




#pragma mark - Setters

- (UIView *)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = Color_MainBg;
    }
    return _bgView;
}

- (UIImageView *)itemImg
{
    if (_itemImg == nil) {
        _itemImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _itemImg.image = [UIImage imageNamed:@"3"];
    }
    return _itemImg;
}

- (UILabel*)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.text = @"如果你无法简介的表达你的想法，那只说明你还不够了解它";
        _itemLab.numberOfLines = 0;
        _itemLab.font = systemFont(14);
        _itemLab.textColor = Color_SubText;
    }
    return _itemLab;
}

#pragma mark - Getters



@end
