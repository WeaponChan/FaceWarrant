//
//  UIBarButtonItem+JSCustomItem.m
//  MeiyaoniKH
//
//  Created by Jason on 16/10/18.
//  Copyright © 2016年 ainisi. All rights reserved.
//

#import "UIBarButtonItem+JSCustomItem.h"

@implementation UIBarButtonItem (JSCustomItem)

+ (instancetype)js_itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    view.backgroundColor = [UIColor clearColor];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:Image(image)];
    imageView.center = view.center;
    [view addSubview:imageView];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, view.width, view.height)];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    return [[self alloc] initWithCustomView:view];
}


+ (instancetype)js_itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    [barButtonItem setTintColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]];
   [barButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName, nil] forState:UIControlStateNormal];
    return barButtonItem;
}

@end
