//
//  FWVoiceView.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/10.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FWVoiceViewDelegate <NSObject>
- (void)FWVoiceViewDelegateWithText:(NSString*)text;
@end
@interface FWVoiceView : UIView
@property (copy, nonatomic)NSString *vctype;
@property (weak, nonatomic)id<FWVoiceViewDelegate>delegate;
@end
