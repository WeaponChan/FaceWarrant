//
//  Macro_Image.h
//  LHKHBase
//
//  Created by LHKH on 2017/10/20.
//  Copyright © 2017年 LHKH. All rights reserved.
//

#ifndef Macro_Image_h
#define Macro_Image_h

/*********************************************************************************/
/*               网络图片URL             */
/*********************************************************************************/

#define URL(a)  [NSURL URLWithString:a]

/*********************************************************************************/
/*               设置图片             */
/*********************************************************************************/

#define Image(a)                       [UIImage imageNamed:a]

/*********************************************************************************/
/*               常用占位图片             */
/*********************************************************************************/

#define Image_placeHolder66                       [UIImage imageNamed:@"66x66"]
#define Image_placeHolder80                       [UIImage imageNamed:@"80x80"]
#define Image_placeHolder100                      [UIImage imageNamed:@"100x100"]
#define Image_placeHolder354                      [UIImage imageNamed:@"354x354"]

#endif /* Macro_Image_h */
