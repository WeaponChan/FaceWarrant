//
//  LhkhEmptyView.h
//  LhkhEmptyView
//
//  Created by LHKH on 2018/2/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LhkhEmptyView : UIView
/*
 *各类空页面的图片*
 */
@property (nonatomic, strong) UIImageView *tipsImage;

/*
 *各类空页面的下标题*
 */
@property (nonatomic, strong) UILabel *tipsLabel;

/*
 *跳转按钮*
 */
@property (nonatomic, strong) UIButton *tipsButton;

/*
 *跳转按钮*
 */
@property (nonatomic, assign) TipsType type;
@end
