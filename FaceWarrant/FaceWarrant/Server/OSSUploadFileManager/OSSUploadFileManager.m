//
//  OSSUploadFileManager.m
//  NWMJ_B
//
//  Created by LHKH on 2018/5/17.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "OSSUploadFileManager.h"
#import <AliyunOSSiOS/OSSService.h>
#import <AliyunOSSiOS/OSSCompat.h>
#import "FWOSSConfigManager.h"
@interface OSSUploadFileManager ()
{
    OSSClient * client;
}

@end
@implementation OSSUploadFileManager

//初始化manager
+ (instancetype)sharedOSSManager
{
    return [[self alloc] init];
}


//异步上传单张
- (void)asyncOSSUploadImage:(UIImage *)image type:(NSString *)type phone:(NSString*)phone complete:(void(^)(NSString *imageUrl,UploadImageState state))complete
{
//    [self uploadImages:@[image] isAsync:YES type:type phone:phone complete:complete];
    [self getOSSToken:@"1" uploadImages:@[image] audio:@"" video:@"" isAsync:YES type:type phone:phone complete:complete];
}

//异步上传多张
- (void)asyncOSSUploadImages:(NSArray<UIImage *> *)images type:(NSString *)type phone:(NSString*)phone complete:(void(^)(NSString *imageUrls, UploadImageState state))complete
{
//    [self uploadImages:images isAsync:YES type:type phone:phone complete:complete];
    [self getOSSToken:@"1" uploadImages:images audio:@"" video:@"" isAsync:YES type:type phone:phone complete:complete];
}

//oss上传图片
- (void)uploadImages:(NSArray<UIImage *> *)images isAsync:(BOOL)isAsync type:(NSString *)type phone:(NSString*)phone complete:(void(^)(NSString *names, UploadImageState state))complete
{
    
//token鉴权
    NSString * OSS_token =  [USER_DEFAULTS objectForKey:UD_OSSTOKEN];

    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc]initWithAccessKeyId:OSS_AccessKey secretKeyId:OSS_SecretKey securityToken:OSS_token];
    client = [[OSSClient alloc] initWithEndpoint:OSS_EndPoint credentialProvider:credential];
    
//serverUrl鉴权
//    id<OSSCredentialProvider> credential = [[OSSAuthCredentialProvider alloc] initWithAuthServerUrl:FWBaseUrl];
//    client = [[OSSClient alloc] initWithEndpoint:OSS_EndPoint credentialProvider:credential];
    
//直传
//    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc]
//                                            initWithPlainTextAccessKey:OSS_AccessKey
//                                            secretKey:OSS_SecretKey];
//    client = [[OSSClient alloc] initWithEndpoint:OSS_EndPoint credentialProvider:credential];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.maxConcurrentOperationCount = images.count;
    
    NSMutableArray *callBackNames = [NSMutableArray array];
    int i = 0;
    for (UIImage *image in images) {
        if (image) {
            
            NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
                //任务执行
                OSSPutObjectRequest * put = [OSSPutObjectRequest new];
                put.bucketName = OSS_BucketName;
                NSString *objectKeys = [NSString stringWithFormat:@"%@/2%@%@.jpg",type,phone,[self getTimeNow]];
              
                put.objectKey = objectKeys;
                NSData *data = UIImageJPEGRepresentation(image, 0.3);
                put.uploadingData = data;
                
                OSSTask * putTask = [self->client putObject:put];
                [putTask waitUntilFinished]; // 阻塞直到上传完成
                [putTask continueWithBlock:^id(OSSTask *task) {
                    task = [self->client presignPublicURLWithBucketName:OSS_BucketName
                                                    withObjectKey:objectKeys];
                    if (!task.error) {
                        OSSPutObjectResult * result = task.result;
                        DLog(@"upload success task.result ---%@",result);
                        NSString *fileUrl = [NSString stringWithFormat:@"%@%@",FW_IMAGE_SERVER_DOMAIN, put.objectKey];
                        [callBackNames addObject:fileUrl];
                    } else {
                        DLog(@"upload failed, task.error: %@" , task.error);
                    }
                    return nil;
                }];
                
                OSSPutObjectResult * result = putTask.result;
                if (!putTask.error) {
                    NSLog(@"upload success putTask.result ---%@",result);
                } else {
                    NSLog(@"upload object failed, putTask.error: %@" , putTask.error);
                    NSLog(@"Result ---- %@",result.requestId);
                }
                
                if (isAsync) {
                    if (image == images.lastObject) {
                        if (complete) {
                            NSString *urlstr = [callBackNames componentsJoinedByString:@","];
                            
                            complete(urlstr ,UploadImageSuccess);
                        }else{
                            complete(nil ,UploadImageFailed);
                        }
                    }
                }
            }];
            if (queue.operations.count != 0) {
                [operation addDependency:queue.operations.lastObject];
            }
            [queue addOperation:operation];
        }
        i++;
    }
}

