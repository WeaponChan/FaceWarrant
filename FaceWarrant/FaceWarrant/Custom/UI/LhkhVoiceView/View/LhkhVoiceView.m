//
//  LhkhVoiceView.m
//  FaceWarrant
//
//  Created by FW on 2018/11/1.
//  Copyright © 2018 LHKH. All rights reserved.
//


#define VoiceViewH              200
#define Page                    self.page
#import "LhkhVoiceView.h"
#import "LhkhVoiceRecognitionView.h"
#import "LhkhRecordView.h"
#import "LhkhButton.h"
@interface LhkhVoiceView()<UIScrollViewDelegate,LhkhVoiceRecognitionViewDelegate,LhkhRecordViewDelegate>
{
    CGFloat _labelDistance;
    CGPoint _currentContentOffSize;
}
@property (strong, nonatomic) UIScrollView *contentScrollView;//语音识别  录音
@property (assign, nonatomic) NSInteger page;//page数  有些页面可能只需要语音识别和录音中的一种  根据pages数设置contentSize
@property (strong, nonatomic) UIView *titlesView; //title
@property (strong, nonatomic) LhkhButton *selectedButton;
@property (strong, nonatomic) UIView *sliderView;//滑条

@property (strong, nonatomic) LhkhVoiceRecognitionView *voiceRecogniView;//语音识别
@property (strong, nonatomic) LhkhRecordView *recordView;//录音
@end

@implementation LhkhVoiceView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)titles
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = Color_MainBg;
        self.page = titles.count;
        [self setUpTitleView:titles];
        [self contentScrollView];
        [self voiceRecogniView];
        [self recordView];
    }
    return self;
}


#pragma mark - Layout SubViews


#pragma mark - System Delegate
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
//    NSInteger index = scrollView.contentOffset.x / scrollView.width;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView  {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    //点击标题按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self  titleClick:self.titlesView.subviews[index]];
}



#pragma mark - Custom Delegate

#pragma mark - LhkhVoiceRecognitionViewDelegate
- (void)LhkhVoiceRecognitionViewDelegateWithText:(NSString *)text
{
    if ([self.vdelegate respondsToSelector:@selector(LhkhVoiceViewDelegateWithText:)]) {
        [self.vdelegate LhkhVoiceViewDelegateWithText:text];
    }
}

#pragma mark - LhkhRecordViewDelegate
- (void)LhkhRecordViewDelegateAudio:(NSString *)audioUrl audioTime:(NSString *)audioTime
{
    if ([self.vdelegate respondsToSelector:@selector(LhkhVoiceViewDelegateAudio:audioTime:)]) {
        [self.vdelegate LhkhVoiceViewDelegateAudio:audioUrl audioTime:audioTime];
    }
}

- (void)LhkhRecordViewDelegateCancelClick {
    
}


#pragma mark - Event Response
#pragma mark 标题栏每个按钮的点击事件
-(void)titleClick:(LhkhButton *)button{
    self.selectedButton.enabled = YES;
    button.enabled = NO;
    self.selectedButton = button;
    [UIView animateWithDuration:0.25 animations:^{
        self.sliderView.centerX = button.centerX;
    }];
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = button.tag * self.contentScrollView.width;
    [self.contentScrollView setContentOffset:offset animated:YES];
}

#pragma mark - Network Requests


#pragma mark - Public Methods


#pragma mark - Private Methods

/*设置标题组*/
- (void)setUpTitleView:(NSArray*)titles{
    //标题数组
    NSArray *titleArr = [NSArray arrayWithArray:titles];
    //标题栏设置
    UIView *titlesView = [[UIView alloc] init];
    titlesView.backgroundColor = [UIColor whiteColor];
    titlesView.width = self.width;
    titlesView.height = 50;
    titlesView.y = self.height-50;
    [self addSubview:titlesView];
    self.titlesView = titlesView;
    
    
    // 头部滑条
    UIView *sliderView = [[UIView alloc] init];
    sliderView.backgroundColor = Color_Theme_Pink;
    sliderView.height = 8;
    sliderView.width = 8;
    sliderView.tag = -1;
    sliderView.y = 5;
    sliderView.layer.cornerRadius = 4.f;
    sliderView.layer.masksToBounds = YES;
    self.sliderView = sliderView;
    
    //设置上面的按钮
    NSInteger width = (titlesView.width-160) / titleArr.count;
    NSInteger height = 30;
    for (NSInteger i=0; i<titleArr.count; i++) {
        LhkhButton *btn = [[LhkhButton alloc] init];
        btn.width = width;
        btn.height = height;
        btn.y = 10;
        btn.x = 80+i * width;
        btn.tag = i;
        [btn setTitle: titleArr[i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:btn];
        
        if (i == 0) {
            btn.enabled = NO;
            self.selectedButton = btn;
            [btn.titleLabel sizeToFit];
            self.sliderView.centerX = btn.centerX;
        }
    }
    [self.titlesView addSubview:sliderView];
}


#pragma mark - Setters

- (UIScrollView *)contentScrollView{
    if (_contentScrollView == nil) {
        UIScrollView *scrollV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, VoiceViewH)];
        scrollV.backgroundColor = Color_White;
        scrollV.pagingEnabled = YES;
        scrollV.contentSize = CGSizeMake(Screen_W * Page, 0);
        scrollV.contentOffset = CGPointMake(0, 0);
        scrollV.showsHorizontalScrollIndicator = NO;
        scrollV.delegate = self;
        [self addSubview:scrollV];
        _contentScrollView = scrollV;
    }
    return _contentScrollView;
}

- (LhkhVoiceRecognitionView*)voiceRecogniView
{
    if (_voiceRecogniView == nil) {
        _voiceRecogniView = [[LhkhVoiceRecognitionView alloc] initWithFrame:CGRectMake(0, 0, Screen_W, VoiceViewH)];
        _voiceRecogniView.delegate = self;
        [self.contentScrollView addSubview:_voiceRecogniView];
        _voiceRecogniView.vctype = @"0";
    }
    return _voiceRecogniView;
}

- (LhkhRecordView*)recordView
{
    if (_recordView == nil) {
        _recordView = [[LhkhRecordView alloc] initWithFrame:CGRectMake(Screen_W, 0, Screen_W, VoiceViewH)];
        _recordView.delegate = self;
        [self.contentScrollView addSubview:_recordView];
    }
    return _recordView;
}

#pragma mark - Getters



@end
