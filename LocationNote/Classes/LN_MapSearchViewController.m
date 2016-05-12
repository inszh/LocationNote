//
//  LN_MapSearchViewController.m
//  LocationNote
//
//  Created by 小华 on 16/5/10.
//  Copyright © 2016年 ark. All rights reserved.
//

#import "LN_MapSearchViewController.h"
#import "BMKTool.h"
#import "LN_LocationM.h"
#import <objc/runtime.h>

@interface LN_MapSearchViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,UISearchBarDelegate,BMKSuggestionSearchDelegate,BMKGeoCodeSearchDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)BMKMapView * mapView;
@property(nonatomic,strong)BMKLocationService* locService;
@property(nonatomic,strong)UISearchBar * locationSearchBar;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation LN_MapSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSearch];
    
    [self setupMap];
    
    [self setupTableview];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

-(void)setupSearch
{
    self.locationSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW*2/3, 40)];
    self.navigationItem.titleView = self.locationSearchBar;
    self.locationSearchBar.returnKeyType=UIReturnKeyDefault;
    [self.locationSearchBar becomeFirstResponder];
    self.locationSearchBar.delegate = self;

    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:(UIBarButtonItemStylePlain) target:self action:@selector(sure)];
    self.navigationItem.rightBarButtonItem = rightBtn;
}


-(void)setupMap
{
    _mapView=[[BMKMapView alloc]init];
    _mapView.delegate = self;
    _mapView.frame = CGRectMake(0, 0, ScreenW, ScreenH*0.4);
    [self.view addSubview:_mapView];
    
    
    _locService=[[BMKLocationService alloc] init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层

    UIImageView *mapCenter=[UIImageView new];
    mapCenter.image=[UIImage imageNamed:@"icon_mark0"];
    mapCenter.frame=CGRectMake(0, 0, 23, 31);
    mapCenter.center=_mapView.center;
    [_mapView addSubview:mapCenter];
    
    UIButton *locme=[UIButton new];
    locme.layer.cornerRadius = 5;
    locme.layer.masksToBounds = YES;
    locme.layer.borderColor=LHColor(0, 0, 0).CGColor;
    locme.layer.borderWidth=2;
    locme.frame=CGRectMake(10, ScreenH*0.4-45, 35, 35);
    [locme setBackgroundColor:[UIColor whiteColor]];
    [locme setImage:[UIImage imageNamed:@"default_main_toolbaritem_shortcut_normal"] forState:0];
    [locme addTarget:self action:@selector(locme:) forControlEvents:UIControlEventTouchUpInside];
    [self.mapView addSubview:locme];

}

- (void)setupTableview
{
    UITableView *tableView=[[UITableView alloc]init];
    self.tableView=tableView;
    tableView.frame=CGRectMake(0, ScreenH*0.4, ScreenW, ScreenH*0.6);
    tableView.delegate=self;
    tableView.dataSource=self;
    [self.view addSubview:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell= [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    LN_LocationM *dataM=self.dataArray[indexPath.row];
    cell.textLabel.text=dataM.keyName;
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%@%@",dataM.city,dataM.district];
    return cell;
}



- (void)locme:(UIButton *)btn
{
    [_locService startUserLocationService];
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    BMKCoordinateRegion region;
    region.span.latitudeDelta  = 0.01;
    region.span.longitudeDelta = 0.01;
    
    BMKCoordinateRegion viewRegion = BMKCoordinateRegionMake(userLocation.location.coordinate, region.span);
    BMKCoordinateRegion adjustedRegion = [_mapView regionThatFits:viewRegion];
    [_mapView setRegion:adjustedRegion animated:YES];
    BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
    param.isAccuracyCircleShow = NO;//设置是否显示定位的那个精度圈
    [_mapView updateLocationViewWithParam: param];
    
    [_mapView updateLocationData:userLocation];
    

    [_locService stopUserLocationService];
    
    [self mapViewGetResultListFromLocationCoor:userLocation.location.coordinate];


    
}
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error;
{
    if (!result.poiList.count) return;
    for (BMKPoiInfo *info in result.poiList){
        LN_LocationM *model = [[LN_LocationM alloc] init];
        model.city = info.address;
        model.district=@"";
        model.keyName=info.name;
        model.poiId=info.uid;
        model.coor=info.pt;
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText//去搜列表
{
    BMKSuggestionSearch *suggestSrarch=[BMKSuggestionSearch new];
    suggestSrarch.delegate=self;
    BMKSuggestionSearchOption *suggestOp=[BMKSuggestionSearchOption new];
    suggestOp.keyword=searchText;
    
    if ([suggestSrarch suggestionSearch:suggestOp]) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
    }

}


- (void)onGetSuggestionResult:(BMKSuggestionSearch*)searcher result:(BMKSuggestionResult*)result errorCode:(BMKSearchErrorCode)error
{//拿到列表
    for (int i=0; i<result.keyList.count; i++) {
        
        LN_LocationM *model = [[LN_LocationM alloc] init];
        model.city = result.cityList[i];
        model.district = result.districtList[i];
        model.keyName = result.keyList[i];
        model.poiId=result.poiIdList[i];
        model.pt=result.ptList[i];
        CLLocationCoordinate2D coor;
        [model.pt getValue:&coor];
        model.coor=coor;
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.dataArray.count) return;
    LN_LocationM *dataM=self.dataArray[indexPath.row];
    [self.mapView setCenterCoordinate:dataM.coor animated:YES];
    
//    BMKPointAnnotation *annotation=[BMKPointAnnotation new];
//    annotation.coordinate=dataM.coor;
//    [_mapView removeAnnotations:_mapView.annotations];
//    [self.mapView addAnnotation:annotation];
    
    if ([self.delegate respondsToSelector:@selector(ln_searchViewdidCilckDone:seletM:)]) {
        [self.delegate ln_searchViewdidCilckDone:self seletM:dataM];
    }
    
}

- (void)mapViewGetResultListFromLocationCoor:(CLLocationCoordinate2D)coor
{
    BMKReverseGeoCodeOption *codeOption= [BMKReverseGeoCodeOption new];//定位好了根据坐标搜附近的地理位置名
    codeOption.reverseGeoPoint=coor;
    BMKGeoCodeSearch *geoCodeSearch=[[BMKGeoCodeSearch alloc] init];
    geoCodeSearch.delegate=self;
    
    if ([geoCodeSearch reverseGeoCode:codeOption]) {
        DLog(@"-----------牛逼");
    }else{
        DLog(@"00o0asfkdopsaf");
    }

}


- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated//移动地图
{
//    [self mapViewGetResultListFromLocationCoor:mapView.centerCoordinate];
    DLog(@"-----------------");
}

//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
//{
//    NSString *AnnotationViewID = @"ClusterMark";
//    BMKAnnotationView *annotationView = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
//    annotationView.image=[UIImage imageNamed:@"icon_mark0"];
//    return annotationView;
//}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.locationSearchBar endEditing:YES];
}

- (void)sure
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
