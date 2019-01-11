//
//  FWMQReplyCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMQReplyCell.h"
#import "FWMessageAModel.h"
#import "UILabel+LhkhAttributeTextTapAction.h"
#import "FWQuestionDetailVC.h"
#import "FWPersonalHomePageVC.h"
@interface FWMQReplyCell ()<LhkhAttributeTextTapActionDelegate>
@property (nonatomic, strong) UIImageView *itemImg;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) UIImageView *youImg;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UIButton *replyBtn;
@property (nonatomic, strong) UIImageView *dotImg;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *coverLabel;
@property (nonatomic, strong) FWMessageAModel *model;
@end

@implementation FWMQReplyCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMQReplyCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMQReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWMQReplyCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.itemImg];
        [self.contentView addSubview:self.descLab];
        [self.contentView addSubview:self.youImg];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.contentLab];
        [self.contentView addSubview:self.replyBtn];
        [self.contentView addSubview:self.dotImg];
        [self.contentView addSubview:self.imgBtn];
        [self.contentView addSubview:self.delBtn];
        [self.coverView addSubview:self.coverLabel];
        [self.contentView addSubview:self.coverView];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutCustomViews
{
    [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(35);
        make.top.left.equalTo(self.contentView).offset(10);
    }];
    
    [self.imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.itemImg);
    }];
    
//    [self.youImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(8);
//        make.height.offset(14);
//        make.right.equalTo(self.contentView).offset(-10);
//        make.top.equalTo(self.contentView).offset(30);
//    }];
    
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.itemImg.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(self.descLab.mas_bottom).offset(5);
        make.left.equalTo(self.descLab.mas_left);
    }];
    
    [self.replyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.width.offset(40);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descLab.mas_left);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.timeLab.mas_bottom).offset(10);
        make.bottom.equalTo(self.replyBtn.mas_top).offset(-10);
    }];
    
    [self.dotImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(10);
        make.height.offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(25);
        make.top.equalTo(self.contentView).offset(15);
        make.right.equalTo(self.contentView).offset(-15);
    }];
    
    [self.coverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.top.equalTo(self.contentView);
    }];
    
    [self.coverLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.width.offset(100);
        make.centerX.equalTo(self.coverView.mas_centerX);
        make.centerY.equalTo(self.coverView.mas_centerY);
    }];
}


#pragma mark - System Delegate




#pragma mark - Custom Delegate

#pragma mark -LhkhAttributeTextTapActionDelegate
- (void)lhkh_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    DLog(@"--->%@",string);
}


#pragma mark - Event Response

- (void)replyClick
{
    FWQuestionDetailVC *vc = [FWQuestionDetailVC new];
    vc.questionId = self.model.questionId;
    vc.touserId = self.model.fromUserId;
    vc.messageId = self.model.messageId;
    vc.type = @"1";
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}

- (void)imgClick
{
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.faceId = self.model.fromUserId;
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}

- (void)delclick
{
    if ([self.delegate respondsToSelector:@selector(FWMQReplyCellDelClickDelegate:)]) {
        [self.delegate FWMQReplyCellDelClickDelegate:self.model.messageId];
    }
}

#pragma mark - Network requests




#pragma mark - Public Methods

