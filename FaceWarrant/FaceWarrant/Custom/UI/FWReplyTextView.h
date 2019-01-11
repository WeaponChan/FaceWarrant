//
//  FWReplyTextView.h
//  FaceWarrant
//
//  Created by FW on 2018/8/13.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FWReplyTextViewDelegate <NSObject>
- (void)FWReplyTextViewDelegateSendMessage:(NSString*)messageText;
- (void)FWReplyTextViewDelegateRecordClick;
- (void)FWReplyTextViewDelegateEditEndClick;
@end
@interface FWReplyTextView : UIView
@property (strong, nonatomic)UITextView *textView;
@property (strong, nonatomic)UILabel *placeholderLB;
@property (weak, nonatomic)id<FWReplyTextViewDelegate>delegate;

- (void)showView;
- (void)hideView;
@end
