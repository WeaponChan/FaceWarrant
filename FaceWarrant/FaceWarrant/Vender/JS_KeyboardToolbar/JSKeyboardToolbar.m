//
//  JSKeyboardToolbar.m
//  MeiyaoniKH
//
//  Created by Jason on 16/10/25.
//  Copyright © 2016年 ainisi. All rights reserved.
//

#define  SCREEN_WIDTH     [[UIScreen mainScreen] bounds].size.width
#define  Screen_HEIGHT    [[UIScreen mainScreen] bounds].size.height
#define  TOOLBAR_HEIGHT   44.0f

#import "JSKeyboardToolbar.h"

@interface JSKeyboardToolbar ()
@property (nonatomic, strong) NSMutableArray *optionButtonItems;
@end

@implementation JSKeyboardToolbar

+ (instancetype)keyboardToolbar
{
    return [[[self class] alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOOLBAR_HEIGHT)];
}


+ (instancetype)keyboardToolbarWithDoneItem
{
    return [[[self class] alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOOLBAR_HEIGHT) withDoneItem:YES];
}


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //上一个
        UIBarButtonItem *previousItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home-keyboardItem-up"] style:UIBarButtonItemStylePlain target:self action:@selector(itemDidClick:)];
        _previousItem = previousItem;
        
        [self.optionButtonItems addObject:self.previousItem];
        
        //下一个
        UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"home-keyboardIem-down"] style:UIBarButtonItemStylePlain target:self action:@selector(itemDidClick:)];
        _nextItem = nextItem;
        
        [self.optionButtonItems addObject:self.nextItem];
       
        //完成
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(itemDidClick:)];
        _doneItem = doneItem;
        
        //弹簧
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        //填充
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        
        self.items = [NSArray arrayWithObjects:self.previousItem,self.nextItem,flexibleSpace,self.doneItem,fixedSpace, nil];
        [self setItems:self.items];
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame withDoneItem:(BOOL)state
{
    if (self = [super initWithFrame:frame]) {
        
        //上一个
        UIBarButtonItem *previousItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(itemDidClick:)];
        _previousItem = previousItem;
        
        [self.optionButtonItems addObject:self.previousItem];
        
        //下一个
        UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@""] style:UIBarButtonItemStylePlain target:self action:@selector(itemDidClick:)];
        _nextItem = nextItem;
        
        [self.optionButtonItems addObject:self.nextItem];
        
        //完成
        UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(itemDidClick:)];
        _doneItem = doneItem;
        
        //弹簧
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        //填充
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        
        self.items = [NSArray arrayWithObjects:self.previousItem,self.nextItem,flexibleSpace,self.doneItem,fixedSpace, nil];
        [self setItems:self.items];
        
    }
    return self;

}


- (void)itemDidClick:(UIBarButtonItem *)item
{
    NSInteger itemIndex = [self.items indexOfObject:item];
    
    if ([self.toolbarDelegate respondsToSelector:@selector(toolbar:DidClicked:)] == NO) {
        return;
    }else {
        if (itemIndex == 0) {
            [self.toolbarDelegate toolbar:self DidClicked:JSKeyboardToolbarItemPrevious];
        }
        if (itemIndex == 1) {
            [self.toolbarDelegate toolbar:self DidClicked:JSKeyboardToolbarItemNext];
        }
        if (itemIndex == 3) {
            [self.toolbarDelegate toolbar:self DidClicked:JSKeyboardToolbarItemDone];
        }
    }
}


- (NSMutableArray *)optionButtonItems
{
    if (!_optionButtonItems) {
        _optionButtonItems = [NSMutableArray array];
    }
    return _optionButtonItems;
}

@end
