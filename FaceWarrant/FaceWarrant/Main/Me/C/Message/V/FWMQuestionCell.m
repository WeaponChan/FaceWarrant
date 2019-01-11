//
//  FWMQuestionCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMQuestionCell.h"
#import "FWMessageAModel.h"
#import "UILabel+LhkhAttributeTextTapAction.h"
#import "LhkhLabel.h"
#import <AVFoundation/AVFoundation.h>
#import "FWPersonalHomePageVC.h"
@interface FWMQuestionCell ()<LhkhAttributeTextTapActionDelegate>
@property (nonatomic, strong) UIImageView *itemImg;
@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, strong) UIImageView *youImg;
@property (nonatomic, strong) UILabel *descLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) LhkhLabel *contentLab;
@property (nonatomic, strong) UIButton *spreadBtn;
@property (nonatomic, strong) FWMessageAModel *model;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UILabel *coverLabel;
@end

@implementation FWMQuestionCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMQuestionCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMQuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWMQuestionCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
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
        [self.contentView addSubview:self.spreadBtn];
        [self.contentView addSubview:self.headerBtn];
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
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.descLab.mas_left);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.timeLab.mas_bottom).offset(10);
        make.height.offset(30);
    }];
    
    [self.spreadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(0);
        make.height.offset(0);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.contentLab.mas_bottom).offset(5);
        make.bottom.equalTo(self.contentView).offset(-5);
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


- (void)imgClick
{
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.faceId = self.model.fromUserId;
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}


- (void)spreadClick
{
    if ([self.delegate respondsToSelector:@selector(FWMQuestionCellDelegatespreadClick:)]) {
        [self.delegate FWMQuestionCellDelegatespreadClick:self.indexPath];
    }
}

#pragma mark - Network requests




#pragma mark - Public Methods

+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithModel:(FWMessageAModel*)model indexPath:(NSIndexPath*)indexPath
{
    self.model = model;
    self.indexPath = indexPath;
    [self.itemImg sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image(@"contactHeader")];
    self.timeLab.text = model.createTime;
    self.contentLab.text = model.answerContent;
    
    float msgHeight = [self stringHeightWithString:model.answerContent size:12 maxWidth: Screen_W-30];
    if(msgHeight <=20){
        _contentLab.numberOfLines = 1;
        self.spreadBtn.hidden = YES;
        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.descLab.mas_left);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.timeLab.mas_bottom).offset(10);
            make.height.offset(30);
        }];
        [self.spreadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(0);
            make.height.offset(0);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.contentLab.mas_bottom).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
    }else{
        _contentLab.numberOfLines = 1;
       self.spreadBtn.hidden = NO;
        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.descLab.mas_left);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.timeLab.mas_bottom).offset(10);
            make.height.offset(30);
        }];
        [self.spreadBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.offset(20);
            make.height.offset(20);
            make.centerX.equalTo(self.contentView.mas_centerX);
            make.top.equalTo(self.contentLab.mas_bottom).offset(5);
            make.bottom.equalTo(self.contentView).offset(-5);
        }];
    }
    if (model.isSpread) {
        _contentLab.numberOfLines = 0;
        [self.spreadBtn setImage:Image(@"warrant_shang_gray") forState:UIControlStateNormal];
        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.descLab.mas_left);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.timeLab.mas_bottom).offset(10);
        }];
    }else{
        _contentLab.numberOfLines = 1;
        [self.spreadBtn setImage:Image(@"warrant_xia_gray") forState:UIControlStateNormal];
        [self.contentLab mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.descLab.mas_left);
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.timeLab.mas_bottom).offset(10);
            make.height.offset(30);
        }];
    }
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

//计算字符串高度
- (float)stringHeightWithString:(NSString *)string size:(CGFloat)fontSize maxWidth:(CGFloat)maxWidth
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil];
    
    float height = [string boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dic context:nil].size.height;
    return ceilf(height);
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

- (LhkhLabel *)contentLab
{
    if (_contentLab == nil) {
        _contentLab = [[LhkhLabel alloc] initWithFrame:CGRectZero];
        _contentLab.text = @"";
        _contentLab.backgroundColor = Color_MainBg;
        _contentLab.textColor = Color_SubText;
        _contentLab.font = systemFont(12);
        _contentLab.numberOfLines = 0;
        _contentLab.layer.cornerRadius = 5.f;
        _contentLab.layer.masksToBounds = YES;
        _contentLab.edgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    }
    return _contentLab;
}

- (UIButton *)headerBtn
{
    if (_headerBtn == nil) {
        _headerBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_headerBtn addTarget:self action:@selector(imgClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headerBtn;
}

- (UIButton *)spreadBtn
{
    if (_spreadBtn == nil) {
        _spreadBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_spreadBtn addTarget:self action:@selector(spreadClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _spreadBtn;
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
        _coverLabel.textColor = Color_White;
        _coverLabel.font = systemFont(14);
    }
    return _coverLabel;
}


#pragma mark - Getters



@end
