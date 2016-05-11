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

@interface LN_MapSearchViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,UISearchBarDelegate,BMKSuggestionSearchDelegate,UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)BMKMapView * mapView;
@property(nonatomic,strong)BMKLocationService* locService;
@property(nonatomic,strong)UISearchBar * locationSearchBar;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray * dataArray;
@property(nonatomic,assign)long selectedNum;

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
    [self.locationSearchBar becomeFirstResponder];
    self.locationSearchBar.delegate = self;
    
    UIBarButtonItem *leftBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(pop)];
    leftBack.imageInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.navigationItem.leftBarButtonItem = leftBack;
    
}

- (void)pop
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupMap
{
    _mapView=[[BMKMapView alloc]init];
    _mapView.delegate = self;
    _mapView.frame = CGRectMake(0, 0, ScreenW, ScreenH*0.5);
    [self.view addSubview:_mapView];
    
    
    _locService=[[BMKLocationService alloc] init];
    _locService.delegate = self;
    [_locService startUserLocationService];
    
    _mapView.showsUserLocation = NO;//先关闭显示的定位图层
    _mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
    _mapView.showsUserLocation = YES;//显示定位图层


}

- (void)setupTableview
{
    UITableView *tableView=[[UITableView alloc]init];
    self.tableView=tableView;
    tableView.frame=CGRectMake(0, ScreenH*0.5, ScreenW, ScreenH*0.5);
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
}


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
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
{
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
//    [self.tableView  reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.mapView setCenterCoordinate:dataM.coor animated:YES];
}


@end
