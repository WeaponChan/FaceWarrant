//
//  FWCommentBottomView.h
//  FaceWarrant
//
//  Created by FW on 2018/8/2.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FWCommentBottomViewDelegate <NSObject>
- (void)FWCommentBottomViewDelegateSendMessage:(NSString*)messageText indexPath:(NSIndexPath *)indexPath;
@end

@interface FWCommentBottomView : UIView
@property (strong, nonatomic)UITextView *textView;
@property (strong, nonatomic)UILabel *placeholderLB;
@property (strong, nonatomic)NSIndexPath *indexPath;
@property (weak, nonatomic)id<FWCommentBottomViewDelegate>delegate;

- (void)showView;
- (void)hideView;
@end
