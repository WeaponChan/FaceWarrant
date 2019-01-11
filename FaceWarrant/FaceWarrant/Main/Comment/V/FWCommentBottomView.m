//
//  FWCommentBottomView.m
//  FaceWarrant
//
//  Created by FW on 2018/8/2.
//  Copyright © 2018年 LHKH. All rights reserved.
//
//限制最大字数
#define MAX_LIMIT_NUMS   200
#import "FWCommentBottomView.h"
#import "FWVoiceView.h"
@interface FWCommentBottomView()<UITextViewDelegate,FWVoiceViewDelegate>

@property (nonatomic, strong) UIView * bottomBgView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *micBtn;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) FWVoiceView *voiceView;
@end

@implementation FWCommentBottomView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, Screen_H-60, Screen_W, 60);
        self.backgroundColor = [UIColor clearColor];
        [self addNotification];
        [self setUI];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Layout SubViews


#pragma mark - System Delegate

- (void)textViewDidChange:(UITextView *)textView
{
    DLog(@"%@",textView.text);
    if (textView.text.length > 0) {
        self.placeholderLB.hidden = YES;
    }else {
        self.placeholderLB.hidden = NO;
    }
    
    if (textView == self.textView) {
        if (textView.text.length > MAX_LIMIT_NUMS) {
            textView.text = [textView.text substringToIndex:MAX_LIMIT_NUMS];
        }
    }
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]){
        [self senderBtnClick];
        return NO;
    }
    
    if (textView == self.textView) {
        if (text.length == 0) return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = text.length;
        if (existedLength - selectedLength + replaceLength > MAX_LIMIT_NUMS) {
            [MBProgressHUD showTips:@"我是有上限(200个字符)的额~"];
            return NO;
        }
    }
    //让textview自适应高度
//    CGRect frame = textView.frame;
//    float height;
//    if ([text isEqual:@""]) {
//
//        if (![textView.text isEqualToString:@""]) {
//
//            height = [ self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
//
//        }else{
//
//            height = [ self heightForTextView:textView WithText:textView.text];
//        }
//    }else{
//
//        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
//    }
//
//    frame.size.height = height;
//    [UIView animateWithDuration:0.5 animations:^{
//
//        textView.frame = frame;
//
//    } completion:nil];

    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.voiceView.hidden = YES;
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}


#pragma mark - Custom Delegate


#pragma mark - FWVoiceViewDelegate
- (void)FWVoiceViewDelegateWithText:(NSString *)text
{
//    self.voiceView.hidden = YES;
    if (self.textView.text.length == 0 || [self.textView.text isEqualToString:@""] || self.textView.text == nil) {
        self.textView.text = text;
    }else{
        self.textView.text = StringConnect(self.textView.text, text);
    }
    if (self.textView.text.length > 0) {
        self.placeholderLB.hidden = YES;
    }else {
        self.placeholderLB.hidden = NO;
    }
}


#pragma mark - Event Response

- (void)senderBtnClick
{
    if (self.textView.text.length == 0 || [self.textView.text isEqualToString:@""] || self.textView.text == nil) {
        [MBProgressHUD showTips:@"请输入要发布的内容额"];
        return;
    }
    [self endEditing:YES];
    self.voiceView.hidden = YES;
    if ([self.delegate respondsToSelector:@selector(FWCommentBottomViewDelegateSendMessage:indexPath:)]) {
        [self.delegate FWCommentBottomViewDelegateSendMessage:self.textView.text indexPath:self.indexPath];
    }
}

- (void)handleTapPress:(UITapGestureRecognizer *)gestureRecognizer
{
    [self endEditing:YES];
}

- (void)micClick
{
    [self endEditing:YES];
    self.voiceView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.bottomBgView.y = 0;
        self.frame = CGRectMake(0, Screen_H-300, Screen_W, 300);
        self.voiceView.frame = CGRectMake(0, 60, Screen_W, 300);
    }];
}


- (void)sendClick
{
    if (self.textView.text.length == 0 || [self.textView.text isEqualToString:@""] || self.textView.text == nil) {
        [MBProgressHUD showTips:@"请输入要发布的内容额"];
        return;
    }else{
        [self endEditing:YES];
        self.voiceView.hidden = YES;
        if ([self.delegate respondsToSelector:@selector(FWCommentBottomViewDelegateSendMessage:indexPath:)]) {
            [self.delegate FWCommentBottomViewDelegateSendMessage:self.textView.text indexPath:self.indexPath];
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, Screen_H-60, Screen_W, 60);
    }];
}

- (void)clickBlank
{
    [self endEditing:YES];
    self.voiceView.hidden = YES;
    [UIView animateWithDuration:0.5 animations:^{
        self.frame = CGRectMake(0, Screen_H-60, Screen_W, 60);
    }];
}


#pragma mark - Network Requests


#pragma mark - Public Methods

- (void)reply:(NSNotification *)notification
{
    NSString *name = [notification.userInfo objectForKey:@"name"];
    NSString *type = [notification.userInfo objectForKey:@"type"];
    
    if ([type isEqualToString:@"1"]) {
        self.placeholderLB.hidden = NO;
        self.placeholderLB.text = [NSString stringWithFormat:@"回复 %@",name];
    }else{
        self.placeholderLB.hidden = NO;
        self.placeholderLB.text = @"既然来了，不说点什么吗";
    }
}

