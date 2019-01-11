//
//  FWWarrantCommentCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/19.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantCommentCell.h"
#import "FWWarrantCommentView.h"
#import "FWWarrantDetailModel.h"
#import "FWCommentManager.h"
#import "FWCommentListVC.h"
#import "FWPersonalHomePageVC.h"
@interface FWWarrantCommentCell ()
{
    CGFloat jiaoH;
    CGFloat commentViewH;
}
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIButton *headImageViewbtn;
@property (nonatomic, strong) UIButton *nameBtn;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UIButton *zanBtn;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIImageView *extensionTopImageView;
@property (nonatomic, strong) FWWarrantCommentView *extensionCommentView;
@property (nonatomic, strong) NSMutableArray *commentList;
@property (nonatomic, strong) FWWarrantDetailModel *dmodel;
@property (nonatomic, strong) CommendReplyModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation FWWarrantCommentCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWWarrantCommentCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWWarrantCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWWarrantCommentCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
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


#pragma mark - Event Response
//点击头像
- (void)headImageClick
{
    DLog(@"头像");
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.indexPath = self.indexPath;
    vc.faceId = self.model.commentFromUserId;
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}
//点击名称
- (void)nameClick
{
    DLog(@"名字");
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.indexPath = self.indexPath;
    vc.faceId = self.model.commentFromUserId;
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}

//点击评论
- (void)commentClick
{
    DLog(@"评论");
    FWCommentListVC *vc = [[FWCommentListVC alloc] init];
    vc.commentType = @"2";
    vc.fromWarrant = @"1";
    vc.dModel = self.dmodel;
    vc.cModel = self.model;
    [[self superViewController:self].navigationController pushViewController:vc animated:YES];
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
        }else if (response[@"resultCode"] && [response[@"resultCode"] isEqual:@4002]){
            [MBProgressHUD showTips:response[@"resultDesc"]];
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

- (void)configCellWithData:(FWWarrantDetailModel*)dModel commentReplyModel:(CommendReplyModel*)model  indexPath:(NSIndexPath*)indexPath;
{
    self.model = model;
    self.dmodel = dModel;
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
    
    self.extensionCommentView.tag = indexPath.row;
    if ([model.replyCount isEqualToString:@"0"]) {
        jiaoH = 0;
        commentViewH = 0;
    }else{
        jiaoH = 12;
        NSString *replyStr = @"";
        CGFloat h = 0;
        for (int i=0; i<model.replyResponseDtoList.count; i++) {
            ReplyModel *rmodel = [ReplyModel mj_objectWithKeyValues:model.replyResponseDtoList[i]];
            if ([model.commentFromUserId isEqual:rmodel.replyToUserId]) {
                replyStr = [NSString stringWithFormat:@"%@：%@",rmodel.replyFromUser,rmodel.replyContent]; 
            }else{
                replyStr = [NSString stringWithFormat:@"%@ 回复 %@：%@",rmodel.replyFromUser,rmodel.replyToUser,rmodel.replyContent];
            }
            CGFloat strH = [self stringHeightWithString:replyStr size:12 maxWidth:Screen_W-75];
            h = h + strH + 10;
        }
        commentViewH = h + 35;
        [self.extensionCommentView configViewWithModel:model];
        self.extensionCommentView.dModel = dModel;
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
    return ceilf(height);
}

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
        _timeLab.text = @"07-19";
        _timeLab.font = systemFont(12);
        _timeLab.textColor = Color_SubText;
    }
    return _timeLab;
}

- (UIButton *)commentBtn
{
    if (_commentBtn == nil) {

        _commentBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_commentBtn setImage:Image(@"warrant_commendSmall") forState:UIControlStateNormal];
        [_commentBtn setTitle:@"1111" forState:UIControlStateNormal];
        _commentBtn.titleLabel.font = systemFont(12);
        [_commentBtn setTitleColor:Color_SubText forState:UIControlStateNormal];
        [_commentBtn addTarget:self action:@selector(commentClick) forControlEvents:(UIControlEventTouchUpInside)];
        _commentBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
    }
    return _commentBtn;
}

- (UIButton *)zanBtn
{
    if (_zanBtn == nil) {
        
        _zanBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_zanBtn setImage:Image(@"warrant_zan") forState:UIControlStateNormal];
        [_zanBtn setTitle:@"1111" forState:UIControlStateNormal];
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
        _extensionTopImageView.image = Image(@"warrant_jiao");
    }
    return _extensionTopImageView;
}

- (FWWarrantCommentView *)extensionCommentView
{
    if (!_extensionCommentView) {
        _extensionCommentView = [[FWWarrantCommentView alloc] initWithFrame:CGRectZero];
        _extensionCommentView.backgroundColor = Color_MainBg;
        _extensionCommentView.layer.cornerRadius = 5.f;
        _extensionCommentView.layer.masksToBounds = YES;
    }
    return _extensionCommentView;
}

- (NSMutableArray *)commentList
{
    if (_commentList == nil) {
        _commentList = [NSMutableArray array];
    }
    return _commentList;
}

#pragma mark - Getters


@end
