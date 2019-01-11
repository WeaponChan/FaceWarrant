//
//  FWMapCell.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/11.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#import "FWMapCell.h"
#import "UIButton+Lhkh.h"
#import "FWShopModel.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "FWHomeManager.h"
@interface FWMapCell ()
{
    NSString *_fromAddr;
}
@property (strong, nonatomic)UILabel *itemLab;
@property (strong, nonatomic)UILabel *addrLab;
@property (strong, nonatomic)UILabel *descLab;
@property (strong, nonatomic)UIButton *cellBtn;
@property (strong, nonatomic)UIButton *phoneBtn;
@property (strong, nonatomic)UIButton *pathBtn;
@property (strong, nonatomic)FWShopModel *model;
@property (strong, nonatomic)NSIndexPath *indexPath;
@property (strong, nonatomic)NSArray *maps;
@end

@implementation FWMapCell

#pragma mark - Life Cycle

static NSString * const kCellID = @"FWMapCell";

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    FWMapCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    if (!cell) {
        cell = [[FWMapCell alloc] initWithStyle:0 reuseIdentifier:kCellID];
    }
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.itemLab];
        [self.contentView addSubview:self.addrLab];
        [self.contentView addSubview:self.descLab];
        [self.contentView addSubview:self.cellBtn];
        [self.contentView addSubview:self.phoneBtn];
        [self.contentView addSubview:self.pathBtn];
        [self layoutCustomViews];
    }
    return self;
}


#pragma mark - Layout SubViews

- (void)layoutCustomViews
{
    [self.itemLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(20);
        make.top.equalTo(self.contentView).offset(15);
        make.left.equalTo(self.contentView).offset(10);
    }];
    
    [self.pathBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(50);
        make.height.offset(50);
        make.right.equalTo(self.contentView);
//        make.top.equalTo(self.itemLab);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [_pathBtn centerImageAndTitleWithSpace:15];
    
    [self.phoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(50);
        make.height.offset(50);
        make.right.equalTo(self.pathBtn.mas_left);
//        make.top.equalTo(self.itemLab);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    [_phoneBtn centerImageAndTitleWithSpace:15];
    
    [self.addrLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(self.itemLab.mas_bottom).offset(5);
        make.left.equalTo(self.itemLab);
        make.right.equalTo(self.phoneBtn.mas_left);
    }];
    
    [self.descLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(15);
        make.top.equalTo(self.addrLab.mas_bottom).offset(5);
        make.left.equalTo(self.itemLab);
        make.right.equalTo(self.phoneBtn.mas_left);
    }];
    
    [self.cellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.addrLab.mas_right);
    }];
}


#pragma mark - System Delegate




#pragma mark - Custom Delegate




#pragma mark - Event Response

- (void)cellClick
{
    DLog(@"cell");
    if ([self.delegate respondsToSelector:@selector(FWMapCellDelegateCellClick:)]) {
        [self.delegate FWMapCellDelegateCellClick:self.indexPath];
    }
}

- (void)deitClick
{
    if (self.model.storeMobile == nil || [self.model.storeMobile isEqualToString:@""]) {
        [MBProgressHUD showTips:@"商户没有预留电话额"];
    }else{
        NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.model.storeMobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        [self pushPhoneAndNavi:self.model.storeId type:@"0"];
    }
}

- (void)pathClick
{
    CLLocationCoordinate2D gps = CLLocationCoordinate2DMake(self.model.latitude.doubleValue, self.model.longitude.doubleValue);
    self.maps = [self getInstalledMapAppWithAddr:self.model.storeAddress withEndLocation:gps];
    [self alertAmaps:gps];
}


#pragma mark - Network requests

