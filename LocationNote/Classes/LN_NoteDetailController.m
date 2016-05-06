//
//  LN_NoteDetailController.m
//  LocationNote
//
//  Created by 小华 on 16/5/5.
//  Copyright © 2016年 ark. All rights reserved.
//

#import "LN_NoteDetailController.h"
#import "BMKTool.h"
#import "WMCustomDatePicker.h"
#import "LN_DataModel.h"
#import <objc/runtime.h>

@interface LN_NoteDetailController ()<BMKLocationServiceDelegate>

@property(nonatomic,strong)UITextView * contentTextView;
@property(nonatomic,strong)BMKLocationService * locService;
@property(nonatomic,assign)int hotid;

@end

@implementation LN_NoteDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLocation];
    
    [self setupTextView];
    
    UIBarButtonItem *leftBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(pop)];
    leftBack.imageInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.navigationItem.leftBarButtonItem = leftBack;
    // Do any additional setup after loading the view.
}

- (void)pop
{
    [_contentTextView resignFirstResponder];

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setupLocation
{
    _locService=[[BMKLocationService alloc] init];
    _locService.delegate = self;
    [_locService startUserLocationService];
}

- (void)setupTextView
{
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(hideKeyboard)];
    doneBarButton.width = ceilf(self.view.frame.size.width) / 3 - 30;

    UIBarButtonItem *voiceBarButton = [[UIBarButtonItem alloc] initWithTitle:@"日期" style:UIBarButtonItemStylePlain target:self action:@selector(showDate)];
    voiceBarButton.width = ceilf(self.view.frame.size.width) / 3;
    
    UIBarButtonItem *saveBarButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    voiceBarButton.width = ceilf(self.view.frame.size.width) / 3;
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    toolbar.items = [NSArray arrayWithObjects:doneBarButton, voiceBarButton,saveBarButton, nil];
    toolbar.backgroundColor=[UIColor redColor];
    
     CGRect contentTextVF= CGRectMake(kHorizontalMargin, 0, ScreenW-2*kHorizontalMargin, ScreenH);
    _contentTextView = [[UITextView alloc] initWithFrame:contentTextVF];
    _contentTextView.font = [UIFont systemFontOfSize:16];
    _contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_contentTextView setScrollEnabled:YES];
    [_contentTextView becomeFirstResponder];
    _contentTextView.inputAccessoryView = toolbar;

    [self.view addSubview:_contentTextView];

}

- (void)hideKeyboard
{

}

- (void)showDate
{
    WMCustomDatePicker *picker=[[WMCustomDatePicker alloc]initWithframe:CGRectMake(0, 0, ScreenW, 180) PickerStyle:WMDateStyle_MonthDayHourMinute didSelectedDateFinishBack:^(WMCustomDatePicker *picker, NSString *year, NSString *month, NSString *day, NSString *hour, NSString *minute, NSString *weekDay) {
        DLog(@"%@",month);
    }];
    
    picker.minLimitDate = [NSDate date];
    picker.maxLimitDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*30*12];
    _contentTextView.inputView=picker;

    
}
static char kUserLocation;


- (void)save
{    
    BMKUserLocation *userLocation=objc_getAssociatedObject(self, &kUserLocation);
    LN_DataModel *dataM=[LN_DataModel new];
    dataM.currentPosition=[NSString stringWithFormat:@"%f|%f", userLocation.location.coordinate.latitude ,userLocation.location.coordinate.longitude];
//    dataM.hostID =arc4random() ;

    dataM.saveTime=[NSString stringWithFormat:@"%@",[NSDate date]];
    dataM.content=self.contentTextView.text;
    
    [LN_DataModel insert:dataM resBlock:^(BOOL res) {
        
    }];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
        objc_setAssociatedObject(self, &kUserLocation, userLocation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
