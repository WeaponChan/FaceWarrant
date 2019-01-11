//
//  FWQuestionVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//
//限制最大字数
#define MAX_LIMIT_NUMS   30

#import "FWQuestionVC.h"
#import "LhkhTagView.h"
#import "LhkhTag.h"
#import "FWVoiceView.h"
#import "LhkhIFlyMSCManager.h"
#import "FWQuestionManager.h"
#import "FWAiteFaceListVC.h"
#import "FWHashListVC.h"
#import "FWAiteFaceModel.h"
#import "YYText.h"
#import "FWAttentionModel.h"

@interface YYTextExampleEmailBindingParser :NSObject <YYTextParser>
@property (nonatomic, strong) NSRegularExpression *regex;
@end

@implementation YYTextExampleEmailBindingParser

- (instancetype)init {
    self = [super init];
    //    NSString *pattern = @"[-_a-zA-Z@\\.]+[ ,\\n]";
    NSString *pattern = @"#.*?#";
    self.regex = [[NSRegularExpression alloc] initWithPattern:pattern options:kNilOptions error:nil];
    return self;
}
- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)range {
    __block BOOL changed = NO;
    [_regex enumerateMatchesInString:text.string options:NSMatchingWithoutAnchoringBounds range:text.yy_rangeOfAll usingBlock:^(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop) {
        if (!result) return;
        NSRange range = result.range;
        if (range.location == NSNotFound || range.length < 1) return;
        if ([text attribute:YYTextBindingAttributeName atIndex:range.location effectiveRange:NULL]) return;
        
        NSRange bindlingRange = NSMakeRange(range.location, range.length);
        YYTextBinding *binding = [YYTextBinding bindingWithDeleteConfirm:YES];
        [text yy_setTextBinding:binding range:bindlingRange]; // Text binding
        [text yy_setColor:[ UIColor colorWithRed:41/255.0 green:120/255.0 blue:250/255.0 alpha:1] range:bindlingRange];
        changed = YES;
    }];
    return changed;
}
@end


@interface FWQuestionVC ()<YYTextViewDelegate,UIGestureRecognizerDelegate,FWVoiceViewDelegate>
{
    NSInteger _remainingLen;
    NSString *_content;
    NSString *_tagStr;
    NSString *_groupIds;
    NSString *_faceIds;
    MBProgressHUD *hud;
    NSString *_selBefore;
    NSString *_selAfter;
}
@property (nonatomic, strong) YYTextView *textView;
@property (nonatomic, strong) UILabel *tipsLB;
@property (nonatomic, strong) UILabel *exmpLB;
@property (nonatomic, strong) UILabel *numberLB;
@property (nonatomic, strong) UIView *qview;
@property (nonatomic, strong) NSMutableArray *tags;
@property (nonatomic, strong) LhkhTagView *tagView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) UIVisualEffectView *visualEffectView;//毛玻璃视图
@property (nonatomic, strong) FWVoiceView *voiceView;

@end

@implementation FWQuestionVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self loadTags];
}

#pragma mark - Layout SubViews

//11.29换新的框架 替换掉原来适配的代码


#pragma mark - System Delegate

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    NSRange range = textView.selectedRange;
    if (textView.text.length>0 && ![textView.text isEqualToString:@""] && textView.text != nil) {
        _selBefore = [textView.text substringToIndex:range.location];
        _selAfter = [textView.text substringFromIndex:range.location];
    }
}

- (void)textViewDidChange:(YYTextView *)textView
{
    if (textView.text.length == 0) {
        textView.textColor = [UIColor blackColor];
    }
    
    if (textView.text.length > 0) {
        self.tipsLB.hidden = YES;
        self.exmpLB.hidden = YES;
    }else {
        self.tipsLB.hidden = NO;
        self.exmpLB. hidden = NO;
    }
    
    if (textView == self.textView) {
        if (textView.text.length > MAX_LIMIT_NUMS) {
            textView.text = [textView.text substringToIndex:MAX_LIMIT_NUMS];
        }
    }
    self.numberLB.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,(long)textView.text.length),MAX_LIMIT_NUMS];
}

- (BOOL)textView:(YYTextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"#"]) {
        [self hashClick];
        return NO;
    }
    if (textView == self.textView) {
        if (text.length == 0) return YES;
        
        NSInteger existedLength = textView.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = text.length;
//        if (existedLength - selectedLength + replaceLength > MAX_LIMIT_NUMS) {
//            return NO;
//        }
        if (existedLength  > MAX_LIMIT_NUMS) {
            return NO;
        }
    }
    return YES;
}



