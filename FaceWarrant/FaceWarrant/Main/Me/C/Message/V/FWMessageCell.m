//
//  FWMessageCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMessageCell.h"
#import "FWMessageModel.h"
@interface FWMessageCell ()
@property (strong, nonatomic)UIImageView *itemImg;
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UILabel *itemSubLab;
@property (strong, nonatomic)UIImageView *youImg;
@property (strong, nonatomic)NSArray *itemArr;
@end

@implementation FWMessageCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMessageCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWMessageCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.itemImg];
        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.itemSubLab];
        [self.contentView addSubview:self.youImg];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutCustomViews
{
    [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.height.offset(40);
    }];
    
    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.itemImg.mas_right).offset(10);
        make.top.bottom.equalTo(self.contentView);
        make.width.offset(120);
    }];
    
    [self.youImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(8);
        make.height.offset(14);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.itemSubLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.right.equalTo(self.youImg.mas_left).offset(-5);
        make.centerY.equalTo(self.contentView.mas_centerY);
        
    }];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = Color_MainBg;
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.left.right.bottom.equalTo(self.contentView);
    }];
}


#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response




#pragma mark - Network requests




#pragma mark - Public Methods

- (void)configCellWithModel:(FWMessageModel*)model indexPath:(NSIndexPath*)indexPath;
{
    self.itemSubLab.hidden = YES;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.itemLab.text = self.itemArr[0];
            self.itemImg.image = Image(@"me_answer-1");
            if (model.answerToMeCount != nil && ![model.answerToMeCount isEqualToString:@""] && ![model.answerToMeCount isEqualToString:@"0"] && ![model.answerToMeCount isKindOfClass:[NSNull class]]) {
                self.itemSubLab.hidden = NO;
                if (model.answerToMeCount.floatValue>99) {
                    [self.itemSubLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.height.offset(20);
                        make.width.offset(30);
                        make.right.equalTo(self.youImg.mas_left).offset(-5);
                        make.centerY.equalTo(self.contentView.mas_centerY);
                    }];
                    self.itemSubLab.text = @"99+";
                }else{
                    self.itemSubLab.text = model.answerToMeCount;
                }
            }
        }else if (indexPath.row == 1){
            self.itemLab.text = self.itemArr[1];
            self.itemImg.image = Image(@"me_question-1");
            if (model.questionToMeCount != nil && ![model.questionToMeCount isEqualToString:@""] && ![model.questionToMeCount isEqualToString:@"0"] && ![model.questionToMeCount isKindOfClass:[NSNull class]]) {
                self.itemSubLab.hidden = NO;
                if (model.questionToMeCount.floatValue>99) {
                    [self.itemSubLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.height.offset(20);
                        make.width.offset(30);
                        make.right.equalTo(self.youImg.mas_left).offset(-5);
                        make.centerY.equalTo(self.contentView.mas_centerY);
                    }];
                    self.itemSubLab.text = @"99+";
                }else{
                    self.itemSubLab.text = model.questionToMeCount;
                }
            }
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            self.itemLab.text = self.itemArr[2];
            self.itemImg.image = Image(@"me_shanglian");
            if (model.favoriteNewCount != nil && ![model.favoriteNewCount isEqualToString:@""] && ![model.favoriteNewCount isEqualToString:@"0"] && ![model.favoriteNewCount isKindOfClass:[NSNull class]]) {
                self.itemSubLab.hidden = NO;
                if (model.favoriteNewCount.floatValue>99) {
                    [self.itemSubLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.height.offset(20);
                        make.width.offset(30);
                        make.right.equalTo(self.youImg.mas_left).offset(-5);
                        make.centerY.equalTo(self.contentView.mas_centerY);
                    }];
                    self.itemSubLab.text = @"99+";
                }else{
                    self.itemSubLab.text = model.favoriteNewCount;
                }
            }
        }else if (indexPath.row == 1){
            self.itemLab.text = self.itemArr[3];
            self.itemImg.image = Image(@"me_zan");
            if (model.likeNewCount != nil && ![model.likeNewCount isEqualToString:@""] && ![model.likeNewCount isEqualToString:@"0"] && ![model.likeNewCount isKindOfClass:[NSNull class]]) {
                self.itemSubLab.hidden = NO;
                if (model.likeNewCount.floatValue>99) {
                    [self.itemSubLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.height.offset(20);
                        make.width.offset(30);
                        make.right.equalTo(self.youImg.mas_left).offset(-5);
                        make.centerY.equalTo(self.contentView.mas_centerY);
                    }];
                    self.itemSubLab.text = @"99+";
                }else{
                    self.itemSubLab.text = model.likeNewCount;
                }
            }
        }else if (indexPath.row == 2){
            self.itemLab.text = self.itemArr[4];
            self.itemImg.image = Image(@"me_xinyuan");
            if (model.collectionCount != nil && ![model.collectionCount isEqualToString:@""] && ![model.collectionCount isEqualToString:@"0"] && ![model.collectionCount isKindOfClass:[NSNull class]]) {
                self.itemSubLab.hidden = NO;
                if (model.collectionCount.floatValue>99) {
                    [self.itemSubLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.height.offset(20);
                        make.width.offset(30);
                        make.right.equalTo(self.youImg.mas_left).offset(-5);
                        make.centerY.equalTo(self.contentView.mas_centerY);
                    }];
                    self.itemSubLab.text = @"99+";
                }else{
                    self.itemSubLab.text = model.collectionCount;
                }
            }
        }else if (indexPath.row == 3){
            self.itemLab.text = self.itemArr[5];
            self.itemImg.image = Image(@"me_atten");
            if (model.attentionNewCount != nil && ![model.attentionNewCount isEqualToString:@""] && ![model.attentionNewCount isEqualToString:@"0"] && ![model.attentionNewCount isKindOfClass:[NSNull class]]) {
                self.itemSubLab.hidden = NO;
                if (model.attentionNewCount.floatValue>99) {
                    [self.itemSubLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.height.offset(20);
                        make.width.offset(30);
                        make.right.equalTo(self.youImg.mas_left).offset(-5);
                        make.centerY.equalTo(self.contentView.mas_centerY);
                    }];
                    self.itemSubLab.text = @"99+";
                }else{
                    self.itemSubLab.text = model.attentionNewCount;
                }
            }
        }else if (indexPath.row == 4){
            self.itemLab.text = self.itemArr[6];
            self.itemImg.image = Image(@"me_comment");
            if (model.commendNewCount != nil && ![model.commendNewCount isEqualToString:@""] && ![model.commendNewCount isEqualToString:@"0"] && ![model.commendNewCount isKindOfClass:[NSNull class]]) {
                self.itemSubLab.hidden = NO;
                if (model.commendNewCount.floatValue>99) {
                    [self.itemSubLab mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.height.offset(20);
                        make.width.offset(30);
                        make.right.equalTo(self.youImg.mas_left).offset(-5);
                        make.centerY.equalTo(self.contentView.mas_centerY);
                    }];
                    self.itemSubLab.text = @"99+";
                }else{
                    self.itemSubLab.text = model.commendNewCount;
                }
            }
        }
    }
}


