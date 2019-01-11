//
//  APPVersionManager.h
//  MeiyaoniKH
//
//  Created by Jason on 2017/11/23.
//  Copyright © 2017年 ainisi. All rights reserved.
//

/*********************************************************************************/
/*               检测APP版本是否更新             */
/*********************************************************************************/

#import <Foundation/Foundation.h>

@interface APPVersionManager : NSObject

+ (instancetype)sharedInstance;

- (void)checkVersion:(id)target;

@end