+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithModel:(FWMessageAModel *)model vctype:(NSString*)vctype
{
    self.model = model;
    [self.itemImg sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image(@"contactHeader")];
    self.timeLab.text = model.createTime;
    self.contentLab.text = model.questionContent;
    
    NSString *answerStr = [NSString stringWithFormat:@"%@ 对我提问",model.fromUser];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:answerStr];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, model.fromUser.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:Color_SubText range:NSMakeRange(0, model.fromUser.length)];
    //最好设置一下行高，不设的话默认是0
    NSMutableParagraphStyle *sty = [[NSMutableParagraphStyle alloc] init];
    sty.alignment = NSTextAlignmentLeft;
    sty.lineSpacing = 2;
    [attributedString addAttribute:NSParagraphStyleAttributeName value:sty range:NSMakeRange(0, answerStr.length)];
    
    self.descLab.attributedText = attributedString;
    
    [self.descLab lhkh_addAttributeTapActionWithStrings:@[model.fromUser] delegate:self];
    
    if ([model.status isEqualToString:@"0"]) {
        self.dotImg.hidden = NO;
    }else{
        self.dotImg.hidden = YES;
    }
    
    if ([model.questionStatus isEqualToString:@"1"]) {
        self.coverView.hidden = NO;
        self.coverLabel.hidden = NO;
    }else{
        self.coverView.hidden = YES;
        self.coverLabel.hidden = YES;
    }
    
    if ([vctype isEqualToString:@"FWDiscoveryTypeVC"]) {
        self.delBtn.hidden = NO;
    }else{
        self.delBtn.hidden = YES;
    }
}


#pragma mark - Private Methods

- (UIViewController *)superViewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}


#pragma mark - Setters

- (UIImageView*)itemImg
{
    if (_itemImg == nil) {
        _itemImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _itemImg.contentMode = UIViewContentModeScaleAspectFill;
        _itemImg.layer.cornerRadius = 35/2;
        _itemImg.layer.masksToBounds = YES;
    }
    return _itemImg;
}

- (UIImageView*)youImg
{
    if (_youImg == nil) {
        _youImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _youImg.image = [UIImage imageNamed:@"you"];
    }
    return _youImg;
}

- (UILabel *)descLab
{
    if (_descLab == nil) {
        _descLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLab.textColor = Color_MainText;
        _descLab.font = systemFont(14);
    }
    return _descLab;
}

- (UILabel *)timeLab
{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLab.textColor = Color_SubText;
        _timeLab.font = systemFont(12);
    }
    return _timeLab;
}

- (UILabel *)contentLab
{
    if (_contentLab == nil) {
        _contentLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLab.textColor = Color_SubText;
        _contentLab.font = systemFont(12);
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}

- (UIButton*)replyBtn
{
    if (_replyBtn == nil) {
        _replyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_replyBtn setTitle:@"回复" forState:UIControlStateNormal];
        [_replyBtn setTitleColor:Color_Theme_Pink forState:UIControlStateNormal];
        _replyBtn.titleLabel.font = systemFont(14);
        _replyBtn.layer.cornerRadius = 5.f;
        _replyBtn.layer.masksToBounds = YES;
        _replyBtn.layer.borderColor = Color_Theme_Pink.CGColor;
        _replyBtn.layer.borderWidth = 1.f;
        [_replyBtn addTarget:self action:@selector(replyClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _replyBtn;
}


- (UIImageView*)dotImg
{
    if (_dotImg == nil) {
        _dotImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _dotImg.image = [UIImage imageNamed:@"red_dot"];
    }
    return _dotImg;
}

- (UIButton*)imgBtn
{
    if (_imgBtn == nil) {
        _imgBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_imgBtn addTarget:self action:@selector(imgClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgBtn;
}

- (UIButton*)delBtn
{
    if (_delBtn == nil) {
        _delBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_delBtn setImage:Image(@"discovery_close") forState:UIControlStateNormal];
        [_delBtn addTarget:self action:@selector(delclick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delBtn;
}

- (UIView*)coverView
{
    if (_coverView == nil) {
        _coverView = [[UIView alloc] initWithFrame:CGRectZero];
        _coverView.backgroundColor = [Color_Black colorWithAlphaComponent:0.2];
    }
    return _coverView;
}

- (UILabel *)coverLabel
{
    if (_coverLabel == nil) {
        _coverLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _coverLabel.text = @"此提问已被删除";
        _coverLabel.textColor = Color_White;
        _coverLabel.font = systemFont(14);
    }
    return _coverLabel;
}

#pragma mark - Getters



@end
