//
//  LhkhTextField.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

static NSString * const LhkhPlacerholderColorKeyPath = @"_placeholderLabel.textColor";
#import "LhkhTextField.h"

@interface LhkhTextField()

@end

@implementation LhkhTextField

#pragma mark - Life Cycle

//通过xib创建
- (void)awakeFromNib
{
    [super awakeFromNib];
    //获取焦点颜色 默认为textField用户输入的文字颜色
    _placeHolderHeightLightColor = self.textColor;
    //失去焦点颜色
    _placeHolderNormalColor = [UIColor colorWithHexString:@"b5b6b6"] ;
    [self setValue:_placeHolderNormalColor forKeyPath:LhkhPlacerholderColorKeyPath];
    //光标颜色
    self.tintColor = self.textColor;
    //字体大小
    self.font = [UIFont systemFontOfSize:14];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //获取焦点颜色 默认为textField用户输入的文字颜色
        _placeHolderHeightLightColor = self.textColor;
        //失去焦点颜色
        _placeHolderNormalColor = [UIColor colorWithHexString:@"b5b6b6"] ;
        [self setValue:_placeHolderNormalColor forKeyPath:LhkhPlacerholderColorKeyPath];
        self.tintColor = self.textColor;
        self.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        //获取焦点颜色 默认为textField用户输入的文字颜色
        _placeHolderHeightLightColor = self.textColor;
        //失去焦点颜色
        _placeHolderNormalColor = [UIColor colorWithHexString:@"b5b6b6"] ;
        [self setValue:_placeHolderNormalColor forKeyPath:LhkhPlacerholderColorKeyPath];
        self.tintColor = self.textColor;
        self.font = [UIFont systemFontOfSize:14];
    }
    return self;
}

#pragma mark - Layout SubViews




#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response




#pragma mark - Network requests




#pragma mark - Public Methods




#pragma mark - Private Methods

//自定义获取焦点的颜色
- (void)setPlaceHolderHeightLightColor:(UIColor *)placeHolderHeightLightColor
{
    _placeHolderHeightLightColor = placeHolderHeightLightColor;
}


//自定义失去焦点时的颜色
- (void)setPlaceHolderNormalColor:(UIColor *)placeHolderNormalColor
{
    _placeHolderNormalColor = placeHolderNormalColor;
}


- (void)setTextFieldFont:(UIFont *)textFieldFont
{
    _textFieldFont = textFieldFont;
    self.font = _textFieldFont;
}


//重写获取焦点事件
- (BOOL)becomeFirstResponder {
    [self setValue:self.placeHolderHeightLightColor forKeyPath:LhkhPlacerholderColorKeyPath];
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    [self setValue:self.placeHolderNormalColor forKeyPath:LhkhPlacerholderColorKeyPath];
    return [super resignFirstResponder];
}


#pragma mark - Setters




#pragma mark - Getters



@end
