//
//  UILabel+LhkhAttributeTextTapAction.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/19.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LhkhAttributeTextTapActionDelegate <NSObject>
/**
 *  YBAttributeTapActionDelegate
 *
 *  @param string  点击的字符串
 *  @param range   点击的字符串range
 *  @param index 点击的字符在数组中的index
 */
- (void)lhkh_attributeTapReturnString:(NSString *)string
                              range:(NSRange)range
                              index:(NSInteger)index;
@end



@interface LhkhAttributeModel : NSObject

@property (nonatomic, copy) NSString *str;
@property (nonatomic, assign) NSRange range;

@end


@interface UILabel (LhkhAttributeTextTapAction)
/**
 *  是否打开点击效果，默认是打开
 */
@property (nonatomic, assign) BOOL enabledTapEffect;

/**
 *  给文本添加点击事件Block回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param tapClick 点击事件回调
 */
- (void)lhkh_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                 tapClicked:(void (^) (NSString *string , NSRange range , NSInteger index))tapClick;

/**
 *  给文本添加点击事件delegate回调
 *
 *  @param strings  需要添加的字符串数组
 *  @param delegate delegate
 */
- (void)lhkh_addAttributeTapActionWithStrings:(NSArray <NSString *> *)strings
                                   delegate:(id <LhkhAttributeTextTapActionDelegate> )delegate;
@end