#pragma mark - Custom Delegate
#pragma mark - FWVoiceViewDelegate
- (void)FWVoiceViewDelegateWithText:(NSString *)text
{
    if (self.textView.text.length>0) {
        self.textView.text = [NSString stringWithFormat:@"%@%@%@",_selBefore,text,_selAfter];
    }else{
        self.textView.text = text;
    }
    self.voiceView.hidden = self.visualEffectView.hidden = YES;
    self.tipsLB.hidden = self.exmpLB.hidden = self.textView.text.length>0;
}


#pragma mark - Event Response

- (void)publishClick
{
    if (self.textView.text == nil || self.textView.text.length == 0 || [self.textView.text isEqualToString:@""]) {
        [MBProgressHUD showTips:@"请输入您要提的问题内容"];
        return;
    }
    if ((_groupIds == nil || _groupIds.length == 0) && (_faceIds == nil || _faceIds.length == 0)) {
        [MBProgressHUD showTips:@"请选择一个要@的人或者群"];
    }else{
        [self sendQuestion];
    }
}

- (void)tagClick:(UIButton*)sender
{
   
    _tagStr = [NSString stringWithFormat:@"%@ ",sender.titleLabel.text];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_tagStr];
    text.yy_font = [UIFont systemFontOfSize:15];
    text.yy_lineSpacing = 5;
    text.yy_color = [UIColor blackColor];
    if (self.textView.text.length == 0 || [self.textView.text isEqualToString:@""]) {
        self.textView.attributedText = text;
    }else{
        if ((self.textView.text.length + _tagStr.length)<=30) {
            self.textView.text = [NSString stringWithFormat:@"%@%@",self.textView.text,_tagStr];
        }else{
            [MBProgressHUD showTips:@"提的问题字数最多30个额"];
        }
    }
    self.tipsLB.hidden = self.exmpLB.hidden = self.textView.text.length>0;
}

- (void)hashClick
{
    DLog(@"hash");
    FWHashListVC *vc =  [FWHashListVC new];
    vc.hashblock = ^(NSString *hash) {
        self->_tagStr = [NSString stringWithFormat:@"#%@# ",hash];
        if (self.textView.text.length == 0 || [self.textView.text isEqualToString:@""]) {
            self.textView.text = self->_tagStr;
        }else{
            if ((self.textView.text.length + self->_tagStr.length)<=30) {
                self.textView.text = [NSString stringWithFormat:@"%@%@",self.textView.text,self->_tagStr];
            }else{
                [MBProgressHUD showTips:@"提的问题字数最多30个额"];
            }
        }
        self.tipsLB.hidden = self.exmpLB.hidden = self.textView.text.length>0;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)micClick
{
    [self.textView resignFirstResponder];
    self.visualEffectView.hidden = NO;
    self.voiceView.hidden = NO;
}

- (void)aiteClick
{
    FWAiteFaceListVC *vc = [FWAiteFaceListVC new];
    vc.aitefaceblock = ^(NSArray *groups, NSArray *faces,NSArray *groupNames,NSArray *faceNames) {
        if (groups.count>0) {
            self->_groupIds = [groups componentsJoinedByString:@","];
        }
        if (faces.count>0) {
            self->_faceIds = [faces componentsJoinedByString:@","];
        }
        if (self.dataSource != nil && self.dataSource.count>0) {
            for (NSString *str1 in groupNames) {
                if (![self.dataSource containsObject:str1]) {
                    [self.dataSource addObject:str1];
                }
            }
            
            for (NSString *str2 in faceNames) {
                if (![self.dataSource containsObject:str2]) {
                    [self.dataSource addObject:str2];
                }
            }
        }else{
            [self.dataSource addObjectsFromArray:groupNames];
            [self.dataSource addObjectsFromArray:faceNames];
        }
        
        [self.tagView removeAllTags];

        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LhkhTag *tag = [[LhkhTag alloc] initWithText:StringConnect(@"@", self.dataSource[idx])];
            tag.padding = UIEdgeInsetsMake(3, 5, 3, 5);
            tag.cornerRadius = 3.0f;
            tag.font = [UIFont boldSystemFontOfSize:12];
            tag.borderWidth = 0;
            tag.bgColor = Color_MainBg;
            tag.borderColor = RGB_COLOR(191, 191, 191);
            tag.textColor = [UIColor blueColor];
            tag.enable = YES;
            
            [self.tagView addTag:tag];
        }];
        self.tagView.didTapTagAtIndex = ^(NSUInteger idx,NSString *idxText){
            NSLog(@"点击了第%ld个--->%@",idx,idxText);
        };
        
        CGFloat tagHeight = self.tagView.intrinsicContentSize.height;
        
        [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.offset(tagHeight);
            make.top.equalTo(self.qview.mas_bottom);
        }];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)singleTapDetected
{
    self.voiceView.hidden = self.visualEffectView.hidden = YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - Network requests

- (void)sendQuestion
{
    hud = [MBProgressHUD showHUDwithMessage:@"正在保存..."];
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"questionContent":self.textView.text,
                            @"groupsIds":_groupIds?:@"",
                            @"faceIds":_faceIds?:@""
                            };
    [FWQuestionManager sendQuestionWithParameters:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            [self->hud hide];
            self.textView.text = @"";
            self.exmpLB.hidden = self.tipsLB.hidden = NO;
            [MBProgressHUD showTips:response[@"resultDesc"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self->hud hide];
            [MBProgressHUD showTips:response[@"resultDesc"]];
        }
    }];
}


