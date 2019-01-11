//
//  JS_ClearCache.h
//  MeiYaoNi
//
//  Created by admin on 16/6/16.
//  Copyright © 2016年 Ainisi. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^clearCacheBlock)(void);

@interface JSCacheManager : NSObject

//计算单个文件大小
+ (CGFloat)fileSizeAtPath:(NSString *)path;

//计算目录大小
+ (CGFloat)folderSizeAtPath;

//清除缓存
+(void)clearCache:(clearCacheBlock)block;

@end
