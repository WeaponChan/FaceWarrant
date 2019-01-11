//
//  LhkhVoiceRecognitionView.h
//  FaceWarrant
//
//  Created by FW on 2018/11/1.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LhkhVoiceRecognitionViewDelegate <NSObject>
- (void)LhkhVoiceRecognitionViewDelegateWithText:(NSString*)text;
@end
@interface LhkhVoiceRecognitionView : UIView
@property (copy, nonatomic)NSString *vctype;
@property (weak, nonatomic)id<LhkhVoiceRecognitionViewDelegate>delegate;
@end
