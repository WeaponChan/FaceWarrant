//
//  FWAllReplyCell.m
//  FaceWarrant
//
//  Created by FW on 2018/10/9.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWAllReplyCell.h"
#import "FWCommentModel.h"
#import "FWCommentManager.h"
#import "FWPersonalHomePageVC.h"
#import "UILabel+LhkhAttributeTextTapAction.h"
@interface FWAllReplyCell ()<LhkhAttributeTextTapActionDelegate>

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIButton *headImageViewbtn;
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UIButton *replyBtn;
@property (nonatomic, strong) UIButton *zanBtn;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) FWCommendReplyModel *model;
@property (nonatomic, strong) FWReplyModel *rmodel;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation FWAllReplyCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWAllReplyCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWAllReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWAllReplyCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = Color_White;
        self.backgroundColor = Color_White;
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.headImageView];
        [self.bgView addSubview:self.headImageViewbtn];
        [self.bgView addSubview:self.nameLab];
        [self.bgView addSubview:self.timeLab];
        [self.bgView addSubview:self.delBtn];
        [self.bgView addSubview:self.replyBtn];
        [self.bgView addSubview:self.zanBtn];
        [self.bgView addSubview:self.contentLab];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutCustomViews
{
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.contentView);
    }];
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(30);
        make.top.equalTo(self.bgView).offset(15);
        make.left.equalTo(self.bgView).offset(10);
    }];
    
    [self.headImageViewbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.headImageView);
    }];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.headImageView.mas_right).offset(5);
        make.top.equalTo(self.headImageView.mas_top);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLab.mas_left);
        make.right.equalTo(self.bgView).offset(-10);
        make.top.equalTo(self.headImageView.mas_bottom).offset(-5);
        make.bottom.equalTo(self.timeLab.mas_top).offset(-10);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.nameLab.mas_left);
        make.top.equalTo(self.contentLab.mas_bottom).offset(10);
        make.bottom.equalTo(self.bgView).offset(-10);
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLab.mas_right).offset(10);
        make.centerY.equalTo(self.timeLab.mas_centerY);
    }];
    
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.right.equalTo(self.bgView).offset(-15);
        make.centerY.equalTo(self.timeLab.mas_centerY);
    }];
    
    [self.replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
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
    if (self.indexPath.section == 0) {
        vc.faceId = self.model.commentFromUserId;
    }else{
        if (index == 0) {
            vc.faceId = self.rmodel.replyFromUserId;
        }else{
            vc.faceId = self.rmodel.replyToUserId;
        }
    }
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}

#pragma mark - Event Response
//点击头像
- (void)headImageClick
{
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.indexPath = self.indexPath;
    if (self.indexPath.section == 0) {
        vc.faceId = self.model.commentFromUserId;
    }else{
       vc.faceId = self.rmodel.replyFromUserId;
    }
    
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}

//点击评论
- (void)commentClick
{
    if ([self.delegate respondsToSelector:@selector(FWAllReplyCellDelegateCommentAndReplyClick:rmodel:indexPath:)]) {
        [self.delegate FWAllReplyCellDelegateCommentAndReplyClick:self.model rmodel:self.rmodel indexPath:self.indexPath];
    }
}

//点击赞
- (void)zanClick
{
    DLog(@"赞");
    NSDictionary *param = nil;
    if (self.indexPath.section == 0) {
        param = @{
                    @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                    @"isLike":self.model.isLike,
                    @"type":@"2",
                    @"relatedId":self.model.commentId,
                    @"toUserId":self.model.commentFromUserId
                };
    }else{
        param = @{
                  @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                  @"isLike":self.rmodel.isLike,
                  @"type":@"3",
                  @"relatedId":self.rmodel.replyId,
                  @"toUserId":self.rmodel.replyFromUserId
                  };
    }
    
    [self actionliked:param];
}

- (void)delClick
{
    if ([self.delegate respondsToSelector:@selector(FWAllReplyCellDelegateCommentAndReplyDeleteClick:rmodel:indexPath:)]) {
        [self.delegate FWAllReplyCellDelegateCommentAndReplyDeleteClick:self.model rmodel:self.rmodel indexPath:self.indexPath];
    }
}

#pragma mark - Network requests

- (void)actionliked:(NSDictionary*)param
{
    [FWCommentManager actionCommentLikedWithParameter:param result:^(id response) {
        NSInteger zan = self.zanBtn.titleLabel.text.integerValue;
        if (self.indexPath.section == 0) {
            if ([self.model.isLike isEqualToString:@"0"]) {
                [self.zanBtn setImage:Image(@"warrant_zanSel") forState:UIControlStateNormal];
                zan = zan+1;
                self.model.isLike = @"1";
                
            }else{
                [self.zanBtn setImage:Image(@"warrant_zan") forState:UIControlStateNormal];
                zan = zan-1;
                self.model.isLike = @"0";
            }
        }else{
            if ([self.rmodel.isLike isEqualToString:@"0"]) {
                [self.zanBtn setImage:Image(@"warrant_zanSel") forState:UIControlStateNormal];
                zan = zan+1;
                self.rmodel.isLike = @"1";
                
            }else{
                [self.zanBtn setImage:Image(@"warrant_zan") forState:UIControlStateNormal];
                zan = zan-1;
                self.rmodel.isLike = @"0";
            }
        }
        [self.zanBtn setTitle:[NSString stringWithFormat:@"%ld",zan] forState:UIControlStateNormal];
    }];
}


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}


