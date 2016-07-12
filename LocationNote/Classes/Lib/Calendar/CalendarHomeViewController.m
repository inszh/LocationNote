//
//  CalendarHomeViewController.m
//  Calendar
//
//  Created by 张凡 on 14-6-23.
//  Copyright (c) 2014年 张凡. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CalendarHomeViewController.h"
#import "Color.h"

@interface CalendarHomeViewController ()
{

    
    int daynumber;//天数
    int optiondaynumber;//选择日期数量
//    NSMutableArray *optiondayarray;//存放选择好的日期对象数组
    
}

@end

@implementation CalendarHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.view.backgroundColor=[UIColor whiteColor];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];

    
   
	// Do any additional setup after loading the view.
}

-(void)btnClik:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 设置方法

//飞机初始化方法
- (void)setAirPlaneToDay:(int)day ToDateforString:(NSString *)todate
{
    daynumber = day;
    optiondaynumber = 1;//选择一个后返回数据对象
    super.calendarMonth = [self getMonthArrayOfDayNumber:daynumber ToDateforString:todate];
    [super.collectionView reloadData];//刷新
    
    UIButton *btn=[UIButton buttonWithType:0];
    btn.frame=CGRectMake(ScreenW-60, ScreenH-210, 60, 40);
    [btn setTitle:@"返回" forState:0];
    [btn setTitleColor:[UIColor blackColor] forState:0];
    [self.view addSubview:btn];
    [self.view bringSubviewToFront:btn];
    [btn addTarget:self action:@selector(btnClik:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIDatePicker *picker=[UIDatePicker new];
    picker.datePickerMode=UIDatePickerModeTime;
    [picker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
    picker.backgroundColor=LHNewGrayGroundColor;
    picker.frame=CGRectMake(0, ScreenH-150, ScreenW, 150);
    [self.view addSubview:picker];
    
    UIToolbar *tool=[[UIToolbar alloc]init];
}

-(void)dateChanged:(UIDatePicker *)picker
{
    
    if (self.pickerDateblock) {
        
        self.pickerDateblock(picker.date);//传递数组给上级
    }
    
}




#pragma mark - 逻辑代码初始化

//获取时间段内的天数数组
- (NSMutableArray *)getMonthArrayOfDayNumber:(int)day ToDateforString:(NSString *)todate
{
    
    NSDate *date = [NSDate date];
    
    NSDate *selectdate  = [NSDate date];
    
    if (todate) {
        
        selectdate = [selectdate dateFromString:todate];
        
    }
    
    super.Logic = [[CalendarLogic alloc]init];
    
    return [super.Logic reloadCalendarView:date selectDate:selectdate  needDays:day];
}



#pragma mark - 设置标题

- (void)setCalendartitle:(NSString *)calendartitle
{

    [self.navigationItem setTitle:calendartitle];

}


@end
