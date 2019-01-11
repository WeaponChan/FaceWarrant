//
//  FWPickerView.m
//  FaceWarrant
//
//  Created by FW on 2018/8/30.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#define PICKVIEW_HEIGHT 216.0f
#import "FWPickerView.h"
#import "FWProvinceModel.h"
@interface FWPickerView()<UIPickerViewDataSource,UIPickerViewDelegate>
//@property (nonatomic, strong) NSDictionary *pickerData;
@property (nonatomic, strong) NSMutableArray *pickerData;

@end

@implementation FWPickerView
//+ (instancetype)pickerView:(NSDictionary *)dataSource {
//    return [[[self class] alloc] initWithDataSource:dataSource];
//}
//
//
//- (instancetype)initWithDataSource:(NSDictionary *)dataSource {
//    if (self = [super init]) {
//        self.pickerData = dataSource;
//        self.frame = CGRectMake(0, 0, 0, PICKVIEW_HEIGHT);
//        self.dataSource = self;
//        self.delegate = self;
//
//        self.selectedTitle = [[self.pickerData objectForKey:@(0)] objectAtIndex:0];
//    }
//    return self;
//}

+ (instancetype)pickerView {
    return [[[self class] alloc] initWithFrame:CGRectMake(0, 0, 0, PICKVIEW_HEIGHT)];
}


- (void)pickerView:(NSArray *)pickerData
{
    [self.pickerData removeAllObjects];
    [self.pickerData addObjectsFromArray:pickerData];
    self.frame = CGRectMake(0, 0, 0, PICKVIEW_HEIGHT);
    self.dataSource = self;
    self.delegate = self;
    FWProvinceModel *model = self.pickerData[0];
    self.selectedTitle = model.name;
    self.selectedId = model.ID;    
}


#pragma mark <UIPickerViewDataSource>
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.pickerData.count;
}


#pragma mark <UIPickerViewDelegate>
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component __TVOS_PROHIBITED
{
    FWProvinceModel *model = self.pickerData[row];
    NSString *title = model.name;
    return title;
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component __TVOS_PROHIBITED
{
    FWProvinceModel *model = self.pickerData[row];
    self.selectedTitle = model.name;
    self.selectedId = model.ID;
}

- (NSMutableArray*)pickerData
{
    if (_pickerData == nil) {
        _pickerData = [NSMutableArray array];
    }
    return _pickerData;
}

@end

