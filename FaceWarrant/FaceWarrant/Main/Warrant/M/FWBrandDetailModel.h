//
//  FWBrandDetailModel.h
//  FaceWarrant
//
//  Created by FW on 2018/9/4.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import <Foundation/Foundation.h>
//brandSynopsis :         adidas（阿迪达斯）创办于1949年，是德国运动用品制造商阿迪达斯AG成员公司。以其创办人阿道夫·阿迪·达斯勒（Adolf Adi Dassler）命名，1920年在黑措根奥拉赫开始生产鞋类产品。
//
//1949年8月18日以adidas AG名字登记。阿迪达斯原本由两兄弟共同开设，在分道扬成员公司。以其创办人阿道夫·阿迪·达斯勒（Adolf Adi Dassler）命名，1920年在黑措根奥拉赫开始生产鞋类产品。
//
//1949年8月18日以adidas AG名字登记。阿迪达斯原本由两兄弟共同开设，在分道扬\351镳后，阿道夫的哥哥鲁道夫·达斯勒 （Rudolf Dassler）开设了运动品牌puma。其经典广告语：“没有不可能”（Impossible is nothing）。
//
//2011年3月，斥资1.6亿欧元启用全新口号——adidas is all in（全倾全力）。阿迪达斯旗下拥有三大系列：运动表现系列 performance（三条纹）、运动传统系列 originals（三叶草）?和运动时尚系列 neo（圆球型LOGO）（分三个子品牌：Y-3，SLVR，NEO LABEL）。,
//brandUrl : http://image.facewarrant.com.cn/web/brand/121.png,
//disabled : 0,
//supplierId : 0,
//brandId : 121,
//brandName : Adidas 阿迪达斯
@interface FWBrandDetailModel : NSObject
@property(copy, nonatomic)NSString *brandSynopsis;
@property(copy, nonatomic)NSString *brandUrl;
@property(copy, nonatomic)NSString *brandAdvertising;
@property(copy, nonatomic)NSString *disabled;
@property(copy, nonatomic)NSString *supplierId;
@property(copy, nonatomic)NSString *brandId;
@property(copy, nonatomic)NSString *brandName;
@property(assign, nonatomic)BOOL isExpand;
@end