- (void)asyncOSSUploadAudio:(NSString *)pathString complete:(void (^)(NSString *, UploadImageState))complete
{
//    [self uploadAudio:pathString isAsync:YES complete:complete];
    [self getOSSToken:@"2" uploadImages:nil audio:pathString video:@"" isAsync:YES type:nil phone:nil complete:complete];
}

- (void)asyncOSSUploadVideo:(NSString *)pathString complete:(void (^)(NSString *, UploadImageState))complete
{
//    [self uploadVideo:pathString isAsync:YES complete:complete];
    [self getOSSToken:@"3" uploadImages:nil audio:@"" video:pathString isAsync:YES type:nil phone:nil complete:complete];
}

//oss上传
- (void)uploadAudio:(NSString*)pathString isAsync:(BOOL)isAsync complete:(void(^)(NSString *names, UploadImageState state))complete
{

//    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc]
//                                            initWithPlainTextAccessKey:OSS_AccessKey
//                                            secretKey:OSS_SecretKey];
//    client = [[OSSClient alloc] initWithEndpoint:OSS_EndPoint credentialProvider:credential];
    
    NSString * OSS_token =  [USER_DEFAULTS objectForKey:UD_OSSTOKEN];
    
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc]initWithAccessKeyId:OSS_AccessKey secretKeyId:OSS_SecretKey securityToken:OSS_token];
    client = [[OSSClient alloc] initWithEndpoint:OSS_EndPoint credentialProvider:credential];
    
    //任务执行
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = OSS_BucketName;
    
    NSURL *recordedFile = [NSURL fileURLWithPath:pathString];
    NSString *objectKeys = [NSString stringWithFormat:@"audio/2%@%@.amr",[USER_DEFAULTS objectForKey:UD_UserPhone],[self getTimeNow]];
    put.objectKey = objectKeys;
    //    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    //    put.uploadingData = data;
    put.uploadingFileURL = recordedFile;
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        task = [self->client presignPublicURLWithBucketName:OSS_BucketName
                                        withObjectKey:objectKeys];
        if (!task.error) {
            OSSPutObjectResult * result = task.result;
            DLog(@"upload success Result ---%@",result);
            
            
            OSSGetObjectRequest * request = [OSSGetObjectRequest new];
            request.bucketName = OSS_BucketName;
            request.objectKey = objectKeys;
            //                    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            //
            //                        NSLog(@"--->---->%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
            //
            //                    };
            OSSTask * getTask = [self->client getObject:request];
            [getTask continueWithBlock:^id(OSSTask *task) {
                task = [self->client presignPublicURLWithBucketName:OSS_BucketName
                                                withObjectKey:objectKeys];
                if (!task.error) {
                    OSSGetObjectResult * result = task.result;
                    
                    if (isAsync) {
                            if (complete) {
                                NSString *urlstr = [NSString stringWithFormat:@"%@",result];
                                complete(urlstr ,UploadImageSuccess);
                            }else{
                                complete(nil ,UploadImageFailed);
                            }
                        }
                    NSLog(@"download success Result ---%@",result);
                    
                } else {
                    
                    NSLog(@"download failed, error: %@" ,task.error);
                    
                }
                return nil;
            }];
        } else {
            DLog(@"upload failed, error: %@" , task.error);
        }
        return nil;
    }];
}

