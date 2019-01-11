//
//  FWWarrantSubFooterCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/19.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantSubFooterCell.h"

@interface FWWarrantSubFooterCell ()
@property (strong, nonatomic)UILabel *commentSubMoreLab;
@end

@implementation FWWarrantSubFooterCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWWarrantSubFooterCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWWarrantSubFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWWarrantSubFooterCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.commentSubMoreLab];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    [self.commentSubMoreLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-10);
    }];
}

#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response


#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 30;
}

- (void)configCellWithNum:(NSString*)num
{
    self.commentSubMoreLab.text = [NSString stringWithFormat:@"共%@条回复 >",num];
}

#pragma mark - Private Methods


#pragma mark - Setters
- (UILabel *)commentSubMoreLab
{
    if (!_commentSubMoreLab) {
        _commentSubMoreLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _commentSubMoreLab.text = @"共999条回复 >";
        _commentSubMoreLab.textAlignment = NSTextAlignmentRight;
        _commentSubMoreLab.textColor = [UIColor colorWithHexString:@"3D84FA"];
        _commentSubMoreLab.font = systemFont(12);
    }
    return _commentSubMoreLab;
}

#pragma mark - Getters


@end
