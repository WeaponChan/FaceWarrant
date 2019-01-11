//
//  LhkhIFlyMSCManager.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/11.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "LhkhIFlyMSCManager.h"
@implementation LhkhIFlyMSCManager
{
    NSString *endResultStr;
}
static LhkhIFlyMSCManager *manager=nil;
- (id)init
{
    if (self=[super init]) {
        
    }
    return self;
}


+ (id)shareManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (manager==nil) {
            manager=[[self alloc]init];
        }
    });
    return manager;
}


-(void)recognitionBlock:(void (^)(NSString *))block vctype:(NSString *)vctype{
    self.onResult=block;
    self.vctype = vctype;

    if (_iFlySpeechRecognizer == nil) {
        [self initRecognizer];
    }
    [_iFlySpeechRecognizer cancel];
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    //设置听说结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下（为了测试音频流识别用的）
    //[_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    [_iFlySpeechRecognizer setDelegate:self];
    
    BOOL ret = [_iFlySpeechRecognizer startListening];
    if (ret) {
        [_popUpView showText:@"启动成功"];
    }else{
        [_popUpView showText:@"启动失败"];
    }
}

- (void)stopRecognition
{
    [_iFlySpeechRecognizer stopListening];
}

//初始化识别参数
- (void)initRecognizer

{
    DLog(@"-----%s",__func__);
    //单利模式 无UI的实例
    if (self.iFlySpeechRecognizer==nil) {
        _iFlySpeechRecognizer=[IFlySpeechRecognizer sharedInstance];
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate=self;
    if (_iFlySpeechRecognizer!= nil) {
        IATConfig *instance=[IATConfig sharedInstance];
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:instance.speechTimeout forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:instance.vadEos forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:instance.vadBos forKey:[IFlySpeechConstant
                                                                    VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        //设置采样率，推荐16K
        [_iFlySpeechRecognizer setParameter:IATConfig.lowSampleRate forKey:[IFlySpeechConstant SAMPLE_RATE]];
        if ([instance.language isEqualToString:[IATConfig chinese]]) {
            //设置语言
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE]];
            //设置方言
            [_iFlySpeechRecognizer setParameter:instance.accent forKey:[IFlySpeechConstant ACCENT]];
        }else if([instance.language isEqualToString:[IATConfig english]]){
            [_iFlySpeechRecognizer setParameter:instance.language forKey:[IFlySpeechConstant LANGUAGE_ENGLISH]];
        }

        //设置是否返回标点符号
        instance.dot = self.vctype;
        [_iFlySpeechRecognizer setParameter:instance.dot forKey:[IFlySpeechConstant ASR_PTT]];
    }
}


#pragma mark -IFlySpeechRecognizerDelegate
//识别结果返回代理
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    NSMutableString *resultString=[[NSMutableString alloc]init];
    NSDictionary *dic=results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    NSString *result=[NSString stringWithFormat:@"%@",resultString];
    NSString *resultFromJson=[ISRDataHelper stringFromJson:resultString];
    DLog(@"++++++++_result=%@",result);
    DLog(@"++++++++resultFromJson=%@",resultFromJson);
    
    if (!endResultStr) {
        endResultStr = resultFromJson;
    }else{
        endResultStr = [NSString stringWithFormat:@"%@%@",endResultStr,resultFromJson];
    }
    if (isLast) {
        DLog(@"最终听说结果:%@",endResultStr);
        if (![endResultStr isEqualToString:@""] && endResultStr.length != 0 && endResultStr != nil) {
            self.onResult(endResultStr);
        }
        
        endResultStr = nil;
        _iFlySpeechRecognizer = nil;
    }
}

- (void)onCompleted:(IFlySpeechError *)errorCode
{
    DLog(@"IFlySpeechError->errorCode=%@------>%d",errorCode,errorCode.errorCode);
    
    if (errorCode.errorCode == 11200 || errorCode.errorCode == 11201) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showTips:@"语音识别拥堵，请手动输入"];
        });
    }
}

- (void) onEndOfSpeech
{
}

@end