- (void)pushPhoneAndNavi:(NSString*)storeId type:(NSString*)type
{
    NSDictionary *param = @{
                            @"userId":[USER_DEFAULTS objectForKey:UD_UserID],
                            @"storeId":storeId,
                            @"type":type,
                            @"fromAddress":_fromAddr?:@"",
                            @"fromLongitude":self.model.longitude?:@"",
                            @"fromLatitude":self.model.latitude?:@""
                            };
    [FWHomeManager pushPhoneAndNaviWithParameter:param result:^(id response) {
        if (response[@"success"] && [response[@"success"] isEqual:@1]) {
            if ([type isEqualToString:@"0"]) {
                int times = self.phoneBtn.titleLabel.text.intValue;
                times++;
                [self.phoneBtn setTitle:[NSString stringWithFormat:@"%d次",times] forState:UIControlStateNormal];
            }else{
                int times = self.pathBtn.titleLabel.text.intValue;
                times++;
                [self.pathBtn setTitle:[NSString stringWithFormat:@"%d次",times] forState:UIControlStateNormal];
            }
        }
    }];
}


#pragma mark - Public Methods

- (void)configCellWithModel:(FWShopModel*)model  fromAddr:(NSString *)fromAddr indexPath:(NSIndexPath*)indexPath
{
    self.model = model;
    self.indexPath = indexPath;
    _fromAddr = fromAddr;
    self.itemLab.text = model.storeName;
    if (model.distance.floatValue<1000) {
        self.addrLab.text = [NSString stringWithFormat:@"%@m %@",model.distance,model.storeAddress];
    }else{
        self.addrLab.text = [NSString stringWithFormat:@"%.2fkm %@",model.distance.floatValue/1000,model.storeAddress];
    }
    if (model.storePromotion == nil || [model.storePromotion isEqualToString:@""]) {
        self.descLab.text = @"暂无优惠活动";
    }else{
        self.descLab.text = model.storePromotion;
    }
    
    [self.phoneBtn setTitle:StringConnect(model.phoneCount, @"次") forState:UIControlStateNormal];
    [self.pathBtn setTitle:StringConnect(model.navigationCount, @"次") forState:UIControlStateNormal];
}


#pragma mark - Private Methods

- (NSArray *)getInstalledMapAppWithAddr:(NSString *)addrString withEndLocation:(CLLocationCoordinate2D)endLocation
{
    
    NSMutableArray *maps = [NSMutableArray array];
    //苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    iosMapDic[@"address"] = addrString;
    [maps addObject:iosMapDic];
    NSString *appStr = NSLocalizedString(@"app_name", nil);
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        CLLocationCoordinate2D ggLocation = [self getGaoDeCoordinateByBaiDuCoordinate:endLocation];
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&did=BGVIS2&dname=%@&dev=0&t=2&dlat=%lf&dlon=%lf",appStr ,addrString, ggLocation.latitude, ggLocation.longitude] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?location=%f,%f&origin=我的位置&destination=%@&mode=walking&src=%@", endLocation.latitude, endLocation.longitude,addrString ,appStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        CLLocationCoordinate2D ggLocation = [self getGaoDeCoordinateByBaiDuCoordinate:endLocation];
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=walk&tocoord=%f,%f&to=%@&coord_type=1&policy=0",ggLocation.latitude , ggLocation.longitude ,addrString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        CLLocationCoordinate2D ggLocation = [self getGaoDeCoordinateByBaiDuCoordinate:endLocation];
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?x-source=%f&x-success=%f&saddr=&daddr=%@&directionsmode=walking",ggLocation.latitude,ggLocation.longitude,addrString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    
    return maps;
}

- (void)alertAmaps:(CLLocationCoordinate2D)gps

{
    if (self.maps.count == 0) {
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.maps.count; i++) {
        if (i == 0) {
            [alertVC addAction:[UIAlertAction actionWithTitle:self.maps[i][@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self navAppleMap:gps address:self.maps[i][@"address"]];
                [self pushPhoneAndNavi:self.model.storeId type:@"1"];
            }]];
        }else{
            [alertVC addAction:[UIAlertAction actionWithTitle:self.maps[i][@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self otherMap:i];
                [self pushPhoneAndNavi:self.model.storeId type:@"1"];
            }]];
        }
        
    }
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [[self superViewController:self] presentViewController:alertVC animated:YES completion:nil];
}

