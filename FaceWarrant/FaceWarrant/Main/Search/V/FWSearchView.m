//
//  FWSearchView.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWSearchView.h"
#import "FWSearchVC.h"
#import "FWWindowManager.h"
@interface FWSearchView()<UITextFieldDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIButton *btn;

@end

@implementation FWSearchView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        DLog(@"%@",NSStringFromCGRect(frame));
        self.layer.cornerRadius = 15.f;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.searchText];
        [self addSubview:self.imageView];
        [self addSubview:self.btn];
        [self addSubview:self.clickBtn];
        [self layoutCustomViews];
        
    }
    return self;
}



#pragma mark - Layout SubViews

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(Screen_W-40, 30);
}

- (void)layoutCustomViews
{
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(20);
        make.left.equalTo(self).offset(5);
        make.centerY.equalTo(self);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.offset(20);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-5);
    }];
    
    [self.searchText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.left.equalTo(self.btn.mas_right).offset(5);
        make.right.equalTo(self.imageView.mas_left).offset(-5);
        make.centerY.equalTo(self);
    }];
    
    [self.clickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn.mas_right).offset(5);
        make.top.bottom.right.equalTo(self);
    }];
}


#pragma mark - System Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(FWSearchViewDelegateWithTextViewBeginEditing)]) {
        [self.delegate FWSearchViewDelegateWithTextViewBeginEditing];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    DLog(@"--%@--->%@---%@",self.searchText.text,textField.text,string);
    if (string.length == 0 && textField.text.length == 0) {
        if ([self.delegate respondsToSelector:@selector(FWSearchViewDelegateWithText:)]) {
            [self.delegate FWSearchViewDelegateWithText:textField.text];
        }
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(FWSearchViewDelegateWithText:)]) {
        [self.delegate FWSearchViewDelegateWithText:textField.text];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(FWSearchViewDelegateWithText:)]) {
        [self.delegate FWSearchViewDelegateWithText:@""];
    }
    return YES;
}

#pragma mark - Custom Delegate




#pragma mark - Event Response

- (void)btnClick
{
//    if ([self.delegate respondsToSelector:@selector(FWSearchViewDelegateBtnClick)]) {
//        [self.delegate FWSearchViewDelegateBtnClick];
//    }
    
    if (![self.vcStr isEqualToString:@"FWSearchVC"]) {
        
        FWSearchVC *vc = [FWSearchVC new];
        vc.typeStr = self.vcStr;
        vc.index = self.index;
//        [[self superViewController:self].navigationController pushViewController:vc animated:NO];
        [[FWWindowManager sharedWindow] showVC:vc];
        
    }
}

- (void)yuyinClick
{
    if ([self.delegate respondsToSelector:@selector(FWSearchViewDelegateVoiceClick)]) {
        [self.delegate FWSearchViewDelegateVoiceClick];
        if ([self.vcStr isEqualToString:@"FWSearchVC"] || [self.vcStr isEqualToString:@"FWFaceLibrarySearchVC"] || [self.vcStr isEqualToString:@"FWBrandVC"]  || [self.vcStr isEqualToString:@"FWAddAttentionVC"]  || [self.vcStr isEqualToString:@"FWHashListVC"]) {
            
        }else{
            FWSearchVC *vc = [FWSearchVC new];
            vc.typeStr = self.vcStr;
            vc.yuyinType = @"1";
            vc.index = self.index;
//            [[self superViewController:self].navigationController pushViewController:vc animated:NO];
             [[FWWindowManager sharedWindow] showVC:vc];
        }
    }
}

#pragma mark - Network requests




#pragma mark - Public Methods




#pragma mark - Private Methods

- (UIViewController *)superViewController:(UIView *)view
{
    UIResponder *next = [self nextResponder];
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = [next nextResponder];
    } while (next != nil);
    return nil;
}


#pragma mark - Setters

- (LhkhTextField*)searchText
{
    if (_searchText == nil) {
        _searchText = [[LhkhTextField alloc] initWithFrame:CGRectZero];
        _searchText.delegate = self;
        _searchText.font = systemFont(12);
        _searchText.placeholder = @"请输入要搜索的Face、品牌、用品";
        _searchText.textAlignment = NSTextAlignmentLeft;
        _searchText.returnKeyType = UIReturnKeySearch;
        _searchText.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _searchText;
}

- (UIImageView *)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.image = [UIImage imageNamed:@"search"];
    }
    return _imageView;
}

- (UIButton *)btn
{
    if (_btn == nil) {
        _btn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btn setBackgroundImage:[UIImage imageNamed:@"search_yuyin"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(yuyinClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (UIButton *)clickBtn
{
    if (_clickBtn == nil) {
        _clickBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_clickBtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _clickBtn;
}

#pragma mark - Getters



@end
