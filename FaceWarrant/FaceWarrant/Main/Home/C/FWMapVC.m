//
//  FWMapVC.m
//  FaceWarrantDel
//
//  Created by LHKH on 2018/7/11.
//  Copyright © 2018年 LHKH. All rights reserved.
//

#define ShopCellHeight        (85)//cellH
#define startY                (Screen_H - ShopCellHeight)//tableview初始位置  显示一个cellH  582
#define middleY               (Screen_H - self.defaultCount * ShopCellHeight)//tableview滑到中间的位置  默认4个cellH  如果列表数据小于4个  直接取列表数量 327
#define topY                  (0)//tableview滑到最上面 0



#import "FWMapVC.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>
#import <BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "FWMapCell.h"
#import "FWHomeManager.h"
#import "FWShopModel.h"
//#import <CoreLocation/CLLocationManager.h>
static int page = 1;
@interface FWMapVC()<BMKMapViewDelegate,BMKLocationServiceDelegate,
BMKGeoCodeSearchDelegate,UIGestureRecognizerDelegate,UITableViewDelegate, UITableViewDataSource,FWMapCellDelegate>
{
    
    BMKLocationService *_locService;
    BMKMapView* _mapView;
    BMKGeoCodeSearch *_geoCodeSearch;
    BMKPointAnnotation *_LocalAnnotation;//我的位置
    BMKPointAnnotation *_FirstAnnotation;//数据列表第一个位置
    BMKAnnotationView  *_curAnnitationView;//当前头标位置
    NSMutableArray *_annotations;
    CGFloat _lat;
    CGFloat _lon;
    NSString *_curAddr;//我的地址
    
    
    NSIndexPath *_selindexPath;
}
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) UIView *bottomView;
@property (nonatomic, assign) NSInteger defaultCount;
@property(strong, nonatomic) NSMutableArray *shopList;
@property (assign, nonatomic) CGFloat marginTop;
@property (nonatomic, strong) UISwipeGestureRecognizer  *upswipe;// 上轻扫手势
@property (nonatomic, strong) UISwipeGestureRecognizer  *downswipe;// 下轻扫手势
@end

@implementation FWMapVC

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setNav];
    [self setSubView];
    [self setupBMKLocation];
    [self setTableView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _locService.delegate = self;
    _mapView.delegate = self;
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _locService.delegate = nil;
    _mapView.delegate = nil;
}

#pragma mark - Layout SubViews




#pragma mark - System Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.shopList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FWMapCell *cell = [FWMapCell cellWithTableView:tableView];
    cell.delegate = self;
    FWShopModel *model = self.shopList[indexPath.section];
    [cell configCellWithModel:model fromAddr:_curAddr indexPath:indexPath];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ShopCellHeight;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.marginTop != scrollView.contentInset.top) {
        self.marginTop = scrollView.contentInset.top;
    }
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat newoffsetY = offsetY + self.marginTop;

    if (newoffsetY <-NavigationBar_H) {
        self.tableView.scrollEnabled = NO;
        [UIView animateWithDuration:0.3 animations:^{
            [self changeMapViewFrame:CGRectMake(0, 0, Screen_W, startY)];
            self.tableView.frame = CGRectMake(0, startY, Screen_W, ShopCellHeight);
        }];
    }
}


/**
 返回值为NO  swipe不响应手势 table响应手势
 返回值为YES swipe、table也会响应手势, 但是把table的scrollEnabled为No就不会响应table了
 */
#pragma mark 解决手势冲突的相关问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    // 当table Enabled且offsetY不为0时，让swipe响应
    if (self.tableView.scrollEnabled == YES && self.tableView.contentOffset.y != -NavigationBar_H) {
        return NO;
    }
    if (self.tableView.scrollEnabled == YES) {
        return YES;
    }
    return YES;
}


#pragma mark - Custom Delegate

#pragma mark - FWMapCellDelegate