- (void)configCellWithData:(FWCommendReplyModel*)model replyData:(FWReplyModel*)rmodel indexPath:(NSIndexPath*)indexPath
{
    self.indexPath = indexPath;
    self.model = model;
    if (indexPath.section == 0) {
        [self.headImageView sd_setImageWithURL:URL(model.commentFromUserHeadUrl) placeholderImage:Image_placeHolder80];
        [self replaceText:model.commentFromUser str2:@"" type:@"0"];
        [self.replyBtn setTitle:model.replyCount forState:UIControlStateNormal];
        [self.zanBtn setTitle:model.commentLikeCount forState:UIControlStateNormal];
        self.contentLab.text = model.commentContent;
        self.timeLab.text = model.commentTime;
        self.bgView.backgroundColor = Color_White;
        if ([model.isLike isEqualToString:@"1"]) {
            [self.zanBtn setImage:Image(@"warrant_zanSel") forState:UIControlStateNormal];
        }else{
            [self.zanBtn setImage:Image(@"warrant_zan") forState:UIControlStateNormal];
        }
//        if ([model.commentFromUserId isEqualToString:[USER_DEFAULTS objectForKey:UD_UserID]]) {
//            self.delBtn.hidden = NO;
//        }else{
//            self.delBtn.hidden = YES;
//        }
        self.delBtn.hidden = YES;
    }else{
        self.rmodel = rmodel;
        [self.headImageView sd_setImageWithURL:URL(rmodel.replyFromUserHeadUrl) placeholderImage:Image_placeHolder80];
        if ([rmodel.replyType isEqualToString:@"2"]) {
            [self replaceText:rmodel.replyFromUser str2:rmodel.replyToUser type:@"1"];
        }else{
            [self replaceText:rmodel.replyFromUser str2:@"" type:@"0"];
        }
        self.bgView.backgroundColor = Color_MainBg;
        [self.bgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(45);
            make.right.equalTo(self.contentView).offset(-10);
        }];
        [self.replyBtn setTitle:rmodel.replyCount forState:UIControlStateNormal];
        [self.zanBtn setTitle:rmodel.replyLikeCount forState:UIControlStateNormal];
        self.contentLab.text = rmodel.replyContent;
        self.timeLab.text = rmodel.replyTime;
        if ([rmodel.isLike isEqualToString:@"1"]) {
            [self.zanBtn setImage:Image(@"warrant_zanSel") forState:UIControlStateNormal];
        }else{
            [self.zanBtn setImage:Image(@"warrant_zan") forState:UIControlStateNormal];
        }
        if ([rmodel.replyFromUserId isEqualToString:[USER_DEFAULTS objectForKey:UD_UserID]]) {
            self.delBtn.hidden = NO;
        }else{
            self.delBtn.hidden = YES;
        }
    }
}

#pragma mark - Private Methods

- (void)replaceText:(NSString*)str1 str2:(NSString*)str2 type:(NSString *)type
{
    if ([type isEqualToString:@"0"]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:str1];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, str1.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:Color_SubText range:NSMakeRange(0, str1.length)];
        //最好设置一下行高，不设的话默认是0
        NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc] init];
        sty.alignment = NSTextAlignmentLeft;
        sty.lineSpacing = 2;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:sty range:NSMakeRange(0, str1.length)];
        
        self.nameLab.attributedText = attributedString;
        [self.nameLab lhkh_addAttributeTapActionWithStrings:@[str1] delegate:self];
        
    }else{
        NSString * replyStr = [NSString stringWithFormat:@"%@ 回复 %@",str1,str2];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:replyStr];
        [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, str1.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:Color_SubText range:NSMakeRange(0, str1.length)];
        [attributedString addAttribute:NSForegroundColorAttributeName value:Color_SubText range:NSMakeRange(str1.length+4, str2.length)];
        //最好设置一下行高，不设的话默认是0
        NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc] init];
        sty.alignment = NSTextAlignmentLeft;
        sty.lineSpacing = 2;
        [attributedString addAttribute:NSParagraphStyleAttributeName value:sty range:NSMakeRange(0, replyStr.length)];
        
        self.nameLab.attributedText = attributedString;
        [self.nameLab lhkh_addAttributeTapActionWithStrings:@[str1,str2] delegate:self];
    }
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

- (UIView*)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = Color_White;
    }
    return _bgView;
}

- (UIImageView*)headImageView
{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _headImageView.layer.cornerRadius = 15;
        _headImageView.layer.masksToBounds = YES;
    }
    return _headImageView;
}

- (UIButton *)headImageViewbtn
{
    if (!_headImageViewbtn) {
        _headImageViewbtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_headImageViewbtn addTarget:self action:@selector(headImageClick) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    return _headImageViewbtn;
}

- (UILabel *)nameLab
{
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLab.font = systemFont(12);
    }
    return _nameLab;
}

- (UILabel *)contentLab
{
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLab.text = @"";
        _contentLab.font = systemFont(14);
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}

- (UILabel *)timeLab
{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLab.text = @"";
        _timeLab.font = systemFont(12);
        _timeLab.textColor = Color_SubText;
    }
    return _timeLab;
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

- (UIButton *)replyBtn
{
    if (!_replyBtn) {
        _replyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_replyBtn setImage:[UIImage imageNamed:@"warrant_commendSmall"] forState:UIControlStateNormal];
        _replyBtn.titleLabel.font = systemFont(12);
        [_replyBtn setTitleColor:Color_SubText forState:UIControlStateNormal];
        [_replyBtn addTarget:self action:@selector(commentClick) forControlEvents:(UIControlEventTouchUpInside)];
        _replyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    }
    return _replyBtn;
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

#pragma mark - Getters


@end
