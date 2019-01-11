//
//  FWAddAttentionMoreVC.h
//  FaceWarrant
//
//  Created by FW on 2018/9/11.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWBaseViewController.h"
#import "FWFaceLibraryClassifyModel.h"

@interface FWAddAttentionMoreVC : FWBaseViewController
@property (strong, nonatomic)FWFaceLibraryClassifyModel *model;
@property (copy, nonatomic)NSString *searchText;
@property (copy, nonatomic)NSString *searchType;//0 表示除亲友face的其他face  1表示亲友face
@property (copy, nonatomic)NSString *contactStr;
@property (copy, nonatomic)NSString *moreType;//0 大Face上面的更多 1表示我的关注更多  2表示通讯录更多 3表示推荐
@property (copy, nonatomic)NSString *type;// 0表示搜索  1表示更多

@end
