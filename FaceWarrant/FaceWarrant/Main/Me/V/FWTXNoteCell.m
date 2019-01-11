//
//  FWTXNoteCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/18.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWTXNoteCell.h"
#import "FWFaceValueNoteModel.h"
@interface FWTXNoteCell ()
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UILabel *timeLab;
@property (strong, nonatomic)UILabel *valueLab;
@property (strong, nonatomic)UILabel *statusLab;
@end

@implementation FWTXNoteCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWTXNoteCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWTXNoteCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWTXNoteCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.valueLab];
        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.statusLab];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    
    [self.valueLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(30);
        make.right.equalTo(self.contentView).offset(-10);
        make.top.equalTo(self.contentView).offset(15);
    }];
    
    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.valueLab.mas_left).offset(-5);
        make.top.equalTo(self.contentView).offset(15);
        make.bottom.equalTo(self.timeLab.mas_top).offset(-5);
        make.left.equalTo(self.contentView).offset(10);
    }];
    
    [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.bottom.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.contentView).offset(10);
    }];
    
    [self.statusLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.contentView).offset(-15);
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

- (void)configCellWithModel:(FWFaceValueNoteModel*)model indexPath:(NSIndexPath*)indexPath
{
    FWAccountExpendListModel *mModel = [FWAccountExpendListModel mj_objectWithKeyValues:model.accountExpendList[indexPath.row]];
    if ([mModel.expendType isEqualToString:@"0"]) {
        if (![mModel.bankAccountNumber isKindOfClass:[NSNull class]] && mModel.bankAccountNumber != nil && mModel.bankAccountNumber.length>4) {
            NSString *str = [mModel.bankAccountNumber substringFromIndex:mModel.bankAccountNumber.length-4];
            self.itemLab.text = [NSString stringWithFormat:@"%@(尾号%@)",mModel.bankName,str];
        }
    }else{
        NSRange range={3,4};
        if (![mModel.bankAccountNumber isKindOfClass:[NSNull class]] && mModel.bankAccountNumber != nil && mModel.bankAccountNumber.length>6) {
            NSString *str = [mModel.bankAccountNumber stringByReplacingCharactersInRange:range withString:@"****"];
            self.itemLab.text = [NSString stringWithFormat:@"支付宝(%@)",str];
        }
    }
    self.timeLab.text = mModel.withdrawalsTime;
    self.valueLab.text = mModel.withdrawFee;
    if ([mModel.status isEqualToString:@"0"]) {
        self.statusLab.text = @"提现失败";
        self.statusLab.textColor = [UIColor colorWithHexString:@"#EB0404"];
    }else if ([mModel.status isEqualToString:@"1"]){
        self.statusLab.text = @"提现成功";
        self.statusLab.textColor = [UIColor colorWithHexString:@"#1AD016"];
    }else{
        self.statusLab.text = @"提现中";
        self.statusLab.textColor = [UIColor colorWithHexString:@"#FE9F25"];
    }
}

#pragma mark - Private Methods


#pragma mark - Setters
- (UILabel *)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.text = @"****";
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
        _timeLab.text = @"2018-07-18";
        _timeLab.font = systemFont(12);
        _timeLab.textColor = Color_SubText;
    }
    return _timeLab;
}

- (UILabel *)valueLab
{
    if (_valueLab == nil) {
        _valueLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _valueLab.text = @"1000";
        _valueLab.font = systemFont(16);
        _valueLab.textColor = Color_MainText;
    }
    return _valueLab;
}

- (UILabel *)statusLab
{
    if (_statusLab == nil) {
        _statusLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLab.text = @"提现中";
        _statusLab.font = systemFont(12);
        _statusLab.textColor = Color_SubText;
    }
    return _statusLab;
}

#pragma mark - Getters


@end
