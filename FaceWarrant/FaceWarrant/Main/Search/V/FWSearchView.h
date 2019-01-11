//
//  FWSearchView.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/6/27.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FWSearchViewDelegate <NSObject>
- (void)FWSearchViewDelegateWithTextViewBeginEditing;
- (void)FWSearchViewDelegateWithText:(NSString*)text;
- (void)FWSearchViewDelegateVoiceClick;
- (void)FWSearchViewDelegateBtnClick;
@end
@interface FWSearchView : UIView
@property (strong, nonatomic)LhkhTextField *searchText;
@property (copy, nonatomic)NSString *vcStr;
@property (copy, nonatomic)NSString *typeStr;
@property (strong, nonatomic)UIButton *clickBtn;
@property (assign, nonatomic)NSInteger index;
@property (weak, nonatomic)id<FWSearchViewDelegate>delegate;
@end