- (void)loadTags
{
    NSDictionary *param = @{
                            @"flag":@"0"
                            };
    [FWQuestionManager loadQuestionHotTagsWithParameters:param result:^(NSArray *arr) {
        [self.tags removeAllObjects];
        [self.tags addObjectsFromArray:arr];
        [self setSubView];
    }];
}

#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setNav
{
    self.navigationItem.title = @"提问";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem js_itemWithTitle:@"发布" target:self action:@selector(publishClick)];
}

- (void)setSubView
{
    UIView *tagView = [[UIView alloc] initWithFrame:CGRectZero];
    tagView.backgroundColor = Color_MainBg;
    [self.view addSubview:tagView];
    CGFloat btnW = (Screen_W-90)/4;
    for (int i=0; i<self.tags.count; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(15+i*btnW+i*20, 10, btnW, 25)];
        [btn setTitle:[NSString stringWithFormat:@"#%@#",self.tags[i]] forState:UIControlStateNormal];
        btn.backgroundColor = Color_White;
        btn.layer.cornerRadius = 5.f;
        btn.layer.masksToBounds = YES;
        [btn addTarget:self action:@selector(tagClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        btn.titleLabel.font = systemFont(14);
        [tagView addSubview:btn];
    }
    
    
    self.qview = [[UIView alloc] initWithFrame:CGRectZero];
    self.qview.backgroundColor = Color_White;
    [self.view addSubview:self.qview];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"问题描述：";
    label.font = systemFont(16);
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
    lineView.backgroundColor = Color_MainBg;
    
    UIButton *selTagBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [selTagBtn setBackgroundImage:[UIImage imageNamed:@"q_hash"] forState:UIControlStateNormal];
    [selTagBtn addTarget:self action:@selector(hashClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *micBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [micBtn setBackgroundImage:[UIImage imageNamed:@"q_voice"] forState:UIControlStateNormal];
    [micBtn addTarget:self action:@selector(micClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *aiteBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    [aiteBtn setBackgroundImage:[UIImage imageNamed:@"q_aite"] forState:UIControlStateNormal];
    [aiteBtn addTarget:self action:@selector(aiteClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.qview addSubview:label];
    [self.qview addSubview:lineView];
    [self.qview addSubview:self.textView];
    [self.qview addSubview:self.tipsLB];
    [self.qview addSubview:self.exmpLB];
    [self.qview addSubview:self.numberLB];
    [self.qview addSubview:selTagBtn];
    [self.qview addSubview:micBtn];
    [self.qview addSubview:aiteBtn];
    
    [self.view addSubview:self.tagView];
    
    [self.view addSubview:self.textView];
    
    [tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(45);
        make.top.equalTo(self.view).offset(NavigationBar_H);
        make.left.right.equalTo(self.view);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(44);
        make.top.equalTo(self.qview);
        make.left.equalTo(self.qview).offset(10);
        make.right.equalTo(self.qview);
    }];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(1);
        make.top.equalTo(label.mas_bottom);
        make.left.right.equalTo(self.qview);
    }];

    [self.qview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(245);
        make.left.right.equalTo(self.view);
        make.top.equalTo(tagView.mas_bottom);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.left.right.equalTo(self.qview);
        make.height.offset(160);
    }];
    
    [self.tipsLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView).offset(10);
        make.left.equalTo(self.textView).offset(10);
        make.width.offset(200);
        make.height.offset(15);
    }];
    
    [self.exmpLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLB.mas_bottom).offset(5);
        make.left.equalTo(self.tipsLB);
        make.width.offset(250);
        make.height.offset(15);
    }];
    
    [self.numberLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textView).offset(-10);
        make.right.equalTo(self.textView).offset(-10);
        make.width.offset(100);
        make.height.offset(15);
    }];
    
    [aiteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.right.equalTo(self.qview).offset(-20);
        make.bottom.equalTo(self.qview).offset(-10);
    }];
    
    [micBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.right.equalTo(aiteBtn.mas_left).offset(-25);
        make.bottom.equalTo(self.qview).offset(-10);
    }];
    
    [selTagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.offset(20);
        make.right.equalTo(micBtn.mas_left).offset(-25);
        make.bottom.equalTo(self.qview).offset(-10);
    }];
    
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.offset(0);
        make.top.equalTo(self.qview.mas_bottom);
    }];
    
    if (self.faceArr.count>0) {
        [self.tagView removeAllTags];
        FWAttentionModel *model = self.faceArr[0];
        self->_faceIds = model.faceId;
        [self.dataSource addObject:model.faceName];
        [self.dataSource enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            LhkhTag *tag = [[LhkhTag alloc] initWithText:StringConnect(@"@", self.dataSource[idx])];
            tag.padding = UIEdgeInsetsMake(3, 5, 3, 5);
            tag.cornerRadius = 3.0f;
            tag.font = [UIFont boldSystemFontOfSize:12];
            tag.borderWidth = 0;
            tag.bgColor = Color_MainBg;
            tag.borderColor = RGB_COLOR(191, 191, 191);
            tag.textColor = [UIColor blueColor];
            tag.enable = YES;
            
            [self.tagView addTag:tag];
        }];
        self.tagView.didTapTagAtIndex = ^(NSUInteger idx,NSString *idxText){
            NSLog(@"点击了第%ld个--->%@",idx,idxText);
        };
        
        CGFloat tagHeight = self.tagView.intrinsicContentSize.height;
        
        [self.tagView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.offset(tagHeight);
            make.top.equalTo(self.qview.mas_bottom);
        }];
    }
    
    //实现模糊效果
    UIBlurEffect *blurEffrct =[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //毛玻璃视图
    self.visualEffectView = [[UIVisualEffectView alloc]initWithEffect:blurEffrct];
    self.visualEffectView.frame = CGRectMake(0, 0, Screen_W, Screen_H);
    self.visualEffectView.alpha = 0.5;
    self.visualEffectView.hidden = YES;
    [self.view addSubview:self.visualEffectView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapDetected)];
    singleTap.numberOfTapsRequired = 1;
    [self.visualEffectView setUserInteractionEnabled:YES];
    [self.visualEffectView addGestureRecognizer:singleTap];
    
    self.voiceView.hidden = YES;
    [self.view addSubview:self.voiceView];
    
    [self.voiceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(200);
        make.left.right.bottom.equalTo(self.view);
    }];
}


