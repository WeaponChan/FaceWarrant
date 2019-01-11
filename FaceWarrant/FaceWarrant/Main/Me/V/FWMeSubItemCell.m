//
//  FWMeSubItemCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMeSubItemCell.h"

@interface FWMeSubItemCell ()
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UILabel *itemSubLab;
@property (strong, nonatomic)UIImageView *youImg;
@end

@implementation FWMeSubItemCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMeSubItemCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMeSubItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWMeSubItemCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
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
    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
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
        make.right.equalTo(self.youImg.mas_left).offset(-5);
        make.top.bottom.equalTo(self.contentView);
        
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
    return 44;
}

- (void)configCellWithIndexPath:(NSIndexPath*)indexPath item:(NSString*)item vcType:(NSString*)vcType
{
    self.itemSubLab.hidden = YES;
    if ([vcType isEqualToString:@"账户与安全"]){
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                self.itemLab.text = @"手机号码";
            }else{
                self.itemLab.text = @"修改密码";
            }
        }
//        else{
//            if (indexPath.row == 0) {
//                self.itemLab.text = @"账号绑定";
//            }
//        }
    }else if([vcType isEqualToString:@"我的脸值"]){
        if (indexPath.row == 0) {
            self.itemLab.text = @"订单";
        }else if(indexPath.row == 1){
            self.itemLab.text = @"邀请奖励";
        }else{
            self.itemLab.text = @"积分兑换";
        }
    }else{
        if (indexPath.section == 0) {
            if (indexPath.row == 1) {
                self.itemLab.text = @"账号与安全";
            }
        }else if(indexPath.section == 1 ){
            self.itemSubLab.hidden = NO;
            if (item.floatValue == 0) {
                self.itemSubLab.text = @"0M";
            }else{
                self.itemSubLab.text = StringConnect(item, @"M");
            }
            
            self.itemLab.text = @"清除缓存";
        }else{
            if (indexPath.row == 0) {
                self.itemLab.text = @"意见反馈";
            }else{
                self.itemSubLab.hidden = NO;
                self.itemLab.text = @"检查更新";
                NSString *versionValueStringForSystemNow = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
                self.itemSubLab.text = StringConnect(@"V", versionValueStringForSystemNow);
            }
        }
    }
}

#pragma mark - Private Methods


#pragma mark - Setters
- (UILabel*)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.text = @"小猪佩奇";
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
        _itemSubLab.textColor = Color_SubText;
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
