//
//  FWQDetailVCell.m
//  FaceWarrant
//
//  Created by FW on 2018/9/26.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWQDetailVCell.h"
#import "FWPersonalHomePageVC.h"
#import "FWQAndADetailModel.h"
#import "FWPicView.h"
#import "LGAudioKit.h"
#import <AVFoundation/AVFoundation.h>

@interface FWQDetailVCell ()
@property (strong, nonatomic) UIImageView *userImg;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UIImageView *msgBackGoundImageView;
@property (strong, nonatomic) UIImageView *messageVoiceStatusImageView;
@property (nonatomic, strong) UILabel *messageVoiceSecondsLabel;
@property (strong, nonatomic) UIButton *userBtn;
@property (strong, nonatomic) UIView *typeView;
@property (strong, nonatomic) FWPicView *picView;
@property (strong, nonatomic) FWQAndADetailModel *model;
@property (strong, nonatomic) AnswerInfoListModel *aModel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end

@implementation FWQDetailVCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWQDetailVCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWQDetailVCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWQDetailVCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.userImg];
        [self.contentView addSubview:self.userName];
        [self.contentView addSubview:self.userBtn];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.msgBackGoundImageView];
        [self.contentView addSubview:self.messageVoiceStatusImageView];
        [self.contentView addSubview:self.messageVoiceSecondsLabel];
        [self.contentView addSubview:self.typeView];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(40);
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.left.equalTo(self.userImg.mas_right).offset(10);
        make.top.equalTo(self.userImg);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(self.userName.mas_bottom).offset(5);
        make.left.equalTo(self.userName);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.msgBackGoundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLab.mas_bottom).offset(10);
        make.left.equalTo(self.userName);
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
    
    [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.offset(95);
        make.top.equalTo(self.msgBackGoundImageView.mas_bottom).offset(15);
    }];
    
    [self.userBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.right.equalTo(self.userImg);
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = Color_MainBg;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(5);
        make.left.right.equalTo(self.contentView);
        make.top.equalTo(self.typeView.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView);
    }];
}

#pragma mark - System Delegate


#pragma mark - Custom Delegate



#pragma mark - Event Response

- (void)userClick
{
    DLog(@"userheader");
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.indexPath = self.indexPath;
    if (self.indexPath.section == 0) {
        vc.faceId = self.model.questionUserId;
    }else{
        vc.faceId = self.aModel.answerUserId;
    }
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    DLog(@"-----");
    if ([self.delegate respondsToSelector:@selector(FWQDetailVCellDelegateTapClick:)]) {
        [self.delegate FWQDetailVCellDelegateTapClick:self];
    }
}

#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithModel:(FWQAndADetailModel *)model subModel:(AnswerInfoListModel *)aModel indexPath:(NSIndexPath*)indexPath
{
    self.aModel = aModel;
    self.indexPath = indexPath;
    if (indexPath.section == 0) {
        [self.userImg sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image_placeHolder80];
        self.userName.text = model.questionUser;
        self.timeLab.text = model.createTime;
        self.typeView.hidden = YES;
        [self.typeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userName);
            make.right.equalTo(self.contentView).offset(-10);
            make.height.offset(0);
            make.top.equalTo(self.msgBackGoundImageView.mas_bottom).offset(15);
        }];
        
    }else{
        [self.userImg sd_setImageWithURL:URL(aModel.headUrl) placeholderImage:Image_placeHolder80];
        self.userName.text = aModel.answerUser;
        self.timeLab.text = aModel.answerTime;
//        self.messageVoiceSecondsLabel.text = [NSString stringWithFormat:@"%ld''",(long)[self durationWithVideo:URL(aModel.answerContent)]];
        self.messageVoiceSecondsLabel.text = [NSString stringWithFormat:@"%.0f''",aModel.answerContentTime.floatValue];
        
        [self.msgBackGoundImageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.width.equalTo(@(50 + (long)[self durationWithVideo:URL(aModel.answerContent)] * 2.5));//根据时长变化
            make.width.equalTo(@(50 + aModel.answerContentTime.floatValue * 2.5));//根据时长变化
        }];
        
        if (aModel.releaseGoodsDtoList.count>0) {
            self.typeView.hidden = NO;
            [self.typeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.userName);
                make.right.equalTo(self.contentView).offset(-10);
                make.height.offset(95);
                make.top.equalTo(self.msgBackGoundImageView.mas_bottom).offset(15);
            }];
            [self.picView configViewWithPicArr:aModel.releaseGoodsDtoList];
        }else{
            self.typeView.hidden = YES;
            [self.typeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.userName);
                make.right.equalTo(self.contentView).offset(-10);
                make.height.offset(0);
                make.top.equalTo(self.msgBackGoundImageView.mas_bottom).offset(15);
            }];
        }
    }
    
}

