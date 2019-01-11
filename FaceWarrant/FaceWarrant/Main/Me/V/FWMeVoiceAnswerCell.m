//
//  FWMeVoiceAnswerCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMeVoiceAnswerCell.h"
#import "FWMeAnswerModel.h"
#import "LhkhLabel.h"
#import <AVFoundation/AVFoundation.h>
@interface FWMeVoiceAnswerCell ()
@property (nonatomic, strong) UIImageView *itemImg;
@property (nonatomic, strong) UIImageView *youImg;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIImageView *msgBackGoundImageView;
@property (nonatomic, strong) UIImageView *messageVoiceStatusImageView;
@property (nonatomic, strong) UILabel *messageVoiceSecondsLabel;
@property (nonatomic, strong) LhkhLabel *questionLab;
@end

@implementation FWMeVoiceAnswerCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMeVoiceAnswerCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMeVoiceAnswerCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWMeVoiceAnswerCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        [self.contentView addSubview:self.itemImg];
//        [self.contentView addSubview:self.descLab];
//        [self.contentView addSubview:self.youImg];
        
        [self.contentView addSubview:self.msgBackGoundImageView];
        [self.contentView addSubview:self.messageVoiceStatusImageView];
        [self.contentView addSubview:self.messageVoiceSecondsLabel];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.questionLab];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutCustomViews
{

    
//    [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.offset(40);
//        make.top.left.equalTo(self.contentView).offset(10);
//    }];
//
//    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.height.offset(20);
//        make.top.equalTo(self.contentView).offset(10);
//        make.left.equalTo(self.itemImg.mas_right).offset(10);
//        make.right.equalTo(self.contentView).offset(-10);
//    }];
//
//
//
//    [self.youImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.offset(8);
//        make.height.offset(14);
//        make.right.equalTo(self.contentView).offset(-10);
//        make.centerY.equalTo(self.msgBackGoundImageView.mas_centerY);
//    }];
    
    [self.msgBackGoundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.contentView).offset(10);
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
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(self.msgBackGoundImageView.mas_bottom).offset(5);
        make.left.equalTo(self.msgBackGoundImageView.mas_left);
    }];
    
    [self.questionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.msgBackGoundImageView.mas_left);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.timeLab.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
}

#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (void)handleTap:(UITapGestureRecognizer *)tap {
    DLog(@"-----");
    if ([self.delegate respondsToSelector:@selector(FWMeVoiceAnswerCellDelegateTapClick:)]) {
        [self.delegate FWMeVoiceAnswerCellDelegateTapClick:self];
    }
}
#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

-(void)configCellWithModel:(FWMeAnswerModel *)model indexPath:(NSIndexPath *)indexPath
{
    self.timeLab.text = model.answerTime;
    self.questionLab.text = model.questionContent;
//    self.messageVoiceSecondsLabel.text = [NSString stringWithFormat:@"%ld''",(long)[self durationWithVideo:URL(model.answerContent)]];
    self.messageVoiceSecondsLabel.text = [NSString stringWithFormat:@"%.0f''",model.answerContentTime.floatValue];
    [self.msgBackGoundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@(50 + model.answerContentTime.floatValue * 2.5));//根据时长变化
    }];
}
#pragma mark - Private Methods

//- (NSUInteger)durationWithVideo:(NSURL *)audioUrl{
//    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
//    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:audioUrl options:opts]; // 初始化视频媒体文件
//    NSUInteger second = 0;
//    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
//    return second;
//}

#pragma mark - Setters

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

- (UIImageView*)itemImg
{
    if (_itemImg == nil) {
        _itemImg = [[UIImageView alloc] initWithFrame:CGRectZero];
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

- (LhkhLabel *)questionLab
{
    if (_questionLab == nil) {
        _questionLab = [[LhkhLabel alloc] initWithFrame:CGRectZero];
        _questionLab.layer.cornerRadius = 4.f;
        _questionLab.layer.masksToBounds = YES;
        _questionLab.textColor = Color_Black;
        _questionLab.backgroundColor = Color_MainBg;
        _questionLab.font = systemFont(12);
        _questionLab.numberOfLines = 0;
        _questionLab.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _questionLab;
}

#pragma mark - Getters


@end
