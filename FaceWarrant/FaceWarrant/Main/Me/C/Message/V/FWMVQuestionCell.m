//
//  FWMVQuestionCell.m
//  FaceWarrantDel
//
//  Created by FW on 2018/11/12.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import "FWMVQuestionCell.h"
#import "FWMessageAModel.h"
#import "UILabel+LhkhAttributeTextTapAction.h"
#import "FWPersonalHomePageVC.h"
@interface FWMVQuestionCell ()<LhkhAttributeTextTapActionDelegate>
@property (nonatomic, strong) UIImageView *itemImg;
@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, strong) UIImageView *youImg;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIView *voiceView;
@property (nonatomic, strong) UIImageView *msgBackGoundImageView;
@property (nonatomic, strong) UIImageView *messageVoiceStatusImageView;
@property (nonatomic, strong) UILabel *messageVoiceSecondsLabel;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *coverLabel;
@property (nonatomic, strong) FWMessageAModel *model;
@end

@implementation FWMVQuestionCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMVQuestionCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMVQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWMVQuestionCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
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
        [self.contentView addSubview:self.voiceView];
        [self.contentView addSubview:self.headerBtn];
        [self.voiceView addSubview:self.msgBackGoundImageView];
        [self.voiceView addSubview:self.messageVoiceStatusImageView];
        [self.voiceView addSubview:self.messageVoiceSecondsLabel];
        [self.contentView addSubview:self.coverView];
        [self.coverView addSubview:self.coverLabel];
        
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(40);
        make.top.left.equalTo(self.contentView).offset(10);
    }];
    
    [self.headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.itemImg);
    }];
    
    [self.youImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(10);
        make.height.offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
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
    
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(60);
        make.left.equalTo(self.descLab.mas_left);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.timeLab.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];

    [self.msgBackGoundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.voiceView).offset(10);
        make.left.equalTo(self.voiceView).offset(10);
        make.height.offset(40);
        make.width.offset(50);
    }];

    [self.messageVoiceSecondsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.msgBackGoundImageView.mas_right).offset(10);
        make.centerY.equalTo(self.msgBackGoundImageView.mas_centerY);
        make.height.offset(40);
        make.width.offset(50);
    }];

    [self.messageVoiceStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.msgBackGoundImageView.mas_left).with.offset(20);
        make.centerY.equalTo(self.msgBackGoundImageView.mas_centerY);
        make.height.offset(22);
        make.width.offset(15);
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
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.faceId = self.model.fromUserId;
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}

#pragma mark - Event Response
- (void)handleTap:(UITapGestureRecognizer *)tap {
    DLog(@"-----");
    if ([self.delegate respondsToSelector:@selector(FWMVQuestionCellDelegateTapClick:)]) {
        [self.delegate FWMVQuestionCellDelegateTapClick:self];
    }
}

- (void)imgClick
{
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.faceId = self.model.fromUserId;
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}

#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithModel:(FWMessageAModel*)model
{
    self.model = model;
    [self.itemImg sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image(@"contactHeader")];
    self.timeLab.text = model.createTime;
    
    self.messageVoiceSecondsLabel.text = [NSString stringWithFormat:@"%.0f''",model.answerContentTime.floatValue];
    [self.msgBackGoundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(50 + model.answerContentTime.floatValue * 2.5));//根据时长变化
    }];
    
    if ([model.questionStatus isEqualToString:@"1"]) {
        _coverLabel.text = @"此提问已被删除";
        self.coverView.hidden = NO;
        self.coverLabel.hidden = NO;
    }else{
        if ([model.answerStatus isEqualToString:@"1"]) {
            _coverLabel.text = @"此回答已被删除";
            self.coverView.hidden = NO;
            self.coverLabel.hidden = NO;
        }else{
            self.coverView.hidden = YES;
            self.coverLabel.hidden = YES;
        }
    }
    
    if ([model.status isEqualToString:@"0"]) {
        self.youImg.hidden = NO;
    }else{
        self.youImg.hidden = YES;
    }
    NSString *answerStr = [NSString stringWithFormat:@"%@ 回答了我的提问",model.fromUser];
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
}


#pragma mark - Private Methods
#pragma mark 获取当前View所在的ViewController
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
        _itemImg.layer.cornerRadius = 20.f;
        _itemImg.layer.masksToBounds = YES;
    }
    return _itemImg;
}

- (UIImageView*)youImg
{
    if (_youImg == nil) {
        _youImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _youImg.image = [UIImage imageNamed:@"red_dot"];
    }
    return _youImg;
}

- (UILabel *)descLab
{
    if (_descLab == nil) {
        _descLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLab.text = @"";
        _descLab.textColor = Color_MainText;
        _descLab.font = systemFont(14);
    }
    return _descLab;
}

- (UILabel *)timeLab
{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLab.text = @"2018-07-04-16:33";
        _timeLab.textColor = Color_SubText;
        _timeLab.font = systemFont(12);
    }
    return _timeLab;
}

- (UIButton *)headerBtn
{
    if (_headerBtn == nil) {
        _headerBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_headerBtn addTarget:self action:@selector(imgClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerBtn;
}


- (UIView*)voiceView
{
    if (_voiceView == nil) {
        _voiceView = [[UIView alloc] initWithFrame:CGRectZero];
        _voiceView.backgroundColor = Color_MainBg;
    }
    return _voiceView;
}

- (UIImageView *)msgBackGoundImageView {
    if (!_msgBackGoundImageView) {
        _msgBackGoundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _msgBackGoundImageView.userInteractionEnabled = YES;
        [self.msgBackGoundImageView setImage:[[UIImage imageNamed:@"me_yuan"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 8, 20) resizingMode:UIImageResizingModeStretch]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.msgBackGoundImageView addGestureRecognizer:tap];
    }
    return _msgBackGoundImageView;
}

- (UIImageView *)messageVoiceStatusImageView {
    if (!_messageVoiceStatusImageView) {
        _messageVoiceStatusImageView = [[UIImageView alloc] init];
        _messageVoiceStatusImageView.image = [UIImage imageNamed:@"me_voice3"] ;
        UIImage *image1 = [UIImage imageNamed:@"me_voice1"];
        UIImage *image2 = [UIImage imageNamed:@"me_voice2"];
        UIImage *image3 = [UIImage imageNamed:@"me_voice3"];
        _messageVoiceStatusImageView.animationImages = @[image1,image2,image3];
        _messageVoiceStatusImageView.animationDuration = 1.5f;
        _messageVoiceStatusImageView.animationRepeatCount = NSUIntegerMax;
    }
    return _messageVoiceStatusImageView;
}

- (UILabel *)messageVoiceSecondsLabel {
    if (!_messageVoiceSecondsLabel) {
        _messageVoiceSecondsLabel = [[UILabel alloc] init];
        _messageVoiceSecondsLabel.font = [UIFont systemFontOfSize:14.0f];
        _messageVoiceSecondsLabel.text = @"0''";
    }
    return _messageVoiceSecondsLabel;
}

- (void)setVoicePlayState:(LGVoicePlayState)voicePlayState {
    if (_voicePlayState != voicePlayState) {
        _voicePlayState = voicePlayState;
    }
    if (_voicePlayState == LGVoicePlayStatePlaying) {
        [self.messageVoiceStatusImageView startAnimating];
    }else{
        [self.messageVoiceStatusImageView stopAnimating];
    }
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
        _coverLabel.text = @"此回答已被删除";
        _coverLabel.textColor = Color_White;
        _coverLabel.font = systemFont(14);
    }
    return _coverLabel;
}

#pragma mark - Setters


#pragma mark - Getters


@end
