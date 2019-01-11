//
//  LhkhVoiceView.h
//  FaceWarrant
//
//  Created by FW on 2018/11/1.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LhkhVoiceViewDelegate <NSObject>
- (void)LhkhVoiceViewDelegateWithText:(NSString*)text;
- (void)LhkhVoiceViewDelegateAudio:(NSString*)audioUrl audioTime:(NSString*)audioTime;
@end

@interface LhkhVoiceView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray*)titles;
@property (weak, nonatomic)id<LhkhVoiceViewDelegate>vdelegate;
@end
