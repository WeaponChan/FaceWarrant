//
//  Macro_Color.h
//  LHKHBase
//
//  Created by LHKH on 2017/11/11.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#ifndef Macro_Color_h
#define Macro_Color_h


#define COLOR_ALPHA(R,G,B,A)        [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define COLOR(R,G,B)                [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1]

/*********************************************************************************/
/*             字体颜色                */
/*********************************************************************************/
#define Color_MainBg                [UIColor colorWithHexString:@"#F3F3F3"]      //主背景色
#define Color_MainText              [UIColor colorWithHexString:@"#333333"]      //标题、正文等主要文字
#define Color_SubText               [UIColor colorWithHexString:@"#999999"]      //辅助、默认等主要文字
#define Color_TipText               [UIColor colorWithHexString:@"#b5b6b6"]      //提示性文字
#define Color_Line                  [UIColor colorWithHexString:@"#DDDDDD"]      //分割线 浅灰色
#define Color_TableView             [UIColor colorWithHexString:@"#f8f8f8"]      //tableView背景色
#define Color_Checking              [UIColor colorWithHexString:@"#FD9F67"]      //审核中
#define Color_PlaceHolder           [UIColor colorWithHexString:@"#B1B1B1"]      //PlaceHolder颜色
#define Color_BtnBg                 [UIColor colorWithHexString:@"#FF7900"]      //选择时间的背景色

/*********************************************************************************/
/*             APP内基本配色              */
/*********************************************************************************/
#define Color_Theme_Bar             [UIColor colorWithHexString:@"#f1f1f1"]       //tabBar背景色
#define Color_Theme_Purple          [UIColor colorWithHexString:@"#6A51A9"]       //APP次要元素色——紫
#define Color_Theme_Red             [UIColor colorWithHexString:@"#FF3636"]       //APP次要元素色——红
#define Color_Theme_Yellow          [UIColor colorWithHexString:@"#FEDF41"]       //APP次要元素色——明黄
#define Color_Theme_Pink            [UIColor colorWithHexString:@"#FD0663"]       //APP次要元素色——粉
/*********************************************************************************/
/*              常用扁平化视觉色彩                */
/*********************************************************************************/


/*********************************************************************************/
/*            系统基础颜色宏定义              */
/*********************************************************************************/
#define Color_Black                 [UIColor blackColor]
#define Color_White                 [UIColor whiteColor]
#define Color_Clear                 [UIColor clearColor]

#endif /* Macro_Color_h */
