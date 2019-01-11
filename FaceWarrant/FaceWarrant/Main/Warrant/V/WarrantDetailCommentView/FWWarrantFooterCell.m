//
//  FWWarrantFooterCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/19.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantFooterCell.h"

@interface FWWarrantFooterCell ()
@property (strong, nonatomic)UILabel *commentMoreLab;
@end

@implementation FWWarrantFooterCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWWarrantFooterCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWWarrantFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWWarrantFooterCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.commentMoreLab];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    [self.commentMoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
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
- (UILabel *)commentMoreLab
{
    if (!_commentMoreLab) {
        _commentMoreLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentMoreLab.text = @"查看所有评论 >>";
        _commentMoreLab.textAlignment = NSTextAlignmentCenter;
        _commentMoreLab.textColor = Color_SubText;
        _commentMoreLab.font = systemFont(14);
    }
    return _commentMoreLab;
}


#pragma mark - Getters


@end