#pragma mark - Setters

- (YYTextView*)textView
{
    if (_textView == nil) {
        _textView = [YYTextView new];
        _textView.textParser = [YYTextExampleEmailBindingParser new];
        _textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        _textView.font = systemFont(14);
        _textView.delegate = self;
        if (iOS8Later) {
            _textView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
        }
        _textView.scrollIndicatorInsets = _textView.contentInset;
    }
    return _textView;
}


- (UILabel *)tipsLB
{
    if (!_tipsLB) {
        _tipsLB = [[UILabel alloc] init];
        _tipsLB.text = @"请在此输入问题说明";
        _tipsLB.textColor = [UIColor colorWithHexString:@"999999"];
        _tipsLB.font  = systemFont(14);
    }
    return _tipsLB;
}

- (UILabel *)exmpLB
{
    if (!_exmpLB) {
        _exmpLB = [[UILabel alloc] init];
        _exmpLB.text = @"例如：某某某的手机是什么品牌？";
        _exmpLB.textColor = [UIColor colorWithHexString:@"999999"];
        _exmpLB.font  = systemFont(14);
    }
    return _exmpLB;
}


- (UILabel *)numberLB
{
    if (!_numberLB) {
        _numberLB = [[UILabel alloc] init];
        _numberLB.text = @"0/30";
        _numberLB.textColor = [UIColor colorWithHexString:@"999999"];
        _numberLB.font  = systemFont(16);
        _numberLB.textAlignment = NSTextAlignmentRight;
    }
    return _numberLB;
}

- (LhkhTagView*)tagView
{
    if (_tagView == nil) {
        [_tagView removeAllTags];
        _tagView = [[LhkhTagView alloc] init];
        _tagView.padding = UIEdgeInsetsMake(10, 10, 10, 10);
        _tagView.lineSpacing = 10;
        _tagView.interitemSpacing = 10;
        _tagView.preferredMaxLayoutWidth = Screen_W;
    }
    return _tagView;
}

-(NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (FWVoiceView*)voiceView
{
    if (_voiceView == nil) {
        _voiceView = [[FWVoiceView alloc] initWithFrame:CGRectZero];
        _voiceView.vctype = @"1";
        _voiceView.backgroundColor = Color_White;
        _voiceView.delegate = self;
    }
    return _voiceView;
}

- (NSMutableArray*)tags
{
    if (_tags == nil) {
        _tags = [NSMutableArray array];
    }
    return _tags;
}

#pragma mark - Getters




@end
