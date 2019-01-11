//
//  FWCommentCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/20.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWCommentCell.h"
#import "FWCommentView.h"
#import "FWCommentModel.h"
#import "FWWarrantDetailModel.h"
#import "FWCommentManager.h"
#import "FWPersonalHomePageVC.h"
@interface FWCommentCell ()<FWCommentViewDelegate>
{
    CGFloat jiaoH;
    CGFloat commentViewH;
}
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIButton *headImageViewbtn;
@property (nonatomic, strong) UIButton *nameBtn;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *zanBtn;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIImageView *extensionTopImageView;
@property (nonatomic, strong) FWCommentView *extensionCommentView;
@property (nonatomic, strong) FWWarrantDetailModel *dmodel;
@property (nonatomic, strong) FWCommendReplyModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation FWCommentCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWCommentCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWCommentCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.headImageView];
        [self.contentView addSubview:self.headImageViewbtn];
        [self.contentView addSubview:self.nameBtn];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.delBtn];
        [self.contentView addSubview:self.commentBtn];
        [self.contentView addSubview:self.zanBtn];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.extensionTopImageView];
        [self.contentView addSubview:self.extensionCommentView];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutCustomViews
{
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(30);
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(10);
    }];
    
    [self.headImageViewbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.equalTo(self.headImageView);
    }];
    
    [self.nameBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.headImageView.mas_right).offset(5);
        make.top.equalTo(self.headImageView.mas_top);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameBtn.mas_left);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.headImageView.mas_bottom).offset(-5);
        make.bottom.equalTo(self.timeLab.mas_top).offset(-10);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.nameBtn.mas_left);
        make.top.equalTo(self.contentLab.mas_bottom).offset(10);
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeLab.mas_right).offset(10);
        make.centerY.equalTo(self.timeLab.mas_centerY);
    }];
    
    [self.zanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.right.equalTo(self.contentView).offset(-10);
        make.left.equalTo(self.commentBtn.mas_right).offset(20);
        make.centerY.equalTo(self.timeLab.mas_centerY);
    }];
    
    [self.commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.right.equalTo(self.zanBtn.mas_left).offset(-20);
        make.centerY.equalTo(self.timeLab.mas_centerY);
    }];
    
    [self.extensionTopImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(12);
        make.width.offset(22);
        make.left.equalTo(self.nameBtn.mas_left).offset(10);
        make.top.equalTo(self.timeLab.mas_bottom).offset(5);
        make.bottom.equalTo(self.extensionCommentView.mas_top).offset(1);
    }];
    
    [self.extensionCommentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameBtn);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.extensionTopImageView.mas_bottom).offset(-1);
        make.bottom.equalTo(self.contentView).offset(-10);
        
    }];
}


#pragma mark - System Delegate


#pragma mark - Custom Delegate

#pragma mark - FWCommentViewDelegate
- (void)FWCommentViewDelegateSubCellClickWithModel:(FWReplyModel *)rmodel indexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(FWCommentCellDelegateReplyClickWithModel:indexPath:)]) {
        [self.delegate FWCommentCellDelegateReplyClickWithModel:rmodel indexPath:indexPath];
    }
}

- (void)FWCommentViewDelegateSubCellDeleteClickWithModel:(FWReplyModel *)rmodel indexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(FWCommentCellDelegateReplyDeleteClick:indexPath:)]) {
        [self.delegate FWCommentCellDelegateReplyDeleteClick:rmodel indexPath:indexPath];
    }
}

#pragma mark - Event Response
//点击头像
- (void)headImageClick
{
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.indexPath = self.indexPath;
    vc.faceId = self.model.commentFromUserId;
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}
//点击名称
- (void)nameClick
{
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.indexPath = self.indexPath;
    vc.faceId = self.model.commentFromUserId;
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}

//点击评论
- (void)commentClick
{
    if ([self.delegate respondsToSelector:@selector(FWCommentCellDelegateClickWithModel:indexPath:)]) {
        [self.delegate FWCommentCellDelegateClickWithModel:self.model indexPath:self.indexPath];
    }
}

//点击赞
- (void)zanClick
{
    DLog(@"赞");
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"isLike":self.model.isLike,
                            @"type":@"2",
                            @"relatedId":self.model.commentId,
                            @"toUserId":self.model.commentFromUserId
                            };
    [self actionliked:param];
}

- (void)delClick
{
    if ([self.delegate respondsToSelector:@selector(FWCommentCellDelegateCommentDeleteClick:indexPath:)]) {
        [self.delegate FWCommentCellDelegateCommentDeleteClick:self.model indexPath:self.indexPath];
    }
}


#pragma mark - Network requests

- (void)actionliked:(NSDictionary*)param
{
    [FWCommentManager actionCommentLikedWithParameter:param result:^(id response) {
        if (response[@"resultCode"] && [response[@"resultCode"] isEqual:@200]) {
            NSInteger zan = self.zanBtn.titleLabel.text.integerValue;
            if ([self.model.isLike isEqualToString:@"0"]) {
                [self.zanBtn setImage:Image(@"warrant_zanSel") forState:UIControlStateNormal];
                zan = zan+1;
                self.model.isLike = @"1";
            }else{
                [self.zanBtn setImage:Image(@"warrant_zan") forState:UIControlStateNormal];
                zan = zan-1;
                self.model.isLike = @"0";
            }
            [self.zanBtn setTitle:[NSString stringWithFormat:@"%ld",zan] forState:UIControlStateNormal];
        }else{
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }
    }];
}

