//
//  FWFaceValueDetailCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWFaceValueDetailCell.h"
#import "FWFaceValueCashItemModel.h"
@interface FWFaceValueDetailCell ()
@property (strong, nonatomic)UIImageView *itemImg;
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UILabel *timeLab;
@property (strong, nonatomic)UILabel *valueLab;
@end

@implementation FWFaceValueDetailCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWFaceValueDetailCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWFaceValueDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWFaceValueDetailCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.itemImg];
        [self.contentView addSubview:self.valueLab];
        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.timeLab];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    
    [self.itemImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(58);
        make.height.offset(24);
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.right.equalTo(self.contentView).offset(-10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.valueLab.mas_left).offset(-5);
        make.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.timeLab.mas_top).offset(-5);
        make.left.equalTo(self.itemImg.mas_right).offset(10);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.contentView).offset(10);
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
    return 80;
}


- (void)configCellWithModel:(FWFaceValueCashItemModel*)model type:(NSString*)type indexPath:(NSIndexPath *)indexPath
{
    FWAccountIncomeInfoListModel *mModel = [FWAccountIncomeInfoListModel mj_objectWithKeyValues:model.accountIncomeInfoList[indexPath.row]];
    
    if ([type isEqualToString:@"订单收入"]) {
        self.itemImg.hidden = NO;
        [self.itemImg sd_setImageWithURL:URL(mModel.brandUrl) placeholderImage:nil];
        self.itemLab.text = mModel.goodsName;
        [self.itemImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(58);
            make.height.offset(24);
            make.left.equalTo(self.contentView).offset(15);
            make.top.equalTo(self.contentView).offset(10);
        }];
        [self.itemLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.valueLab.mas_left).offset(-5);
            make.top.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.timeLab.mas_top).offset(-5);
            make.left.equalTo(self.itemImg.mas_right).offset(10);
        }];
    }else if ([type isEqualToString:@"邀请奖励"]){
        self.itemImg.hidden = YES;
        if (mModel.mobile.length > 6) {
//            self.itemLab.text = [NSString stringWithFormat:@"邀请好友%@获得奖励",mModel.mobile];
            NSRange range = {3,4};
            NSString *str = [mModel.mobile stringByReplacingCharactersInRange:range withString:@"****"];
            self.itemLab.text = [NSString stringWithFormat:@"邀请好友%@获得奖励",str];
        }
        
        [self.itemImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(0);
            make.height.offset(0);
            make.left.equalTo(self.contentView).offset(0);
            make.top.equalTo(self.contentView).offset(0);
        }];
        [self.itemLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.valueLab.mas_left).offset(-5);
            make.top.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.timeLab.mas_top).offset(-5);
            make.left.equalTo(self.contentView).offset(10);
        }];
    }else{
        self.itemImg.hidden = YES;
        self.itemLab.text = [NSString stringWithFormat:@"积分兑换脸值"];
        [self.itemImg mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.offset(0);
            make.height.offset(0);
            make.left.equalTo(self.contentView).offset(0);
            make.top.equalTo(self.contentView).offset(0);
        }];
        [self.itemLab mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.valueLab.mas_left).offset(-5);
            make.top.equalTo(self.contentView).offset(15);
            make.bottom.equalTo(self.timeLab.mas_top).offset(-5);
            make.left.equalTo(self.contentView).offset(10);
        }];
    }
    
    self.timeLab.text = mModel.createTime;
    self.valueLab.text = [NSString stringWithFormat:@"+%@",mModel.incomeFee];
    self.valueLab.textColor = [UIColor colorWithHexString:@"#1AD016"];
}

#pragma mark - Private Methods


#pragma mark - Setters

- (UIImageView*)itemImg
{
    if (_itemImg == nil) {
        _itemImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _itemImg.layer.borderColor = [UIColor colorWithHexString:@"#EEEEEE"].CGColor;
        _itemImg.layer.borderWidth = 1.f;
        _itemImg.image = Image(@"3");
    }
    return _itemImg;
}

//- (UILabel *)brandLab
//{
//    if (_brandLab == nil) {
//        _brandLab = [[UILabel alloc] initWithFrame:CGRectZero];
//        _brandLab.font = systemFont(16);
//        _brandLab.textColor = Color_MainText;
//        _brandLab.numberOfLines = 0;
//    }
//    return _brandLab;
//}

- (UILabel *)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.font = systemFont(16);
        _itemLab.textColor = Color_MainText;
        _itemLab.numberOfLines = 0;
    }
    return _itemLab;
}

- (UILabel *)timeLab
{
    if (_timeLab == nil) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLab.font = systemFont(12);
        _timeLab.textColor = Color_SubText;
    }
    return _timeLab;
}

- (UILabel *)valueLab
{
    if (_valueLab == nil) {
        _valueLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLab.font = systemFont(16);
        _valueLab.textColor = Color_MainText;
    }
    return _valueLab;
}

#pragma mark - Getters


@end
