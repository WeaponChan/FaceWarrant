//
//  FWWarrantSubCommentCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/19.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWCommentSubCell.h"
#import "UILabel+LhkhAttributeTextTapAction.h"
#import "FWCommentManager.h"
#import "FWCommentModel.h"
#import "FWPersonalHomePageVC.h"
@interface FWCommentSubCell ()<LhkhAttributeTextTapActionDelegate>
{
    NSString *_islike;
}
@property (strong, nonatomic) UILabel *replyLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *zanBtn;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) FWCommendReplyModel *model;
@property (nonatomic, strong) FWReplyModel *rmodel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation FWCommentSubCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWCommentSubCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWCommentSubCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWCommentSubCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.replyLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.zanBtn];
        [self.contentView addSubview:self.delBtn];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
-  (void)layoutCustomViews
{
    [self.replyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.replyLab.mas_left);
        make.top.equalTo(self.replyLab.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView);
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLab.mas_right).offset(10);
        make.centerY.equalTo(self.timeLab.mas_centerY);
    }];
    
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.commentBtn.mas_right).offset(20);
        make.centerY.equalTo(self.timeLab.mas_centerY);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.zanBtn.mas_left).offset(-20);
        make.centerY.equalTo(self.timeLab.mas_centerY);
    }];
}

#pragma mark - System Delegate


#pragma mark - Custom Delegate

#pragma mark - LhkhAttributeTextTapActionDelegate
- (void)lhkh_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    DLog(@"----->%@----%ld",string,index);
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.indexPath = self.indexPath;
    if (index == 0) {
        vc.faceId = self.rmodel.replyFromUserId;
    }else{
        vc.faceId = self.rmodel.replyToUserId;
    }
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}

#pragma mark - Event Response
- (void)commentClick
{
    if ([self.delegate respondsToSelector:@selector(FWCommentSubCellDelegateCommentClick:indexPath:)]) {
        [self.delegate FWCommentSubCellDelegateCommentClick:self.rmodel indexPath:self.indexPath];
    }
}

- (void)zanClick
{
   NSDictionary *param = @{
              @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
              @"isLike":self.rmodel.isLike,
              @"type":@"3",
              @"relatedId":self.rmodel.replyId,
              @"toUserId":self.rmodel.replyFromUserId
              };
    [self actionliked:param];
}

- (void)delClick
{
    if ( [self.delegate respondsToSelector:@selector(FWCommentSubCellDelegateCommentDeleteClick:indexPath:)]) {
        [self.delegate FWCommentSubCellDelegateCommentDeleteClick:self.rmodel indexPath:self.indexPath];
    }
}

#pragma mark - Network requests

- (void)actionliked:(NSDictionary*)param
{
    [FWCommentManager actionCommentLikedWithParameter:param result:^(id response) {
        NSInteger zan = self.zanBtn.titleLabel.text.integerValue;
        if ([self.rmodel.isLike isEqualToString:@"0"]) {
            [self.zanBtn setImage:Image(@"warrant_zanSel") forState:UIControlStateNormal];
            zan = zan+1;
            self.rmodel.isLike = @"1";
            
        }else{
            [self.zanBtn setImage:Image(@"warrant_zan") forState:UIControlStateNormal];
            zan = zan-1;
            self.rmodel.isLike = @"0";
        }
        [self.zanBtn setTitle:[NSString stringWithFormat:@"%ld",zan] forState:UIControlStateNormal];
    }];
}


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithCommentModel:(FWCommendReplyModel*)model replyModel:(FWReplyModel*)rmodel indexPath:(NSIndexPath*)indexPath
{
    self.model = model;
    self.rmodel = rmodel;
    self.indexPath = indexPath;
    if ([rmodel.replyType isEqualToString:@"2"]) {
        [self configCellWithReply:rmodel.replyContent userC:rmodel.replyToUser userR:rmodel.replyFromUser replyCount:rmodel.replyCount replylikeCount:rmodel.replyLikeCount replyTime:rmodel.replyTime userId:rmodel.replyFromUserId indexPath:indexPath];
    }else{
        [self configCellWithReply:rmodel.replyContent userC:rmodel.replyFromUser userR:@"" replyCount:rmodel.replyCount replylikeCount:rmodel.replyLikeCount replyTime:rmodel.replyTime userId:rmodel.replyFromUserId indexPath:indexPath];
    }
}

/**
 渲染回复内容  使能点击用户的昵称跳转个人中心
 
 @param reply 回复的内容
 @param userC 评论作者的人 或者作者
 @param userR 回复评论者的人
 @param indexPath 当前的index
 */
