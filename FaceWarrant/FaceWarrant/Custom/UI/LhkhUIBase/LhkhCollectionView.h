//
//  LhkhCollectionView.h
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/11.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface LhkhCollectionView : UIView
- (instancetype)initWithFrame:(CGRect)frame vcType:(NSString*)vctype selectType:(NSInteger)selectType;
- (void)refreshData:(NSString*)vctype;
@end