#pragma mark - Private Methods

//- (NSUInteger)durationWithVideo:(NSURL *)audioUrl{
//    NSDictionary *opts = [NSDictionary dictionaryWithObject:@(NO) forKey:AVURLAssetPreferPreciseDurationAndTimingKey];
//    AVURLAsset *urlAsset = [AVURLAsset URLAssetWithURL:audioUrl options:opts]; // 初始化视频媒体文件
//    NSUInteger second = 0;
//    second = urlAsset.duration.value / urlAsset.duration.timescale; // 获取视频总时长,单位秒
//    return second;
//}


#pragma mark 获取当前View所在的ViewController
- (UIViewController *)superViewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}

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


- (UIImageView *)userImg
{
    if (_userImg == nil) {
        _userImg = [[UIImageView alloc]init];
        _userImg.contentMode = UIViewContentModeScaleAspectFill;
        _userImg.layer.cornerRadius = 20;
        _userImg.layer.masksToBounds = YES;
    }
    return _userImg;
}

- (UILabel*)userName
{
    if (_userName == nil) {
        _userName = [[UILabel alloc] init];
        _userName.font = systemFont(14);
        _userName.textColor = Color_Black;
    }
    return _userName;
}

- (UIButton*)userBtn
{
    if (_userBtn == nil) {
        _userBtn = [[UIButton alloc]init];
        [_userBtn addTarget:self action:@selector(userClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userBtn;
}

- (UILabel*)timeLab
{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.font = systemFont(12);
        _timeLab.textColor = Color_SubText;
    }
    return _timeLab;
}

- (UIImageView *)msgBackGoundImageView {
    if (!_msgBackGoundImageView) {
        _msgBackGoundImageView = [[UIImageView alloc] init];
        _msgBackGoundImageView.userInteractionEnabled = YES;
        [self.msgBackGoundImageView setImage:[[UIImage imageNamed:@"me_yuan"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 8, 20) resizingMode:UIImageResizingModeStretch]];
        [self.msgBackGoundImageView setHighlightedImage:[[UIImage imageNamed:@"me_yuan"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 8, 20) resizingMode:UIImageResizingModeStretch]];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [self.msgBackGoundImageView addGestureRecognizer:tap];
    }
    return _msgBackGoundImageView;
}

- (UILabel *)messageVoiceSecondsLabel {
    if (!_messageVoiceSecondsLabel) {
        _messageVoiceSecondsLabel = [[UILabel alloc] init];
        _messageVoiceSecondsLabel.font = [UIFont systemFontOfSize:14.0f];
        _messageVoiceSecondsLabel.text = @"0''";
    }
    return _messageVoiceSecondsLabel;
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

- (UIView*)typeView
{
    if (_typeView == nil) {
        _typeView = [[UIView alloc]initWithFrame:CGRectZero];
    }
    return _typeView;
}

- (FWPicView*)picView
{
    if (_picView == nil) {
        _picView = [[FWPicView alloc]initWithFrame:CGRectZero];
        [self.typeView addSubview:self.picView];
        [self.picView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.equalTo(self.typeView);
        }];
    }
    return _picView;
}
#pragma mark - Getters


@end