- (void)replyOrcommentEnd:(NSNotification *)notification
{
    self.textView.text = @"";
    self.placeholderLB.hidden = NO;
    self.placeholderLB.text = @"既然来了，不说点什么吗";
}

#pragma mark - Private Methods

-(void)addNotification{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardDidChangeFrame:) name:UIKeyboardDidChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillhide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reply:) name:@"reply" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replyOrcommentEnd:) name:@"replyOrcommentEnd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickBlank) name:@"clickBlank" object:nil];
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardF.origin.y;
    
    self.y = 0;
    self.height = Screen_H;
    self.bottomBgView.y = Screen_H-60;
    
    [UIView animateWithDuration:duration animations:^{
        self.bottomBgView.y = keyboardY-60;
    }];
}
- (void)keyboardWillhide:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardY = keyboardF.origin.y;
    
    self.y = Screen_H-60;
    self.height = 60;
    self.bottomBgView.y = 0;
    
    [UIView animateWithDuration:duration animations:^{
        self.bottomBgView.y = 0;
    }];
}
- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    //    NSDictionary *userInfo = notification.userInfo;
    //    // 动画的持续时间
    //    double duration = [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //    // 键盘的frame
    //    CGRect keyboardF = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //    CGFloat keyboardY = keyboardF.origin.y;
    //
    //    [UIView animateWithDuration:duration animations:^{
    //        self.bottomBgView.Y = keyboardY-49;
    //    }];
}
- (void)keyboardDidChangeFrame:(NSNotification *)notification
{
    
}


- (void)setUI
{
    [self addSubview:self.bottomBgView];
    [self addSubview:self.voiceView];
    [self.bottomBgView addSubview:self.textView];
    [self.bottomBgView addSubview:self.placeholderLB];
    [self.bottomBgView addSubview:self.imageView];
    [self.bottomBgView addSubview:self.micBtn];
    [self.bottomBgView addSubview:self.sendBtn];
    self.voiceView.hidden = YES;
    NSString *urlStr = [USER_DEFAULTS objectForKey:UD_UserHeadImg];
    [self.imageView sd_setImageWithURL:URL(urlStr) placeholderImage:Image_placeHolder66];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapPress:)];
    tapGesture.numberOfTapsRequired=1;
    [self addGestureRecognizer:tapGesture];
}


- (void)showView
{
    [self setHidden:NO];
}
- (void)hideView
{
    [self setHidden:YES];
}


- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}

#pragma mark - Setters

- (UIView *)bottomBgView
{
    if (_bottomBgView == nil) {
        _bottomBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Screen_W, 60)];
        _bottomBgView.backgroundColor = [UIColor whiteColor];
        
        UIView * bLine = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _bottomBgView.width, 0.5f)];
        bLine.backgroundColor = [UIColor colorWithHexString:@"E4E4E4"];
        [_bottomBgView addSubview:bLine];
    }
    return _bottomBgView;
}
- (UITextView *)textView
{
    if (_textView == nil) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(61, 12, Screen_W-121, 36)];
        _textView.backgroundColor = [UIColor colorWithHexString:@"E4E4E4"];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 5.0f;
        _textView.scrollsToTop = NO;
        _textView.returnKeyType = UIReturnKeySend;
        _textView.delegate = self;
        // 使用textContainerInset设置top、left、right
        _textView.textContainerInset = UIEdgeInsetsMake(10, 0, 0, 30);
        //当光标在最后一行时，始终显示低边距，需使用contentInset设置bottom.
        _textView.contentInset = UIEdgeInsetsMake(0, 0, 10, 0);
        //防止在拼音打字时抖动
        _textView.layoutManager.allowsNonContiguousLayout = NO;
    }
    return _textView;
}

- (UILabel *)placeholderLB
{
    if (!_placeholderLB) {
        _placeholderLB = [[UILabel alloc] initWithFrame:CGRectMake(66, 15, Screen_W-120, 30)];
        _placeholderLB.font = systemFont(12);
        _placeholderLB.textColor = Color_SubText;
    }
    return _placeholderLB;
}

- (UIImageView*)imageView
{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 12, 36, 36)];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 18.f;
        _imageView.layer.masksToBounds = YES;
    }
    return _imageView;
}

- (UIButton*)sendBtn
{
    if (_sendBtn == nil) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_W-60, 12, 50, 36)];
        [_sendBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:Color_Theme_Pink forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = systemFont(14);
        [_sendBtn addTarget:self action:@selector(sendClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

- (UIButton*)micBtn
{
    if (_micBtn == nil) {
        _micBtn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_W-90, 20, 20, 20)];
        [_micBtn setImage:Image(@"search_yuyin") forState:UIControlStateNormal];
        [_micBtn addTarget:self action:@selector(micClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _micBtn;
}


- (FWVoiceView*)voiceView
{
    if (_voiceView == nil) {
        _voiceView = [[FWVoiceView alloc] init];
        _voiceView.backgroundColor = Color_White;
        _voiceView.delegate = self;
        _voiceView.vctype = @"1";
    }
    return _voiceView;
}

#pragma mark - Getters



@end