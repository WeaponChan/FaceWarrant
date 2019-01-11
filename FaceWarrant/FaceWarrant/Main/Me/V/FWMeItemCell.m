//
//  FWMeItemCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMeItemCell.h"
#import "FWMeInfoModel.h"
@interface FWMeItemCell ()
@property (strong, nonatomic)UIImageView *itemImg;
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UILabel *itemSubLab;
@property (strong, nonatomic)UIImageView *youImg;

@end

@implementation FWMeItemCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMeItemCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMeItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWMeItemCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
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
        make.width.height.offset(20);
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
        make.height.offset(20);
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

+ (CGFloat)cellHeight
{
    return 50;
}

- (void)configCellWithIndexPath:(NSIndexPath*)indexPath item:(FWMeInfoModel*)item vcType:(NSString*)vcType
{
    self.itemSubLab.hidden = YES;
    if ([vcType isEqualToString:@"我要提现"]) {
        if (indexPath.section == 0) {
            self.itemLab.text = @"提现到支付宝";
            self.itemImg.image = Image(@"me_zfb");
            
        }else{
            self.itemLab.text = @"提现到银行卡";
            self.itemImg.image = Image(@"me_unionpay");
        }
    }else{
        if (indexPath.section == 2) {
            if (indexPath.row == 0) {
                self.itemLab.text = @"我的消息";
                self.itemImg.image = Image(@"me_message");
                if (item.messageCount != nil && ![item.messageCount isEqualToString:@""] && ![item.messageCount isKindOfClass:[NSNull class]] && item.messageCount.floatValue>0) {
                    self.itemSubLab.hidden = NO;
                    self.itemSubLab.text = 0;
                    [self.itemSubLab mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.width.height.offset(10);
                        make.right.equalTo(self.youImg.mas_left).offset(-5);
                        make.centerY.equalTo(self.contentView.mas_centerY);
                    }];
                    self.itemSubLab.backgroundColor = [UIColor redColor];
                    self.itemSubLab.textAlignment = NSTextAlignmentCenter;
                    self.itemSubLab.layer.cornerRadius = 5.f;
                    self.itemSubLab.layer.masksToBounds = YES;
                }
                
            }else if(indexPath.row ==1){
                self.itemLab.text = @"我的提问";
                self.itemImg.image = Image(@"me_question");
            }else{
                self.itemLab.text = @"我的回答";
                self.itemImg.image = Image(@"me_answer");
            }
        }else if (indexPath.section == 3) {
            NSString *isShow = [USER_DEFAULTS objectForKey:UD_IsShowBuy];
            if ([isShow isEqualToString:@"1"]) {
                if (indexPath.row == 0){
                    self.itemLab.text = @"Face群管理";
                    self.itemImg.image = Image(@"me_group");
                }else if (indexPath.row == 1) {
                    self.itemLab.text = @"设置";
                    self.itemImg.image = Image(@"me_setting");
                }else{
                    self.itemLab.text = @"关于我们";
                    self.itemImg.image = Image(@"me_about");
                }
            }else{
                if (indexPath.row == 0) {
                    self.itemLab.text = @"邀请好友";
                    self.itemImg.image = Image(@"me_invite");
                }else if (indexPath.row == 1){
                    self.itemLab.text = @"Face群管理";
                    self.itemImg.image = Image(@"me_group");
                }else if (indexPath.row == 2) {
                    self.itemLab.text = @"设置";
                    self.itemImg.image = Image(@"me_setting");
                }else{
                    self.itemLab.text = @"关于我们";
                    self.itemImg.image = Image(@"me_about");
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
        _itemLab.textColor = Color_MainText;
        _itemLab.font = systemFont(14);
    }
    return _itemLab;
}

- (UILabel*)itemSubLab
{
    if (_itemSubLab == nil) {
        _itemSubLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemSubLab.text = @"0kB";
        _itemSubLab.textColor = Color_White;
        _itemSubLab.textAlignment = NSTextAlignmentRight;
        _itemSubLab.font = systemFont(12);
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


#pragma mark - Getters



@end