- (void)FWMapCellDelegateCellClick:(NSIndexPath *)indexPath
{
    _selindexPath = indexPath;
    BMKPointAnnotation * annotation = _annotations[indexPath.section];
    [self changeSingleStoreList];
    _mapView.centerCoordinate = annotation.coordinate;
    [_mapView selectAnnotation:annotation animated:YES];
}

#pragma mark - BMKLocationServiceDelegate 实现相关delegate 处理位置信息更新

- (BMKAnnotationView*)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {

        static NSString *AnnotationViewID = @"annotationViewID";
        BMKAnnotationView *newAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (newAnnotationView == nil)
        {
            newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            if (annotation == _LocalAnnotation) {
                newAnnotationView.image = [UIImage imageNamed:@"location"];
            }else{
                if (annotation.coordinate.latitude == _FirstAnnotation.coordinate.latitude) {
                    newAnnotationView.selected = YES;
                    newAnnotationView.image = [UIImage imageNamed:@"shopSel"];
                }else{
                    newAnnotationView.selected = NO;
                    newAnnotationView.image = [UIImage imageNamed:@"shop"];
                }
                
            }
        }
        //设置中心点偏移，使得标注底部中间点成为经纬度对应点
        //newAnnotationView.centerOffset = CGPointMake(0, -18);
        
        _curAnnitationView = newAnnotationView;
        newAnnotationView.annotation = annotation;
        newAnnotationView.canShowCallout = YES;
        newAnnotationView.draggable      = NO;
        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]init];
        ((BMKPinAnnotationView*)newAnnotationView).paopaoView = pView;
        
        /* 自定义气泡
        UIView *popView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
        //设置弹出气泡图片
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"record"]];
        image.frame = CGRectMake(0, 0, 100, 60);
        [popView addSubview:image];

        UILabel *carName = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, 100, 20)];
        carName.text = @"123456";
        carName.backgroundColor = [UIColor clearColor];
        carName.font = [UIFont systemFontOfSize:14];
        carName.textColor = [UIColor whiteColor];
        carName.textAlignment = NSTextAlignmentCenter;
        [popView addSubview:carName];
        BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc]initWithCustomView:popView];
        pView.frame = CGRectMake(0, 0, 100, 60);*/

        return newAnnotationView;
    }
    return nil;
}

- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [_mapView deselectAnnotation:_curAnnitationView.annotation animated:YES];
    if (view.annotation == _LocalAnnotation) {
        view.image = Image(@"location");
    }else{
        view.image = Image(@"shopSel");
    }
    if (![view.annotation.title isEqualToString:_curAddr]) {
        for (int i = 0; i<_mapView.annotations.count; i++) {
            BMKPointAnnotation *point = _mapView.annotations[i];
            if (view.annotation.coordinate.latitude == point.coordinate.latitude && view.annotation.coordinate.longitude == point.coordinate.longitude && view.annotation.title == point.title) {
                NSIndexPath *selIndex = [NSIndexPath indexPathForRow:0 inSection:i-1];
                [self.tableView selectRowAtIndexPath:selIndex animated:NO scrollPosition:UITableViewScrollPositionTop];
                self.tableView.scrollEnabled = NO;
                break;
            }
        }
    }
}

- (void)mapView:(BMKMapView *)mapView didDeselectAnnotationView:(BMKAnnotationView *)view
{
    if (view.annotation == _LocalAnnotation) {
        view.image = Image(@"location");
    }else{
        view.image = Image(@"shop");
    }
}


- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view
{
    
}

/**
 *在地图View将要启动定位时，会调用此函数
 */
