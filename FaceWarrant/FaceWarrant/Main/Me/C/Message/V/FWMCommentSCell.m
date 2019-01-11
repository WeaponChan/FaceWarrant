//
//  FWMCommentSCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/5.
//  Copyright © 2018年 LHKH. All rights reserved.
//
// 回复的
#import "FWMCommentSCell.h"
#import "FWMessageAModel.h"
#import "FWCommentListVC.h"
#import "FWWarrantDetailVC.h"
#import "FWMessageManager.h"
#import "FWPersonalHomePageVC.h"

@interface FWMCommentSCell ()
@property (nonatomic, strong) UIImageView *userImg;
@property (nonatomic, strong) UIImageView *contentImg;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *replyLab;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UILabel *timeLab;
@property (nonatomic, strong) UIButton *imgBtn;
@property (nonatomic, strong) UIButton *contentBtn;
@property (nonatomic, strong) UIButton *contentImgBtn;
@property (nonatomic, strong) UIImageView *youImg;
@property (nonatomic, strong) FWMessageAModel *model;
@end

@implementation FWMCommentSCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMCommentSCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMCommentSCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWMCommentSCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.userImg];
        [self.contentView addSubview:self.userName];
        [self.contentView addSubview:self.typeLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.replyLab];
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.contentLab];
        [self.bgView addSubview:self.contentImg];
        [self.contentView addSubview:self.imgBtn];
        [self.bgView addSubview:self.contentBtn];
        [self.bgView addSubview:self.contentImgBtn];
        [self.contentView addSubview:self.youImg];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutCustomViews
{
    [self.userImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(35);
        make.left.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.imgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.userImg);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.top.equalTo(self.contentView).offset(10);
        make.left.equalTo(self.userImg.mas_right).offset(10);
    }];
    
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.left.equalTo(self.userName.mas_right).offset(5);
        make.centerY.equalTo(self.userName.mas_centerY);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.left.equalTo(self.userName.mas_left);
        make.top.equalTo(self.userName.mas_bottom).offset(5);
    }];
    
    [self.replyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName.mas_left);
        make.top.equalTo(self.timeLab.mas_bottom).offset(5);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(65);
        make.left.equalTo(self.userName.mas_left);
        make.top.equalTo(self.replyLab.mas_bottom).offset(5);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-10);
    }];
    
    [self.contentImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(65);
        make.top.right.bottom.equalTo(self.bgView);
    }];
    
    [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.bgView).offset(10);
        make.bottom.equalTo(self.bgView).offset(-10);
        make.right.equalTo(self.contentImg.mas_left).offset(-10);
    }];
    
    [self.contentImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.top.right.bottom.equalTo(self.contentImg);
    }];
    
    [self.contentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bgView).offset(10);
        make.top.equalTo(self.bgView).offset(10);
        make.right.equalTo(self.contentImg.mas_left).offset(-10);
        make.bottom.equalTo(self.bgView).offset(-10);
    }];
    
    [self.youImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(10);
        make.height.offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(15);
    }];
}



#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response

- (void)contentClick
{
    if ([self.model.releaseGoodsStatus isEqualToString:@"0"]) {
        [MBProgressHUD showTips:@"此碑它已被删除了额"];
    }else{
        FWCommentListVC *vc = [FWCommentListVC new];
        vc.releaseGoodsId = self.model.releaseGoodsId;
        [[self superViewController:self].navigationController pushViewController:vc animated:YES];
        
        [self readedMessage];
    }
}

- (void)contentImgClick
{
    if ([self.model.releaseGoodsStatus isEqualToString:@"0"]) {
        [MBProgressHUD showTips:@"此碑它已被删除了额"];
    }else{
        FWWarrantDetailVC *vc = [[FWWarrantDetailVC alloc] init];
        vc.releaseGoodsId = self.model.releaseGoodsId;
        vc.isNew = @"0";
        [[self superViewController:self].navigationController pushViewController:vc animated:YES];
        
        [self readedMessage];
    }
}

- (void)imgClick
{
    FWPersonalHomePageVC *vc = [FWPersonalHomePageVC new];
    vc.faceId = self.model.fromUserId;
    [[self superViewController:self].navigationController pushViewController:vc animated:NO];
}


#pragma mark - Network requests

- (void)readedMessage
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"messageId":self.model.messageId?:@"",
                            @"type":@"1"
                            };
    [FWMessageManager readedMessageWithParameters:param result:^(id response) {
        
    }];
}


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithModel:(FWMessageAModel*)model
{
    self.model = model;
    [self.userImg sd_setImageWithURL:URL(model.headUrl) placeholderImage:Image_placeHolder80];
    self.userName.text = model.fromUser;
    self.typeLab.text = @"回复了我的评论";
    self.timeLab.text = model.createTime;
    self.replyLab.text = model.replyContent;
    [self.contentImg sd_setImageWithURL:URL(model.modelUrl) placeholderImage:nil];
    self.contentLab.text = model.commentContent;
    if ([model.status isEqualToString:@"0"]) {
        self.youImg.hidden = NO;
    }else{
        self.youImg.hidden = YES;
    }
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

- (UIImageView*)userImg
{
    if (_userImg == nil) {
        _userImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _userImg.contentMode = UIViewContentModeScaleAspectFill;
        _userImg.layer.cornerRadius = 35/2;
        _userImg.layer.masksToBounds = YES;
    }
    return _userImg;
}

- (UILabel *)userName
{
    if (_userName == nil) {
        _userName = [[UILabel alloc] initWithFrame:CGRectZero];
        _userName.textColor = [UIColor colorWithHexString:@"999999"];
        _userName.font = systemFont(14);
    }
    return _userName;
}

- (UILabel *)typeLab
{
    if (_typeLab == nil) {
        _typeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLab.textColor = [UIColor colorWithHexString:@"333333"];
        _typeLab.font = systemFont(12);
    }
    return _typeLab;
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

- (UILabel *)replyLab
{
    if (_replyLab == nil) {
        _replyLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _replyLab.textColor = [UIColor colorWithHexString:@"333333"];
        _replyLab.font = systemFont(12);
        _replyLab.numberOfLines = 0;
    }
    return _replyLab;
}


- (UIView*)bgView
{
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = Color_MainBg;
    }
    return _bgView;
}

- (UIImageView*)contentImg
{
    if (_contentImg == nil) {
        _contentImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _contentImg;
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

- (UIButton*)contentBtn
{
    if (_contentBtn == nil) {
        _contentBtn = [[UIButton alloc]init];
        [_contentBtn addTarget:self action:@selector(contentClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contentBtn;
}

- (UIButton*)contentImgBtn
{
    if (_contentImgBtn == nil) {
        _contentImgBtn = [[UIButton alloc]init];
        [_contentImgBtn addTarget:self action:@selector(contentImgClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contentImgBtn;
}

- (UIImageView*)youImg
{
    if (_youImg == nil) {
        _youImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _youImg.image = [UIImage imageNamed:@"red_dot"];
    }
    return _youImg;
}

- (UIButton*)imgBtn
{
    if (_imgBtn == nil) {
        _imgBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_imgBtn addTarget:self action:@selector(imgClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _imgBtn;
}
#pragma mark - Getters



@end