#pragma mark - Private Methods




#pragma mark - Setters

- (UIImageView*)itemImg
{
    if (_itemImg == nil) {
        _itemImg = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _itemImg;
}

- (UILabel*)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.text = @"小猪佩奇";
        _itemLab.textColor = Color_MainText;
        _itemLab.font = systemFont(16);
    }
    return _itemLab;
}

- (UILabel*)itemSubLab
{
    if (_itemSubLab == nil) {
        _itemSubLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemSubLab.layer.cornerRadius = 10.f;
        _itemSubLab.layer.masksToBounds = YES;
        _itemSubLab.backgroundColor = [UIColor redColor];
        _itemSubLab.textColor = Color_White;
        _itemSubLab.textAlignment = NSTextAlignmentCenter;
        _itemSubLab.font = systemFont(10);
    }
    return _itemSubLab;
}

- (UIImageView*)youImg
{
    if (_youImg == nil) {
        _youImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _youImg.image = [UIImage imageNamed:@"you"];
    }
    return _youImg;
}

- (NSArray*)itemArr
{
    if (_itemArr == nil) {
        _itemArr = @[@"回答我的",@"对我提问",@"赏脸",@"点赞",@"心愿单",@"关注",@"评论"];
    }
    return _itemArr;
}

#pragma mark - Getters



@end
