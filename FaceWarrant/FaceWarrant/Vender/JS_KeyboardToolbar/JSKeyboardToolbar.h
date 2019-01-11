//
//  JSKeyboardToolbar.h
//  MeiyaoniKH
//
//  Created by Jason on 16/10/25.
//  Copyright © 2016年 ainisi. All rights reserved.
//

typedef enum {
    JSKeyboardToolbarItemPrevious = 0,      //工具条 "上一个" 按钮
    JSKeyboardToolbarItemNext,              //工具条 "下一个" 按钮
    JSKeyboardToolbarItemDone,              //工具条 "完成" 按钮
} JSKeyboardToolbarItem;


#import <UIKit/UIKit.h>
@class JSKeyboardToolbar;


@protocol JSKeyboardToolbarDelegate <NSObject>
@optional
- (void)toolbar:(JSKeyboardToolbar *)toolbar DidClicked:(JSKeyboardToolbarItem)item;
@end


@interface JSKeyboardToolbar : UIToolbar
@property (nonatomic, weak) id <JSKeyboardToolbarDelegate> toolbarDelegate;
@property (nonatomic, weak, readonly) UIBarButtonItem *previousItem;
@property (nonatomic, weak, readonly) UIBarButtonItem *nextItem;
@property (nonatomic, weak, readonly) UIBarButtonItem *doneItem;

/**
 快速构造键盘工具条

 @return JSKeyboardToolbar
 */
+ (instancetype)keyboardToolbar;

+ (instancetype)keyboardToolbarWithDoneItem;


@end
