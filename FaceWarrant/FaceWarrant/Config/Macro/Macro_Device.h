//
//  Macro_Device.h
//  LHKHBase
//
//  Created by LHKH on 2017/11/11.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#ifndef Macro_Device_h
#define Macro_Device_h

/*********************************************************************************/
/*               当前APP版本号             */
/*********************************************************************************/
#define APP_VERSON [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]


/*********************************************************************************/
/*               systemVersion             */
/*********************************************************************************/
#define SYSTEM_VERSION [UIDevice currentDevice].systemVersion.floatValue

#define iOS_8   (SYSTEM_VERSION >= 8.0f  && SYSTEM_VERSION < 9.0f)
#define iOS_9   (SYSTEM_VERSION >= 9.0f  && SYSTEM_VERSION < 10.0f)
#define iOS_10  (SYSTEM_VERSION >= 10.0f && SYSTEM_VERSION < 11.0f)
#define iOS_11  (SYSTEM_VERSION >= 11.0f && SYSTEM_VERSION < 12.0f)
#define iOS_12  (SYSTEM_VERSION >= 12.0f && SYSTEM_VERSION < 13.0f)

#define iOS8Later (SYSTEM_VERSION >= 8.0f)
#define iOS9Later (SYSTEM_VERSION >= 9.0f)
#define iOS10Later (SYSTEM_VERSION >= 10.0f)
#define iOS11Later (SYSTEM_VERSION >= 11.0f)
#define iOS12Later (SYSTEM_VERSION >= 12.0f)


/*********************************************************************************/
/*               screenSize             */
/*********************************************************************************/
#define Screen_W        [[UIScreen mainScreen] bounds].size.width
#define Screen_H        [[UIScreen mainScreen] bounds].size.height


// iPhone4S 3.5吋
#define IS_iPhone_4S ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

// iPhone5 iPhone5s iPhoneSE 4.0吋
#define IS_iPhone_5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

// iPhone6 7 8  4.7吋
#define IS_iPhone_6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) : NO)

// iPhone6plus  iPhone7plus iPhone8plus 5.5吋
#define IS_iPhone6_Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

// iPhoneX 5.8吋
#define IS_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// iPhoneXr 6.1吋
#define IS_iPhoneXr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)

// iPhoneXs 5.8吋
#define IS_iPhoneXs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

// iPhoneXs Max 6.5吋
#define IS_iPhoneXs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)

/*********************************************************************************/
/*               iPhone X 以后机型判断             */
/*********************************************************************************/

#define IS_iPhoneX_Later    IS_iPhoneX || IS_iPhoneXr || IS_iPhoneXs || IS_iPhoneXs_Max


/*********************************************************************************/
/*               statusBar             */
/*********************************************************************************/
#define StatusBar_H \
({\
CGFloat h = 0; \
if (IS_iPhoneX_Later) { \
h = 44.0; \
}else {  \
h = 20.0f;\
} \
(h); \
})


/*********************************************************************************/
/*               tabBar             */
/*********************************************************************************/
#define TabBar_H \
({\
CGFloat h = 0; \
if (IS_iPhoneX_Later) { \
h = 49.0 + 34.0; \
}else {  \
h = 49.0f;\
} \
(h); \
})


/*********************************************************************************/
/*               navigationBar             */
/*********************************************************************************/
#define NavigationBar_H \
({\
CGFloat h = 0; \
if (IS_iPhoneX_Later) { \
h = 44.0 + 44.0; \
}else {  \
h = 44.0 + 20.0;\
} \
(h); \
})

/*********************************************************************************/
/*               当滚动时 改变的导航栏高度             */
/*********************************************************************************/
#define Scroll_H \
({\
CGFloat h = 0; \
if (IS_iPhoneX_Later) { \
h = 50.0; \
}else {  \
h = 44.0;\
} \
(h); \
})

#endif /* Macro_Device_h */

