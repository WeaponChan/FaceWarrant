//
//  FWWarrantHeaderCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/19.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantHeaderCell.h"

@interface FWWarrantHeaderCell ()
@property (strong, nonatomic)UILabel *commentTotalLab;
@end

@implementation FWWarrantHeaderCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWWarrantHeaderCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWWarrantHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWWarrantHeaderCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.commentTotalLab];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    [self.commentTotalLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.top.bottom.right.equalTo(self.contentView);
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
    return 44;
}

- (void)configCellWithNum:(NSString *)num
{
    NSString *numStr = [NSString stringWithFormat:@"(%@)",num];
    self.commentTotalLab.text = StringConnect(@"评论", numStr);
}

#pragma mark - Private Methods


#pragma mark - Setters
- (UILabel *)commentTotalLab
{
    if (!_commentTotalLab) {
        _commentTotalLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentTotalLab.text = @"评论(999999)";
        _commentTotalLab.textColor = Color_SubText;
        _commentTotalLab.font = systemFont(14);
    }
    return _commentTotalLab;
}

#pragma mark - Getters


@end
