//
//  LhkhTextField.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LhkhTextField : UITextField
/**占位文字颜色*/
@property (nonatomic, strong) UIColor *placeHolderNormalColor;
/**获取焦点时 占位文字颜色*/
@property (nonatomic, strong) UIColor *placeHolderHeightLightColor;
/**文本字体*/
@property (nonatomic, strong) UIFont *textFieldFont;
@end
