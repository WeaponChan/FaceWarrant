//
//  ClassroomQualityListView.m
//  NWMJ_C
//
//  Created by 项正 on 2018/9/11.
//  Copyright © 2018年 com.ainisi. All rights reserved.
//

#import "ClassroomQualityListView.h"
#define kALYPVPopQualityListBackGroundColor      [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7]
#define kALYPVColorBlue                          [UIColor colorWithRed:(0 / 255.0) green:(193 / 255.0) blue:(222 / 255.0) alpha:1]
#define kALYPVColorTextNomal                     [UIColor colorWithRed:(231 / 255.0) green:(231 / 255.0) blue:(231 / 255.0) alpha:1]
#define kALYPVColorTextGray                      [UIColor colorWithRed:(158 / 255.0) green:(158 / 255.0) blue:(158 / 255.0) alpha:1]
static const CGFloat AliyunPlayerViewQualityListViewQualityButtonHeight = 32;
@interface ClassroomQualityListView()
@property (nonatomic, strong)NSMutableArray<UIButton *> *qualityBtnArray; //清晰度按钮数组
@end

@implementation ClassroomQualityListView

#pragma mark - Life Cycle
- (instancetype)init{
    return [self initWithFrame:CGRectZero];
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.clipsToBounds = NO;
        self.backgroundColor = kALYPVPopQualityListBackGroundColor;
    }
    return self;
}


#pragma mark - Layout SubViews
- (void)layoutSubviews {
    [super layoutSubviews];
    float width = self.bounds.size.width;
    float btnHeight = AliyunPlayerViewQualityListViewQualityButtonHeight;
    for (int i = 0; i < _qualityBtnArray.count; i++) {
        UIButton *btn = _qualityBtnArray[i];
        btn.frame = CGRectMake(0, btnHeight * i, width, btnHeight);
    }
}



#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response

- (void)onClick:(UIButton *)btn {
        int tag = (int) btn.tag-100000;
            for (UIButton *btn in self.qualityBtnArray) {
                if (btn.tag == tag+100000) {
                    [btn setTitleColor:kALYPVColorBlue forState:UIControlStateNormal];
                }else{
                    [btn setTitleColor:kALYPVColorTextNomal forState:UIControlStateNormal];
                }
            }
            [self.delegate qualityListViewOnItemClick:tag];
    [self removeFromSuperview];
}



#pragma mark - Network requests




#pragma mark - Public Methods

/*
 * 功能 ：计算清晰度列表所需高度
 */
- (float)estimatedHeight{
    return [self.allSupportQualities count] * AliyunPlayerViewQualityListViewQualityButtonHeight;
}

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentQuality:(int)quality {
    if (![self.allSupportQualities containsObject:[NSString stringWithFormat:@"%d", quality]]) {
        return;
    }
    for (UIButton *btn in self.qualityBtnArray) {
        if (btn.tag == quality) {
            [btn setTitleColor:kALYPVColorBlue forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:kALYPVColorTextNomal forState:UIControlStateNormal];
        }
    }
}

/*
 * 功能 ：清晰度按钮颜色改变
 */
- (void)setCurrentDefinition:(NSString*)videoDefinition{
    if (![self.allSupportQualities containsObject:videoDefinition]) {
        return;
    }
    for (UIButton *btn in self.qualityBtnArray) {
        if ([btn.titleLabel.text isEqualToString:videoDefinition]) {
            [btn setTitleColor:kALYPVColorBlue forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:kALYPVColorTextNomal forState:UIControlStateNormal];
        }
    }
}




#pragma mark - Private Methods
/*
 * 功能 ： 监测字符串中的int值
 */
- (BOOL)isPureInt:(NSString*)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}



#pragma mark - Setters




#pragma mark - Getters

-(void)setAllSupportQualities:(NSArray *)allSupportQualities {
    if ([allSupportQualities count] == 0) {
        return;
    }
    NSArray * ary =  @[@"流畅",
                       @"普清",
                       @"标清",
                       @"高清",
                       @"2K",
                       @"4K",
                       @"原画"
                       ];
    _allSupportQualities = allSupportQualities;
    self.qualityBtnArray = [NSMutableArray array];
    
    for (int i = 0; i < allSupportQualities.count; i++) {
        int tempTag = -1;
        UIButton *btn = [[UIButton alloc] init];
        
        tempTag = [allSupportQualities[i] intValue]+100000;
        NSString *title = ary[[allSupportQualities[i] intValue]];
        [btn setTitle:title forState:UIControlStateNormal];
        
        [btn setTitleColor:kALYPVColorTextGray forState:UIControlStateNormal];
        [btn setTitleColor:kALYPVColorBlue forState:UIControlStateSelected];
        [btn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [btn setTag:tempTag];
        [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.qualityBtnArray addObject:btn];
    }
}

@end
