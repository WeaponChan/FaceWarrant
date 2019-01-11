//
//  JSDatePicker.h
//  MeiyaoniKH
//
//  Created by Jason on 16/10/25.
//  Copyright © 2016年 ainisi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JSDatePicker : UIDatePicker
@property (nonatomic, strong) NSString *currentDate;
/**构建日期选择器*/
+ (instancetype)datePicker;
@end
