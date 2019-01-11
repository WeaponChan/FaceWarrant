//
//  FWWarrantItemView.m
//  FaceWarrant
//
//  Created by FW on 2018/9/29.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWWarrantItemView.h"


@interface FWWarrantItemView()

@end

@implementation FWWarrantItemView

#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

+ (instancetype)shareWarrantItemView
{
    return [[NSBundle mainBundle] loadNibNamed:@"FWWarrantItemView" owner:self options:nil].firstObject;
}

#pragma mark - Layout SubViews


#pragma mark - System Delegate


#pragma mark - Custom Delegate


#pragma mark - Event Response

- (IBAction)itemClick:(UIButton *)sender {
//    if (sender.tag == 0) {
//
//    }else if (sender.tag == 1){
//        [[self superViewController:self].navigationController pushViewController:[FWPhotoVC new] animated:YES];
//    }else if (sender.tag == 2){
//        [[self superViewController:self].navigationController pushViewController:[FWCameraVC new] animated:YES];
//    }
    if ([self.delegate respondsToSelector:@selector(FWWarrantItemViewDelegateClickWithTag:)]) {
        [self.delegate FWWarrantItemViewDelegateClickWithTag:sender.tag];
    }
}

#pragma mark - Network Requests


#pragma mark - Public Methods


#pragma mark - Private Methods
- (UIViewController *)superViewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}

#pragma mark - Setters


#pragma mark - Getters



@end
