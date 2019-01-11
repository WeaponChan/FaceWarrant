//
//  OSSUploadFileManager.h
//  NWMJ_B
//
//  Created by LHKH on 2018/5/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, UploadImageState) {
    UploadImageFailed   = 0,
    UploadImageSuccess  = 1
};
@interface OSSUploadFileManager : NSObject
+ (instancetype)sharedOSSManager;

//type HeadImage,WarrantImage

//上传单张图片
- (void)asyncOSSUploadImage:(UIImage *)image type:(NSString *)type phone:(NSString*)phone complete:(void(^)(NSString *imageUrl,UploadImageState state))complete;

//上传多张图片
- (void)asyncOSSUploadImages:(NSArray<UIImage *> *)images type:(NSString *)type phone:(NSString*)phone complete:(void(^)(NSString *imageUrls, UploadImageState state))complete;

//上传音频
- (void)asyncOSSUploadAudio:(NSString *)pathString complete:(void(^)(NSString *audioUrl,UploadImageState state))complete;

//上传短视频
- (void)asyncOSSUploadVideo:(NSString *)pathString complete:(void(^)(NSString *videoUrl,UploadImageState state))complete;

//删除
- (void)asyncOSSDeleteImageWithImageUrl:(NSString *)imageUrl;

//异步下载
- (void)asyncOSSDownloadImg:(NSString *)objectKeys;

@end
