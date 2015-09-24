//
//  ViewController.m
//  map1
//
//  Created by 甘雨姣 on 15/9/24.
//  Copyright (c) 2015年 甘雨姣. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"定位" style:UIBarButtonItemStylePlain target:self action:@selector(findLocation)];
    self.navigationItem.rightBarButtonItem=right;
    self.navigationItem.title=@"地图显示";
    
    self.mapView=[[MKMapView alloc]initWithFrame:self.view.frame];
    self.mapView.delegate=self;
    [self.view addSubview:self.mapView];
}
-(void)findLocation
{
    self.locationManager=[[CLLocationManager alloc]init];
    self.locationManager.delegate=self;
    //获取最佳距离
    self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    self.locationManager.distanceFilter=10;
    //提示是否允许使用地理位置
    [self.locationManager requestAlwaysAuthorization];
    [self.locationManager startUpdatingLocation];
    [self performSelector:@selector(showAnnotation) withObject:nil afterDelay:2.0];
}
-(void)showAnnotation
{
    MKPointAnnotation *annotation=[[MKPointAnnotation alloc]init];
    annotation.coordinate=CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
    annotation.title=self.placemark.name;
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    self.currentLocation=[locations lastObject];
    NSLog(@"经度=%f 纬度=%f",self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
    
    CLLocationCoordinate2D center=CLLocationCoordinate2DMake(self.currentLocation.coordinate.latitude, self.currentLocation.coordinate.longitude);
    MKCoordinateSpan span=MKCoordinateSpanMake(0.003, 0.003);
    MKCoordinateRegion regin=MKCoordinateRegionMake(center, span);
    [self.mapView setRegion:regin animated:YES];
    
    CLGeocoder *geocoder=[[CLGeocoder alloc]init];
    [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count>0) {
            self.placemark=[array objectAtIndex:0];
            NSLog(@"%@",self.placemark.name);
        }
        else if (error==nil&&[array count]==0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error!=nil)
        {
            NSLog(@"An error occurres=%@",error);
        }
    }];
    [self.locationManager stopUpdatingLocation];
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identity=@"annotation";
    MKPinAnnotationView *annotationView=(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identity];
    if (!annotationView) {
        annotationView=[[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identity];
    }
    annotationView.annotation=annotation;
    annotationView.canShowCallout=YES;
    annotationView.animatesDrop=YES;
    return annotationView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
