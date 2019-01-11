//
//  FWPickerView.h
//  FaceWarrant
//
//  Created by FW on 2018/8/30.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FWPickerView : UIPickerView
/**当前选中的title*/
@property (nonatomic, strong) NSString *selectedTitle;
@property (nonatomic, strong) NSString *selectedId;

//*构造pickerView：传入的字典 最外层需满足 key -> component索引 ; value -> 实际数据模型
//+ (instancetype)pickerView:(NSDictionary *)pickerData;
//*构造pickerView：传入的数组
//+ (instancetype)pickerView:(NSArray *)pickerData;

+ (instancetype)pickerView;


- (void)pickerView:(NSArray *)pickerData;
@end