- (void)willStartLocatingUser
{
    NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    BMKCoordinateRegion region;
    region.center.latitude = userLocation.location.coordinate.latitude;
    region.center.longitude = userLocation.location.coordinate.longitude;
    region.span.latitudeDelta = 0.3;
    region.span.longitudeDelta = 0.3;
    if (_mapView)
    {
        _mapView.region = region;
    }
    [_mapView setZoomLevel:19.0];
    [_locService stopUserLocationService];
    
    
    //添加当前位置的标注
    CLLocationCoordinate2D coord;
    coord.latitude = userLocation.location.coordinate.latitude;
    coord.longitude = userLocation.location.coordinate.longitude;
    _LocalAnnotation = [[BMKPointAnnotation alloc] init];
    _LocalAnnotation.coordinate = coord;
//    _LocalAnnotation.title = @"我的位置";
    
    //反地理编码出地理位置
    CLLocationCoordinate2D pt=(CLLocationCoordinate2D){0,0};
    pt=(CLLocationCoordinate2D){coord.latitude,coord.longitude};
    BMKReverseGeoCodeSearchOption *reverseGeoCodeOption = [[BMKReverseGeoCodeSearchOption alloc] init];
    reverseGeoCodeOption.location = pt;
    //发送反编码请求.并返回是否成功
    BOOL flag = [_geoCodeSearch reverseGeoCode:reverseGeoCodeOption];
    
    if (flag) {
        NSLog(@"反geo检索发送成功");
    } else {
        NSLog(@"反geo检索发送失败");
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self->_mapView addAnnotation:self->_LocalAnnotation];
    });
    
    [self loadShopData:userLocation.location.coordinate.latitude lon:userLocation.location.coordinate.longitude];
}

/**
 *在地图View停止定位后，会调用此函数
 */
- (void)didStopLocatingUser
{
    DLog(@"stop locate");
    
}

