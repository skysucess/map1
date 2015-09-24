//
//  ViewController.h
//  map1
//
//  Created by 甘雨姣 on 15/9/24.
//  Copyright (c) 2015年 甘雨姣. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
@interface ViewController : UIViewController<MKMapViewDelegate,CLLocationManagerDelegate>

@property(strong,nonatomic)MKMapView *mapView;
@property(strong,nonatomic)CLLocationManager *locationManager;
//地方标记，显示具体地点
@property(strong,nonatomic)CLPlacemark *placemark;
//显示经纬度
@property(strong,nonatomic)CLLocation *currentLocation;

@end

