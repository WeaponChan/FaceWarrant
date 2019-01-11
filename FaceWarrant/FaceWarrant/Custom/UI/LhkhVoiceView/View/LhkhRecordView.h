//
//  LhkhRecordView.h
//  FaceWarrant
//
//  Created by FW on 2018/11/1.
//  Copyright © 2018 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol LhkhRecordViewDelegate <NSObject>
- (void)LhkhRecordViewDelegateCancelClick;
- (void)LhkhRecordViewDelegateAudio:(NSString*)audioUrl audioTime:(NSString*)audioTime;
@end
@interface LhkhRecordView : UIView
@property (weak,nonatomic)id<LhkhRecordViewDelegate>delegate;
@end
