//
//  LhkhIFlyMSCManager.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/11.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IFlyMSC/IFlyMSC.h"
#import "IATConfig.h"
#import "ISRDataHelper.h"
#import "PopupView.h"

@interface LhkhIFlyMSCManager : NSObject <IFlySpeechRecognizerDelegate>
@property (strong, nonatomic) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property (strong, nonatomic) PopupView *popUpView;
@property (strong, nonatomic) NSString *vctype;

@property(nonatomic,copy)void(^onResult)(NSString*);
+ (id)shareManager;
- (void)recognitionBlock:(void(^)(NSString*))block vctype:(NSString*)vctype;
- (void)stopRecognition;
@end
