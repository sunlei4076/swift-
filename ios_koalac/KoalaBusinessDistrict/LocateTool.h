//
//  LocationManager.h
//  KoalaKnow
//
//  Created by liuny on 15/7/23.
//  Copyright (c) 2015年 szjn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI/BMapKit.h>

@interface LocateTool : NSObject<BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
+ (LocateTool *)shareInstance;
/*
 isReverseT：是否反地理编码
 isReverseT=Yes,result不为nil,userLocation为nil
 isReverseT=No,result为nil,userLocation不为nil
 */
-(void)startLocationWithReverse:(BOOL)isReverseT success:(void(^)(BMKReverseGeoCodeResult *result, BMKUserLocation *userLocation))success fail:(void(^)(void))fail;



@end
