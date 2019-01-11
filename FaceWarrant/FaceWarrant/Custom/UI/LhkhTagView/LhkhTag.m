//
//  LhkhTag.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "LhkhTag.h"
static const CGFloat kDefaultFontSize = 12.0;
@implementation LhkhTag
- (instancetype)init {
    self = [super init];
    if (self) {
        _fontSize = kDefaultFontSize;
        _textColor = [UIColor blackColor];
        _bgColor = [UIColor whiteColor];
        _enable = YES;
    }
    return self;
}

- (instancetype)initWithText: (NSString *)text {
    self = [self init];
    if (self) {
        _text = text;
    }
    return self;
}

+ (instancetype)tagWithText: (NSString *)text {
    return [[self alloc] initWithText: text];
}
@end
