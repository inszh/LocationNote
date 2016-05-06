//
//  LN_MapViewController.m
//  LocationNote
//
//  Created by 小华 on 16/5/4.
//  Copyright © 2016年 ark. All rights reserved.
//

#import "LN_MapViewController.h"
#import "BMKTool.h"
#import "UIView+Extension.h"
#import "LN_NoteDetailController.h"
#import "LN_DataModel.h"
#import "LN_UserLocation.h"

@interface LN_MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property(nonatomic,strong)BMKMapView * mapView;
@property(nonatomic,strong)BMKLocationService* locService;

@end

@implementation LN_MapViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupMap];
}

- (void)setupMap
{
    UIButton *locme=[UIButton new];
    locme.frame=CGRectMake(40, ScreenH-kTopBarHeight-80, 40, 40);
    [locme setBackgroundImage:[UIImage imageNamed:@"location_me"] forState:0];
    [locme addTarget:self action:@selector(locme:) forControlEvents:UIControlEventTouchUpInside];
    _mapView=[[BMKMapView alloc]init];
    _mapView.delegate = self;
    _mapView.frame = CGRectMake(0, 0, ScreenW, ScreenH-kTopBarHeight);
    [self.view addSubview:_mapView];
    
    UIButton *plusBtn=[UIButton new];
    plusBtn.frame=CGRectMake((ScreenW-ScreenW*0.8)*0.5, MaxY(_mapView),ScreenW *0.8, ScreenH-_mapView.height);
    plusBtn.backgroundColor=[UIColor lightGrayColor];
    [plusBtn addTarget:self action:@selector(createNote) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:plusBtn];
    [self.view insertSubview:locme aboveSubview:plusBtn];

    _locService=[[BMKLocationService alloc] init];
    _locService.delegate = self;

    [_locService startUserLocationService];

    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层

}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    
    [LN_DataModel selectWhere:nil groupBy:nil orderBy:nil limit:nil selectResultsBlock:^(NSArray *selectResults) {
        
        for (LN_DataModel *dataM in selectResults) {
            
            NSArray * coordinateArray= [dataM.currentPosition componentsSeparatedByString:@"|"];
            
            CLLocationDegrees latitude=[coordinateArray.firstObject doubleValue];
            CLLocationDegrees longitude=[coordinateArray.lastObject doubleValue];
            DLog(@"%f---%f",latitude,longitude);
            DLog(@"%f---%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);

//            CLLocation *location=[[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
            
            BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(latitude,longitude));
            
            BMKMapPoint point2 = BMKMapPointForCoordinate(userLocation.location.coordinate);

            CLLocationDistance distance = BMKMetersBetweenMapPoints(point1, point2);
           
            DLog(@"%.2f米",distance);
            
            
        }
        

    }];
    
    

    /**
     *  一会放大的范围
     */
    BMKCoordinateRegion region;
    region.span.latitudeDelta  = 0.01;
    region.span.longitudeDelta = 0.01;
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(userLocation.location.coordinate, region.span);
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    param.isAccuracyCircleShow = NO;//设置是否显示定位的那个精度圈
    [_mapView updateLocationViewWithParam: param];
    
    [_locService stopUserLocationService];
    
    /**
     *  更新小圆点
     */
    [_mapView updateLocationData:userLocation];
}

- (void)locme:(UIButton *)btn
{
    [_locService startUserLocationService];
}

- (void)createNote
{
    LN_NoteDetailController *note=[LN_NoteDetailController new];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:note];
    [self presentViewController:nav animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_locService startUserLocationService];

}

@end
