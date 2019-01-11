//
//  FWWarrantExperienceCell.m
//  FaceWarrant
//
//  Created by LHKH on 2018/7/24.
//  Copyright © 2018年 LHKH. All rights reserved.
//

//限制最大字数
#define MAX_LIMIT_NUMS   200
#import "FWWarrantExperienceCell.h"
#import "LhkhIFlyMSCManager.h"
@interface FWWarrantExperienceCell ()<UITextViewDelegate,UIGestureRecognizerDelegate>
{
    NSInteger _remainingLen;
    NSString *_content;
}
@property (nonatomic, strong) UILabel *itemLab;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UILabel *tipsLB;
@property (nonatomic, strong) UILabel *numberLB;

@end

@implementation FWWarrantExperienceCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWWarrantExperienceCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWWarrantExperienceCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWWarrantExperienceCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.textView];
        [self.contentView addSubview:self.tipsLB];
        [self.contentView addSubview:self.numberLB];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutCustomViews
{
    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.contentView).offset(10);
        make.top.equalTo(self.contentView).offset(10);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.itemLab.mas_bottom).offset(10);
        make.left.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
        make.height.offset(100);
    }];
    
    [self.tipsLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView).offset(10);
        make.left.equalTo(self.textView).offset(10);
        make.right.equalTo(self.textView).offset(-10);
        make.height.offset(15);
    }];
    
    
    [self.numberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textView).offset(-10);
        make.right.equalTo(self.textView).offset(-10);
        make.height.offset(15);
    }];
    
    UIButton *micBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [micBtn setBackgroundImage:[UIImage imageNamed:@"warrant_yuyin"] forState:UIControlStateNormal];
    [micBtn addTarget:self action:@selector(micClick) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:micBtn];
    
    [micBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(15);
        make.height.offset(21);
        make.right.equalTo(self.numberLB.mas_left).offset(-15);
        make.bottom.equalTo(self.textView).offset(-10);
    }];
}


#pragma mark - System Delegate
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length > 0) {
        self.tipsLB.hidden = YES;
    }else {
        self.tipsLB.hidden = NO;
    }
    
    if (textView == self.textView) {
        if (textView.text.length > MAX_LIMIT_NUMS) {
            textView.text = [textView.text substringToIndex:MAX_LIMIT_NUMS];
        }
    }
    self.numberLB.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,(long)textView.text.length),MAX_LIMIT_NUMS];
    DLog(@"--6666-->%@",textView.text);
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == self.textView) {
        if (text.length == 0) return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > MAX_LIMIT_NUMS) {
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    DLog(@"---->%@",textView.text);
    if (![textView.text isEqual: self.textView.text]) {
        if ([self.delegate respondsToSelector:@selector(FWWarrantExperienceCellDelegateText:)]) {
            [self.delegate FWWarrantExperienceCellDelegateText:textView.text];
        }
    }
    [USER_DEFAULTS setObject:self.textView.text forKey:@"experience"];
}

#pragma mark - Custom Delegate


#pragma mark - Event Response
- (void)micClick
{
    DLog(@"mic");
    if ([self.delegate respondsToSelector:@selector(FWWarrantExperienceCellDelegateMicCkick)]) {
        [self.delegate FWWarrantExperienceCellDelegateMicCkick];
    }
}

#pragma mark - Network requests


#pragma mark - Public Methods
+ (CGFloat)cellHeight
{
    return 150;
}

- (void)cellConfigWithExperience:(NSString *)experience indexPath:(NSIndexPath*)indexPath
{
    if (self.textView.text.length>0) {
        self.textView.text = [NSString stringWithFormat:@"%@%@",self.textView.text,experience];
    }else{
        self.textView.text = experience;
    }
    self.tipsLB.hidden = self.textView.text.length>0?YES:NO;
    [USER_DEFAULTS setObject:self.textView.text forKey:@"experience"];
}


#pragma mark - Private Methods


#pragma mark - Setters

- (UILabel*)itemLab
{
    if (!_itemLab) {
        _itemLab = [[UILabel alloc]initWithFrame:CGRectZero];
        _itemLab.text = @"我的体验(必填)";
        _itemLab.textColor = Color_MainText;
        _itemLab.font = systemFont(14);
    }
    return _itemLab;
}

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = Color_MainBg;
        _textView.font = systemFont(14);
        _textView.delegate = self;
        // 使用textContainerInset设置top、left、right
        _textView.textContainerInset = UIEdgeInsetsMake(10, 0, 0, 00);
        //当光标在最后一行时，始终显示低边距，需使用contentInset设置bottom.
        _textView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        if (_content.length > 0) {
            _textView.text  =  _content;
            self.tipsLB.hidden = YES;
            self.numberLB.text = [NSString stringWithFormat:@"%ld/%d",(unsigned long)_content.length,MAX_LIMIT_NUMS];
        }
        
    }
    return _textView;
}


- (UILabel *)tipsLB
{
    if (!_tipsLB) {
        _tipsLB = [[UILabel alloc] init];
        _tipsLB.text = @"如果你无法简洁的表达你的想法，那只说明你还不够了解它";
        _tipsLB.textColor = Color_SubText;
        _tipsLB.font  = systemFont(12);
    }
    return _tipsLB;
}

- (UILabel *)numberLB
{
    if (!_numberLB) {
        _numberLB = [[UILabel alloc] init];
        _numberLB.text = @"0/200";
        _numberLB.textColor = Color_SubText;
        _numberLB.font  = systemFont(12);
        _numberLB.textAlignment = NSTextAlignmentRight;
    }
    return _numberLB;
}

#pragma mark - Getters


@end
