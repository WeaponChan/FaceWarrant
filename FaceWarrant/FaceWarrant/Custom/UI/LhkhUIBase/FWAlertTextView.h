//
//  FWAlertTextView.h
//  FaceWarrant
//
//  Created by FW on 2018/8/28.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FWAlertTextView;

@protocol FWAlertTextViewDelegate <NSObject>

- (void)FWAlertTextViewDidClickCancelButton:(FWAlertTextView *)view;
- (void)FWAlertTextView:(FWAlertTextView *)view didClickConfirmButtonWithLabel:(NSString *)labelStr;

@end
@interface FWAlertTextView : UIView
+ (instancetype)defaultView;
@property (nonatomic, weak) id <FWAlertTextViewDelegate>delegate;
@end