// 苹果地图
- (void)navAppleMap:(CLLocationCoordinate2D)gps address:(NSString *)address
{
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    CLLocationCoordinate2D ggLocation = [self getGaoDeCoordinateByBaiDuCoordinate:gps];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:ggLocation addressDictionary:[NSDictionary dictionaryWithObject:address forKey:@"name"]]];
    NSArray *items = @[currentLoc,toLocation];
    NSDictionary *dic = @{
                          MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,
                          MKLaunchOptionsMapTypeKey: @(MKMapTypeStandard),
                          MKLaunchOptionsShowsTrafficKey: @(YES)
                          };
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

///  第三方地图
- (void)otherMap:(NSInteger)index

{
    NSDictionary *dic = self.maps[index];
    NSString *urlString = dic[@"url"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}


- (UIViewController *)superViewController:(UIView *)view{
    
    UIResponder *responder = view;
    while ((responder = [responder nextResponder]))
        if ([responder isKindOfClass: [UIViewController class]])
            return (UIViewController *)responder;
    
    return nil;
}

// 百度地图经纬度转换为火星坐标
- (CLLocationCoordinate2D)getGaoDeCoordinateByBaiDuCoordinate:(CLLocationCoordinate2D)coordinate
{
    double x_pi = 3.1415926358979324*3000.0/180.0;
    double x = coordinate.longitude-0.0065;
    double y = coordinate.latitude-0.006;
    double z = sqrt(x*x + y*y)-0.00002*sin(y*x_pi);
    double theta = atan2(y, x) - 0.000003*cos(x*x_pi);
    double gg_lon = z * cos(theta);
    double gg_lat = z * sin(theta);
    return CLLocationCoordinate2DMake(gg_lat, gg_lon);
}

#pragma mark - Setters

- (UILabel *)itemLab
{
    if (_itemLab == nil) {
        _itemLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _itemLab.text = @"附近商场";
        _itemLab.textColor = Color_MainText;
        _itemLab.font = systemFont(16);
    }
    return _itemLab;
}

- (UILabel *)addrLab
{
    if (_addrLab == nil) {
        _addrLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _addrLab.textColor = Color_SubText;
        _addrLab.font = systemFont(12);
    }
    return _addrLab;
}
- (UILabel *)descLab
{
    if (_descLab == nil) {
        _descLab = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLab.textColor = Color_MainText;
        _descLab.font = systemFont(12);
    }
    return _descLab;
}

- (UIButton *)cellBtn
{
    if (_cellBtn == nil) {
        _cellBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cellBtn addTarget:self action:@selector(cellClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cellBtn;
}


- (UIButton*)phoneBtn
{
    if (_phoneBtn == nil) {
        _phoneBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_phoneBtn setTitleColor:[UIColor colorWithHexString:@"2c2c2c"] forState:UIControlStateNormal];
        _phoneBtn.titleLabel.font = systemFont(12);
        [_phoneBtn setImage:[UIImage imageNamed:@"phone"] forState:UIControlStateNormal];
        _phoneBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_phoneBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_phoneBtn addTarget:self action:@selector(deitClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _phoneBtn;
}

- (UIButton*)pathBtn
{
    if (_pathBtn == nil) {
        _pathBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_pathBtn setTitleColor:[UIColor colorWithHexString:@"2c2c2c"] forState:UIControlStateNormal];
        _pathBtn.titleLabel.font = systemFont(12);
        _pathBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_pathBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [_pathBtn setImage:[UIImage imageNamed:@"loadline"] forState:UIControlStateNormal];
        [_pathBtn addTarget:self action:@selector(pathClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pathBtn;
}

#pragma mark - Getters



@end