- (void)configCellWithReply:(NSString*)reply userC:(NSString*)userC userR:(NSString*)userR replyCount:(NSString*)replyCount replylikeCount:(NSString*)replylikeCount replyTime:(NSString*)replyTime userId:(NSString*)userId indexPath:(NSIndexPath*)indexPath;
{
    NSString *replyStr = nil;
    if (userR.length>0 && userR != nil && ![userR isEqualToString:@""]) {
        replyStr = [NSString stringWithFormat:@"%@ 回复 %@：%@",userR,userC,reply];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:replyStr];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, userR.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:Color_SubText range:NSMakeRange(0, userR.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:Color_SubText range:NSMakeRange(userR.length+4, userC.length+1)];
        //最好设置一下行高，不设的话默认是0
        NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc] init];
        sty.alignment = NSTextAlignmentLeft;
        sty.lineSpacing = 2;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:sty range:NSMakeRange(0, replyStr.length)];
        
        self.replyLab.attributedText = attributedString;
        [self.replyLab lhkh_addAttributeTapActionWithStrings:@[userR,userC] delegate:self];
    }else if (userC.length>0 && userC != nil && ![userC isEqualToString:@""]){
        
        replyStr = [NSString stringWithFormat:@"%@：%@",userC,reply];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:replyStr];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, userC.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:Color_SubText range:NSMakeRange(0, userC.length+1)];
        //最好设置一下行高，不设的话默认是0
        NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc] init];
        sty.alignment = NSTextAlignmentLeft;
        sty.lineSpacing = 2;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:sty range:NSMakeRange(0, replyStr.length)];
        
        self.replyLab.attributedText = attributedString;
        [self.replyLab lhkh_addAttributeTapActionWithStrings:@[userC] delegate:self];
    }
    
    if ([self.rmodel.isLike isEqualToString:@"1"]) {
        [self.zanBtn setImage:Image(@"warrant_zanSel") forState:UIControlStateNormal];
    }else{
        [self.zanBtn setImage:Image(@"warrant_zan") forState:UIControlStateNormal];
    }
    
    if ([userId isEqualToString:[USER_DEFAULTS objectForKey:UD_UserID]]) {
        self.delBtn.hidden = NO;
    }else{
        self.delBtn.hidden = YES;
    }
    self.timeLab.text = replyTime;
    [self.commentBtn setTitle:replyCount forState:UIControlStateNormal];
    [self.zanBtn setTitle:replylikeCount forState:UIControlStateNormal];
}

#pragma mark - Private Methods

- (float)stringHeightWithString:(NSString *)string size:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
    
    float height = [string boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return ceilf(height+30);
}


#pragma mark 获取当前View所在的ViewController
- (UIViewController *)superViewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}

#pragma mark - Setters
- (UILabel *)replyLab
{
    if (!_replyLab) {
        _replyLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _replyLab.textColor = Color_Black;
        _replyLab.font = systemFont(12);
        _replyLab.numberOfLines = 0;
        _replyLab.backgroundColor = [UIColor clearColor];
    }
    return _replyLab;
}

- (UILabel *)timeLab
{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLab.font = systemFont(12);
        _timeLab.textColor = Color_SubText;
    }
    return _timeLab;
}

- (UIButton *)commentBtn
{
    if (!_commentBtn) {
        
        _commentBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_commentBtn setImage:[UIImage imageNamed:@"warrant_commendSmall"] forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = systemFont(12);
        [_commentBtn setTitleColor:Color_SubText forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentClick) forControlEvents:(UIControlEventTouchUpInside)];
        _commentBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    }
    return _commentBtn;
}

- (UIButton *)zanBtn
{
    if (!_zanBtn) {
        
        _zanBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_zanBtn setImage:[UIImage imageNamed:@"warrant_zan"] forState:UIControlStateNormal];
        _zanBtn.titleLabel.font = systemFont(12);
        [_zanBtn setTitleColor:Color_SubText forState:UIControlStateNormal];
        [_zanBtn addTarget:self action:@selector(zanClick) forControlEvents:(UIControlEventTouchUpInside)];
        _zanBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    }
    return _zanBtn;
}

- (UIButton *)delBtn
{
    if (!_delBtn) {
        _delBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
        _delBtn.titleLabel.font = systemFont(12);
        [_delBtn setTitleColor:Color_SubText forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(delClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _delBtn;
}

#pragma mark - Getters


@end
