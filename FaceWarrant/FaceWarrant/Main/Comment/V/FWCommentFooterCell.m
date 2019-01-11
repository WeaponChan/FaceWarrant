//
//  FWCommentFooterCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/20.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWCommentFooterCell.h"
#import "UIButton+Lhkh.h"
#import "FWCommentModel.h"
@interface FWCommentFooterCell ()
{
    NSString *_commentId;
    NSString *_commentFromUserId;
}
@property (strong, nonatomic)UIButton *commentMoreBtn;
@property (strong, nonatomic)NSIndexPath *indexPath;
@end

@implementation FWCommentFooterCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWCommentFooterCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWCommentFooterCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWCommentFooterCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.commentMoreBtn];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    [self.commentMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.left.bottom.equalTo(self.contentView);
    }];
    
    
}


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (void)spreadClick
{
    if ([self.delegate respondsToSelector:@selector(FWCommentFooterCellDelegateClick:)]) {
        [self.delegate FWCommentFooterCellDelegateClick:_commentId];
    }
}

#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithNum:(FWCommendReplyModel*)model indexPath:(NSIndexPath*)indexPath
{
    _commentId = model.commentId;
    _commentFromUserId = model.commentFromUserId;
    if (model.isSpread) {
        [_commentMoreBtn setTitle:@"收起" forState:UIControlStateNormal];
        [_commentMoreBtn setImage:nil forState:UIControlStateNormal];
    }else{
        [_commentMoreBtn setTitle:[NSString stringWithFormat:@"查看全部%@条回复",model.replyCount] forState:UIControlStateNormal];
        [self.commentMoreBtn changeImageAndTitle];
    }
    
}

#pragma mark - Private Methods


#pragma mark - Setters

- (UIButton *)commentMoreBtn
{
    if (!_commentMoreBtn) {
        _commentMoreBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_commentMoreBtn setTitle:@"" forState:UIControlStateNormal];
        [_commentMoreBtn setImage:[UIImage imageNamed:@"comment_xia_blue"] forState:UIControlStateNormal];
        [_commentMoreBtn setTitleColor:[UIColor colorWithHexString:@"#3D84FA"] forState:UIControlStateNormal];
        [_commentMoreBtn addTarget:self action:@selector(spreadClick) forControlEvents:UIControlEventTouchUpInside];
        _commentMoreBtn.titleLabel.font = systemFont(12);
    }
    return _commentMoreBtn;
}

#pragma mark - Getters


@end