- (void)uploadVideo:(NSString*)pathString isAsync:(BOOL)isAsync complete:(void(^)(NSString *names, UploadImageState state))complete
{
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc]
                                            initWithPlainTextAccessKey:OSS_AccessKey
                                            secretKey:OSS_SecretKey];
    client = [[OSSClient alloc] initWithEndpoint:OSS_EndPoint credentialProvider:credential];
    
    //任务执行
    OSSPutObjectRequest * put = [OSSPutObjectRequest new];
    put.bucketName = OSS_BucketName;
    
    NSURL *recordedFile = [NSURL fileURLWithPath:pathString];
    NSString *objectKeys = [NSString stringWithFormat:@"video/2%@%@.mp4",[USER_DEFAULTS objectForKey:UD_UserPhone],[self getTimeNow]];
    
    put.objectKey = objectKeys;
    //    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    //    put.uploadingData = data;
    put.uploadingFileURL = recordedFile;
    OSSTask * putTask = [client putObject:put];
    [putTask continueWithBlock:^id(OSSTask *task) {
        task = [self->client presignPublicURLWithBucketName:OSS_BucketName
                                              withObjectKey:objectKeys];
        if (!task.error) {
            OSSPutObjectResult * result = task.result;
            DLog(@"upload success Result ---%@",result);
            
            
            OSSGetObjectRequest * request = [OSSGetObjectRequest new];
            request.bucketName = OSS_BucketName;
            request.objectKey = objectKeys;
            //                    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
            //
            //                        NSLog(@"--->---->%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
            //
            //                    };
            OSSTask * getTask = [self->client getObject:request];
            [getTask continueWithBlock:^id(OSSTask *task) {
                task = [self->client presignPublicURLWithBucketName:OSS_BucketName
                                                withObjectKey:objectKeys];
                if (!task.error) {
                    OSSGetObjectResult * result = task.result;
                    
                    if (isAsync) {
                        if (complete) {
                            NSString *urlstr = [NSString stringWithFormat:@"%@",result];
                            complete(urlstr ,UploadImageSuccess);
                        }else{
                            complete(nil ,UploadImageFailed);
                        }
                    }
                    NSLog(@"download success Result ---%@",result);
                    
                } else {
                    
                    NSLog(@"download failed, error: %@" ,task.error);
                    
                }
                return nil;
            }];
        } else {
            DLog(@"upload failed, error: %@" , task.error);
        }
        return nil;
    }];
}

//删除保存在oss上面的图片
- (void)asyncOSSDeleteImageWithImageUrl:(NSString *)imageUrl
{
    [self deleteImageWithImageUrl:imageUrl];
}