/**
 *定位失败后，会调用此函数
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)didFailToLocateUserWithError:(NSError *)error
{
    DLog(@"location error");

}

// 反地理编码
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeSearchResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error == 0) {
        DLog(@"我的位置-->%@ %@ ",result.address,result.sematicDescription);
       _curAddr = [NSString stringWithFormat:@"%@ %@",result.address,result.sematicDescription];
       _LocalAnnotation.title = _curAddr;
    }
}


#pragma mark - Event Response

// table可滑动时，swipe默认不再响应 所以要打开
- (void)swipe:(UISwipeGestureRecognizer *)swipe
{
    float stopY = 0;     // 停留的位置
    float offsetY = self.tableView.y; // 这是上一次Y的位置
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        // 当vc.table滑到头 且是下滑时，让vc.table禁止滑动
        if (self.tableView.contentOffset.y == -NavigationBar_H) {
            self.tableView.scrollEnabled = NO;
        }
        if (offsetY >= topY && offsetY < middleY) {
            // 停在middleY的位置
            stopY = middleY;
        }else if (offsetY >= middleY ){
            // 停在startY的位置
            stopY = startY;
        }else{
            stopY = topY;
        }
    } else  if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        if (offsetY <= middleY) {
            // 停在topY的位置
            stopY = topY;
            // 当停在topY位置 且是上划时，让vc.table不再禁止滑动
            self.tableView.scrollEnabled = YES;
        }else if (offsetY > middleY && offsetY <= startY ){
            // 停在middleY的位置
            stopY = middleY;
        }else{
            stopY = startY;
        }
    }
    
    DLog(@"stopY====%f",stopY);
    [UIView animateWithDuration:0.3 animations:^{
        if (stopY == topY) {
            self.tableView.frame = CGRectMake(0, topY, Screen_W, Screen_H);
        } else if (stopY == middleY) {
            [self changeMapViewFrame:CGRectMake(0, 0, Screen_W, middleY)];
            self.tableView.frame = CGRectMake(0, middleY, Screen_W, Screen_H - middleY);
        } else {
            [self changeMapViewFrame:CGRectMake(0, 0, Screen_W, startY)];
            self.tableView.frame = CGRectMake(0, startY, Screen_W, Screen_H - startY);
        }
    }];
}


#pragma mark - Network requests

- (void)loadShopData:(CGFloat)lat lon:(CGFloat)lon
{
    _lat = lat;
    _lon = lon;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDwithMessage:@""];
    
    NSString *storeType = @"";
    if ([self.selectType isEqualToString:@"附近商场"]) {
        storeType = @"2";
    }else if([self.selectType isEqualToString:@"品牌实体店"]){
        storeType = @"1";
    }else{
        storeType = @"0";
    }
    NSDictionary *param = @{
                            @"condition":self.goodsName?:@"",
                            @"brandId":self.brandId?:@"",
                            @"storeType":storeType,
                            @"lat":[NSString stringWithFormat:@"%.2f",_LocalAnnotation.coordinate.latitude],
                            @"lng":[NSString stringWithFormat:@"%.2f",_LocalAnnotation.coordinate.longitude],
                            @"page":@"1",
                            @"rows":pageSize
                            };
    [FWHomeManager loadHomeShopWithParameters:param result:^(NSArray <FWShopModel*>*model) {
        [hud hide];
        [self.shopList removeAllObjects];
        [self.shopList addObjectsFromArray:model];
        [self.tableView.mj_footer setState:MJRefreshStateIdle];
        if (self.shopList.count == 0) {
            self->_mapView.frame = CGRectMake(0, 0, Screen_W, startY);
            self.tableView.hidden = YES;
            self.bottomView.hidden = NO;
            return ;
        }
        self.tableView.hidden = NO;
        self.bottomView.hidden = YES;
        [self.tableView reloadData];
        if (self.shopList.count>0) {
            self->_FirstAnnotation = [[BMKPointAnnotation alloc]init];
            FWShopModel *model = self.shopList[0];
            CLLocationCoordinate2D coord;
            coord.latitude = model.latitude.floatValue;
            coord.longitude = model.longitude.floatValue;
            self->_FirstAnnotation.coordinate = coord;
            self->_FirstAnnotation.title = model.storeName;
            NSIndexPath *selIndex = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView selectRowAtIndexPath:selIndex animated:NO scrollPosition:UITableViewScrollPositionTop];
            [self setAnnotationWithArr:self.shopList];
        }
        if (self.shopList.count < pageSize.floatValue) {
            [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
        }
        page = 1;
    }];
}

/*
- (void)loadNextPageData
{
    page++;
    NSString *storeType = @"";
    if ([self.selectType isEqualToString:@"附近商场"]) {
        storeType = @"2";
    }else if([self.selectType isEqualToString:@"品牌实体店"]){
        storeType = @"1";
    }else{
        storeType = @"0";
    }
    NSDictionary *param = @{
                            @"storeType":storeType,
                            @"condition":self.goodsName?:@"",
                            @"brandId":self.brandId?:@"",
                            @"lat":[NSString stringWithFormat:@"%.2f",_LocalAnnotation.coordinate.latitude],
                            @"lng":[NSString stringWithFormat:@"%.2f",_LocalAnnotation.coordinate.longitude],
                            @"page":[NSString stringWithFormat:@"%d",page],
                            @"rows":pageSize
                            };
    [FWHomeManager loadHomeShopWithParameters:param result:^(NSArray <FWShopModel*>*model) {
        [self.shopList addObjectsFromArray:model];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        if (model.count < pageSize.floatValue) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView.mj_footer setState:MJRefreshStateNoMoreData];
            });
        }
    }];
}*/


- (void)setAnnotationWithArr:(NSArray*)shops
{
    _annotations = [NSMutableArray array];
    for (int i = 0; i < shops.count; i++) {
        FWShopModel *model = shops[i];
        BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = model.latitude.floatValue;
        coor.longitude = model.longitude.floatValue;
        annotation.coordinate = coor;
        annotation.title = model.storeName;

        [_annotations addObject:annotation];
    }
    [_mapView addAnnotations:_annotations];
    [_mapView showAnnotations:_annotations animated:YES];

}

#pragma mark - Public Methods




