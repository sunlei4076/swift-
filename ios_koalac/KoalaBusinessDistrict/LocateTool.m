//
//  LocationManager.m
//  KoalaKnow
//
//  Created by liuny on 15/7/23.
//  Copyright (c) 2015年 szjn. All rights reserved.
//

#import "LocateTool.h"

typedef void(^SuccessBlock)(BMKReverseGeoCodeResult *, BMKUserLocation *);
typedef void(^FailBlock)(void);

@interface LocateTool() <CLLocationManagerDelegate>
{
    BMKLocationService *locService;
    BMKGeoCodeSearch *codeSearch;
    BOOL isReverse;
    
    CLLocationManager *_locationManager;
}
@property (nonatomic, copy) SuccessBlock success;
@property (nonatomic, copy) FailBlock fail;

@end

@implementation LocateTool

+ (LocateTool *)shareInstance
{
    static LocateTool *instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

-(void)startLocationWithReverse:(BOOL)isReverseT success:(void(^)(BMKReverseGeoCodeResult *result, BMKUserLocation *userLocation))success fail:(void(^)(void))fail{
    
    if(locService == nil){
        locService = [[BMKLocationService alloc] init];
        locService.delegate = self;
    }
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    [locService startUserLocationService];
    isReverse = isReverseT;
    self.success = success;
    self.fail = fail;
}

#pragma mark - BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    [locService stopUserLocationService];
    if(codeSearch == nil){
        codeSearch = [[BMKGeoCodeSearch alloc] init];
        codeSearch.delegate = self;
    }
    if(isReverse == YES){
        
        //初始化逆地理编码类
        BMKReverseGeoCodeOption *reverseGeoCodeOption= [[BMKReverseGeoCodeOption alloc] init];
        //需要逆地理编码的坐标位置
        reverseGeoCodeOption.reverseGeoPoint = userLocation.location.coordinate;
        BOOL flag = [codeSearch reverseGeoCode:reverseGeoCodeOption];
        if(flag == NO){
            //反地理编码失败
            if(self.fail){
                self.fail();
            }
        }
    }else{
        if(self.success){
            self.success(nil,userLocation);
            
        }
    }
}

-(void)didFailToLocateUserWithError:(NSError *)error{
    [locService stopUserLocationService];
    if(self.fail){
        self.fail();
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
-(void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if(self.success){
        self.success(result,nil);
    }
}
@end