//删除保存在oss上面的图片
- (void)deleteImageWithImageUrl:(NSString *)imageUrl
{
    /*
    NSString * OSS_token =  [USER_DEFAULTS objectForKey:UD_OSSTOKEN];
    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc]initWithAccessKeyId:OSS_AccessKey secretKeyId:OSS_SecretKey securityToken:OSS_token];
    client = [[OSSClient alloc] initWithEndpoint:OSS_EndPoint credentialProvider:credential];
    OSSDeleteObjectRequest * delete = [OSSDeleteObjectRequest new];
    delete.bucketName = OSS_BucketName;
    NSInteger start = [imageUrl rangeOfString:FW_IMAGE_SERVER_DOMAIN].length;
    delete.objectKey = [imageUrl substringFromIndex:start];
    OSSTask * deleteTask = [client deleteObject:delete];
    [deleteTask continueWithBlock:^id(OSSTask *task) {
        if (!task.error) {
            DLog(@"---->删除成功");
        }else{
            DLog(@"error---%@",task.error);
        }
        return nil;
    }];*/
    NSInteger start = [imageUrl rangeOfString:FW_IMAGE_SERVER_DOMAIN].length;
    NSDictionary *param = @{@"imageId":[imageUrl substringFromIndex:start]};
    [FWOSSConfigManager deleteOSSfile:param result:^(id response) {
        if (response[@"StatusCode"] && [response[@"StatusCode"] isEqualToString:@"200"]) {
            DLog(@"---->删除成功");
        }
    }];
}


//异步下载
- (void)asyncOSSDownloadImg:(NSString *)objectKeys
{
    
//获取token传
//    NSString * OSS_token =  [USER_DEFAULTS objectForKey:UD_OSSTOKEN];
//
//    id<OSSCredentialProvider> credential = [[OSSStsTokenCredentialProvider alloc]initWithAccessKeyId:OSS_AccessKey secretKeyId:OSS_SecretKey securityToken:OSS_token];
    
    //直传
    id<OSSCredentialProvider> credential = [[OSSPlainTextAKSKPairCredentialProvider alloc]
                                                initWithPlainTextAccessKey:OSS_AccessKey
                                                secretKey:OSS_SecretKey];
    client = [[OSSClient alloc] initWithEndpoint:OSS_EndPoint credentialProvider:credential];
    
    
    OSSGetObjectRequest * request = [OSSGetObjectRequest new];
    request.bucketName = OSS_BucketName;
    request.objectKey = objectKeys;
    request.downloadProgress = ^(int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
        
        NSLog(@"--->---->%lld, %lld, %lld", bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        
    };
    OSSTask * getTask = [client getObject:request];
    [getTask continueWithBlock:^id(OSSTask *task) {
        task = [self->client presignPublicURLWithBucketName:OSS_BucketName
                                        withObjectKey:objectKeys];
        if (!task.error) {
            OSSPutObjectResult * result = task.result;
            
            NSLog(@"download success Result ---%@",result);
            
        } else {
            
            NSLog(@"download failed, error: %@" ,task.error);
            
        }
        return nil;
    }];
}



//获取到sts
- (void)getOSSToken:(NSString*)typeStr uploadImages:(NSArray<UIImage *> *)images audio:(NSString*)audioPath video:(NSString*)videoPath isAsync:(BOOL)isAsync type:(NSString*)type phone:(NSString*)phone complete:(void (^)(NSString *, UploadImageState))complete
{
    [FWOSSConfigManager loadOSSGetSTSToken:nil result:^(id response) {
        if (response[@"StatusCode"] && [response[@"StatusCode"] isEqualToString:@"200"]) {
            [USER_DEFAULTS setObject:response[@"SecurityToken"] forKey:UD_OSSTOKEN];
            [USER_DEFAULTS setObject:response[@"AccessKeyId"] forKey:@"OSS_accessKeyId"];
            [USER_DEFAULTS setObject:response[@"AccessKeySecret"] forKey:@"OSS_accessKeySecret"];
            if ([typeStr isEqualToString:@"1"]) {
                [self uploadImages:images isAsync:isAsync type:type phone:phone complete:complete];
            }else if ([typeStr isEqualToString:@"2"]){
                [self uploadAudio:audioPath isAsync:isAsync complete:complete];
            }else if ([typeStr isEqualToString:@"3"]){
                [self uploadVideo:videoPath isAsync:isAsync complete:complete];
            }
        }
    }];
    
}

//返回当前时间
- (NSString *)getTimeNow
{
    NSString* date;
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYYMMddhhmmssSSS"];
    date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    return timeNow;
}
@end