#pragma mark - Private Methods

- (void)setupBMKLocation
{
    _mapView = [[BMKMapView alloc]init];
    _mapView.frame = CGRectMake(0, 0, Screen_W, Screen_H - ShopCellHeight);//地图的初始位置
    [self.view addSubview:_mapView];
    //初始化BMKLocationService
    _locService = [[BMKLocationService alloc]init];
    _locService.delegate = self;
    // 初始化编码服务
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    _geoCodeSearch.delegate = self;
    //启动LocationService
    [_locService startUserLocationService];
    _mapView.showsUserLocation = YES;//显示定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态为普通定位模式
}

- (void)setNav
{
    self.navigationItem.title = self.selectType;
    [self changeSingleStoreList];
    
    if ([CLLocationManager authorizationStatus] ==kCLAuthorizationStatusDenied) {
        
        [UIAlertController js_alertAviewWithTarget:self andAlertTitle:@"" andMessage:@"定位已被禁止访问，为了您更好的体验，是否去重新设置？" andDefaultActionTitle:@"确定" dHandler:^(UIAlertAction *action) {
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:url];
        } andCancelActionTitle:@"取消" cHandler:nil completion:nil];
    }
}

- (void)setSubView
{
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, startY, Screen_W, ShopCellHeight)];
    self.bottomView.backgroundColor = Color_White;
    [self.view addSubview:self.bottomView];
    self.bottomView.hidden = YES;
    UILabel *lab = [[UILabel alloc] initWithFrame:CGRectZero];
    if ([self.selectType isEqualToString:@"附近商场"]) {
        lab.text = @"附近还没有商场额~";
    }else if([self.selectType isEqualToString:@"品牌实体店"]){
        lab.text = @"附近还没有品牌实体店额~";
    }
    lab.font = systemFont(18);
    lab.textColor = Color_Black;
    lab.textAlignment = NSTextAlignmentCenter;
    [self.bottomView addSubview:lab];
    
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bottomView.mas_centerX);
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.height.offset(30);
        make.left.right.equalTo(self.bottomView);
    }];
    
}

- (void)setTableView
{
    _tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero];
        tableView.backgroundColor = Color_MainBg;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.scrollEnabled = NO;
        [self.view addSubview:tableView];
        tableView;
    });
    self.upswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    self.upswipe.direction = UISwipeGestureRecognizerDirectionDown ; // 设置手势方向下
    self.upswipe.delegate = self;
    [self.tableView addGestureRecognizer:self.upswipe];

    self.downswipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    self.downswipe.direction = UISwipeGestureRecognizerDirectionUp; // 设置手势方向上
    self.downswipe.delegate = self;
    [self.tableView addGestureRecognizer:self.downswipe];
    
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.frame = CGRectMake(0, startY, Screen_W, ShopCellHeight);//初始位置
}


- (void)changeMapViewFrame:(CGRect)frame
{
    _mapView.frame = frame;
}

- (void)changeSingleStoreList
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf changeMapViewFrame:CGRectMake(0, 0, Screen_W, Screen_H - ShopCellHeight)];
        weakSelf.tableView.frame = CGRectMake(0, startY, Screen_W, ShopCellHeight);
    }];
}

- (void)changeCenterStoreList
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        [weakSelf changeMapViewFrame:CGRectMake(0, 0, Screen_W, middleY)];
        weakSelf.tableView.frame = CGRectMake(0, middleY, Screen_W, Screen_H - middleY);
    }];
}

#pragma mark - Setters

- (NSMutableArray *)shopList
{
    if (_shopList ==  nil) {
        _shopList = [NSMutableArray array];
    }
    return _shopList;
}

- (NSInteger)defaultCount
{
    if (self.shopList.count <5) {
        _defaultCount = self.shopList.count;
    } else {
        _defaultCount = 4;
    }
    
    return _defaultCount;
}



#pragma mark - Getters




@end
