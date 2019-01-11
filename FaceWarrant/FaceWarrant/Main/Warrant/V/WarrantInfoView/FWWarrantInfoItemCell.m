//
//  FWWarrantInfoItemCell.m
//  FaceWarrant
//
//  Created by LHKH on 2018/7/24.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantInfoItemCell.h"
//限制最大字数
#define MAX_LIMIT_NUMS   50
@interface FWWarrantInfoItemCell ()<UITextFieldDelegate>
{
    NSInteger _remainingLen;
}
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UILabel *itemSubLab;
@property (strong, nonatomic)UIImageView *youImg;
@property (strong, nonatomic)UIView *shuView;
@property (strong, nonatomic)UITextField *textfield;
@end

@implementation FWWarrantInfoItemCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWWarrantInfoItemCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWWarrantInfoItemCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWWarrantInfoItemCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.itemSubLab];
        [self.contentView addSubview:self.youImg];
        [self.contentView addSubview:self.shuView];
        [self.contentView addSubview:self.textfield];
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
        make.width.offset(70);
    }];
    
    [self.shuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.itemLab.mas_right).offset(10);
        make.width.offset(1);
        make.height.offset(18);
        make.centerY.equalTo(self.itemLab.mas_centerY);
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
    
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.itemLab.mas_right).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.top.equalTo(self.contentView);
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

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    [self.textfield endEditing:YES];
    DLog(@"----->%@--%@",textField.text,self.textfield.text);
    if ([self.delegate respondsToSelector:@selector(FWWarrantInfoItemCellDelegate:)]) {
        [self.delegate FWWarrantInfoItemCellDelegate:self.textfield.text];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    DLog(@"----->%@--%@",textField.text,self.textfield.text);
    if ([self.delegate respondsToSelector:@selector(FWWarrantInfoItemCellDelegate:)]) {
        [self.delegate FWWarrantInfoItemCellDelegate:self.textfield.text];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.textfield) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > MAX_LIMIT_NUMS) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == self.textfield) {
        if (textField.text.length > MAX_LIMIT_NUMS) {
            textField.text = [textField.text substringToIndex:MAX_LIMIT_NUMS];
        }
    }
}

#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 44;
}

- (void)configCellWithBrand:(NSString*)brand bigSort:(NSString*)bigSort smallSort:(NSString*)smallSort name:(NSString*)name idinfo:(NSString*)idinfo IndexPath:(NSIndexPath*)indexPath
{
    self.youImg.hidden = NO;
    self.itemSubLab.hidden = NO;
    self.shuView.hidden = YES;
    self.textfield.hidden = YES;
    if (indexPath.row == 0) {
        self.itemLab.text = @"品牌";
        self.itemSubLab.text = brand;
    }else if (indexPath.row == 1){
        self.itemLab.text = @"大类";
        self.itemSubLab.text = bigSort;
    }else if (indexPath.row == 2){
        self.itemLab.text = @"小类";
        self.itemSubLab.text = smallSort;
    }else if (indexPath.row == 3){
        self.itemLab.text = @"名称";
        self.itemSubLab.text = name;
    }else if (indexPath.row == 4){
        self.itemLab.text = @"身份信息";
        self.textfield.text = idinfo;
        self.shuView.hidden = NO;
        self.youImg.hidden = YES;
        self.itemSubLab.hidden = YES;
        self.textfield.hidden = NO;
    }
}

#pragma mark - Private Methods


#pragma mark - Setters
- (UILabel*)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.text = @"品牌";
        _itemLab.textColor = Color_MainText;
        _itemLab.font = systemFont(16);
    }
    return _itemLab;
}

- (UILabel*)itemSubLab
{
    if (_itemSubLab == nil) {
        _itemSubLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemSubLab.text = @"测试测试";
        _itemSubLab.textColor = Color_SubText;
        _itemSubLab.textAlignment = NSTextAlignmentRight;
        _itemSubLab.font = systemFont(14);
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

- (UIView*)shuView
{
    if (_shuView == nil) {
        _shuView = [[UIView alloc] initWithFrame:CGRectZero];
        _shuView.backgroundColor = [UIColor colorWithHexString:@"#666666"];
    }
    return _shuView;
}

- (UITextField*)textfield
{
    if (_textfield == nil) {
        _textfield = [[UITextField alloc] initWithFrame:CGRectZero];
        _textfield.delegate = self;
        _textfield.placeholder = @"请输入您的身份信息";
        _textfield.textColor = Color_MainText;
        _textfield.textAlignment = NSTextAlignmentRight;
        _textfield.font = systemFont(14);
        [_textfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textfield;
}

#pragma mark - Getters


@end
