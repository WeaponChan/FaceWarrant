//
//  FWQDetailFCell.m
//  FaceWarrant
//
//  Created by FW on 2018/8/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWQDetailFCell.h"
#import "FWPersonalHomePageVC.h"
#import "FWQAndADetailModel.h"
#import "FWPicView.h"
#import <AVFoundation/AVFoundation.h>
@interface FWQDetailFCell ()
@property (strong, nonatomic) UIImageView *userImg;
@property (strong, nonatomic) UILabel *userName;
@property (strong, nonatomic) UILabel *timeLab;
@property (strong, nonatomic) UILabel *contentLab;
@property (strong, nonatomic) UIButton *userBtn;
@property (strong, nonatomic) UIView *typeView;
@property (strong, nonatomic) FWPicView *picView;
@property (strong, nonatomic) FWQAndADetailModel *model;
@property (strong, nonatomic) AnswerInfoListModel *aModel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@end

@implementation FWQDetailFCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWQDetailFCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWQDetailFCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWQDetailFCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
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
        [self.contentView addSubview:self.contentLab];
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
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeLab.mas_bottom).offset(10);
        make.left.equalTo(self.userName);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.typeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName);
        make.right.equalTo(self.contentLab);
        make.height.offset(95);
        make.top.equalTo(self.contentLab.mas_bottom).offset(15);
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

#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithModel:(FWQAndADetailModel *)model subModel:(AnswerInfoListModel *)aModel indexPath:(NSIndexPath*)indexPath
{
    self.model = model;
    self.aModel = aModel;
    self.indexPath = indexPath;
    if (indexPath.section == 0) {
        [self.userImg sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image_placeHolder80];
        self.userName.text = model.questionUser;
        self.timeLab.text = model.createTime;
        self.contentLab.text = model.questionContent;
        self.typeView.hidden = YES;
        [self.typeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userName);
            make.right.equalTo(self.contentLab);
            make.height.offset(0);
            make.top.equalTo(self.contentLab.mas_bottom).offset(15);
        }];
        
    }else{
        [self.userImg sd_setImageWithURL:URL(aModel.headUrl) placeholderImage:Image_placeHolder80];
        self.userName.text = aModel.answerUser;
        self.timeLab.text = aModel.answerTime;
        self.contentLab.text = aModel.answerContent;
//        [self durationWithVideo:URL(aModel.answerContent)];
        
        if (aModel.releaseGoodsDtoList.count>0) {
            self.typeView.hidden = NO;
            [self.typeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.userName);
                make.right.equalTo(self.contentLab);
                make.height.offset(95);
                make.top.equalTo(self.contentLab.mas_bottom).offset(15);
            }];
            [self.picView configViewWithPicArr:aModel.releaseGoodsDtoList];
        }else{
            self.typeView.hidden = YES;
            [self.typeView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.userName);
                make.right.equalTo(self.contentLab);
                make.height.offset(0);
                make.top.equalTo(self.contentLab.mas_bottom).offset(15);
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
//    DLog(@"------------>%ld",second);
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

- (UILabel*)contentLab
{
    if (_contentLab == nil) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.font = systemFont(14);
        _contentLab.textColor = Color_Black;
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
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