#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithData:(FWWarrantDetailModel*)dmodel model:(FWCommendReplyModel*)model moreReplyData:(NSArray*)moreReplyArr indexPath:(NSIndexPath*)indexPath
{
    self.dmodel = dmodel;
    self.model = model;
    self.indexPath = indexPath;
    [self.headImageView  sd_setImageWithURL:URL(model.commentFromUserHeadUrl) placeholderImage:Image_placeHolder80];
    [self.nameBtn setTitle:model.commentFromUser forState:UIControlStateNormal];
    self.contentLab.text = model.commentContent;
    self.timeLab.text = model.commentTime;
    [self.commentBtn setTitle:model.replyCount forState:UIControlStateNormal];
    [self.zanBtn setTitle:model.commentLikeCount forState:UIControlStateNormal];
    if ([model.isLike isEqualToString:@"1"]) {
        [self.zanBtn setImage:Image(@"warrant_zanSel") forState:UIControlStateNormal];
    }else{
        [self.zanBtn setImage:Image(@"warrant_zan") forState:UIControlStateNormal];
    }
    if ([model.commentFromUserId isEqualToString:[USER_DEFAULTS objectForKey:UD_UserID]]) {
        self.delBtn.hidden = NO;
    }else{
        self.delBtn.hidden = YES;
    }
    
    if ([model.replyCount isEqualToString:@"0"]) {
        jiaoH = 0;
        commentViewH = 0;
    }else{
        jiaoH = 12;
        NSString *replyStr = @"";
        CGFloat h = 0;
        if (moreReplyArr!=nil && moreReplyArr.count>0) {
            for (int i=0; i<moreReplyArr.count; i++) {
                FWReplyModel *rmodel = [FWReplyModel mj_objectWithKeyValues:moreReplyArr[i]];
                if ([model.commentFromUserId isEqual:rmodel.replyToUserId]) {
                    replyStr = [NSString stringWithFormat:@"%@：%@",rmodel.replyFromUser,rmodel.replyContent];
                }else{
                    replyStr = [NSString stringWithFormat:@"%@ 回复 %@：%@",rmodel.replyFromUser,rmodel.replyToUser,rmodel.replyContent];
                }
                CGFloat strH = [self stringHeightWithString:replyStr size:12 maxWidth:Screen_W-75];
                h = h + strH + 15;
            }
            commentViewH = h + 15;
        }else{
            for (int i=0; i<model.replyResponseDtoList.count; i++) {
                FWReplyModel *rmodel = [FWReplyModel mj_objectWithKeyValues:model.replyResponseDtoList[i]];
                if ([model.commentFromUserId isEqual:rmodel.replyToUserId]) {
                    replyStr = [NSString stringWithFormat:@"%@：%@",rmodel.replyFromUser,rmodel.replyContent];
                }else{
                    replyStr = [NSString stringWithFormat:@"%@ 回复 %@：%@",rmodel.replyFromUser,rmodel.replyToUser,rmodel.replyContent];
                }
                CGFloat strH = [self stringHeightWithString:replyStr size:12 maxWidth:Screen_W-75];
                h = h + strH;
            }
            
            if (model.replyResponseDtoList.count == 2) {
                commentViewH = h + 40;
            }else{
                commentViewH = h + 10;
            }
        }
        [self.extensionCommentView configViewWithModel:self.dmodel model:model moreReplyArr:moreReplyArr];
    }
    [self.extensionTopImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(self->jiaoH);
    }];
    [self.extensionCommentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.offset(self->commentViewH);
    }];
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

- (UIImageView*)headImageView
{
    if (_headImageView == nil) {
        _headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _headImageView.contentMode = UIViewContentModeScaleAspectFill;
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

- (UIButton *)nameBtn
{
    if (!_nameBtn) {
        _nameBtn = [[UIButton alloc]initWithFrame:CGRectZero];
        [_nameBtn  setTitle:@"" forState:UIControlStateNormal];
        _nameBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [_nameBtn setTitleColor:Color_SubText forState:UIControlStateNormal];
        _nameBtn.titleLabel.font = systemFont(14);
        [_nameBtn addTarget:self action:@selector(nameClick) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _nameBtn;
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

- (UIImageView *)extensionTopImageView
{
    if (!_extensionCommentView) {
        _extensionTopImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _extensionTopImageView.image = [UIImage imageNamed:@"warrant_jiao"];
    }
    return _extensionTopImageView;
}

- (FWCommentView *)extensionCommentView
{
    if (!_extensionCommentView) {
        _extensionCommentView = [[FWCommentView alloc] initWithFrame:CGRectZero];
        _extensionCommentView.backgroundColor = Color_MainBg;
        _extensionCommentView.layer.cornerRadius = 5.f;
        _extensionCommentView.layer.masksToBounds = YES;
        _extensionCommentView.delegate = self;
    }
    return _extensionCommentView;
}

#pragma mark - Getters


@end
