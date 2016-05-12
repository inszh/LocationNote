//
//  LN_NoteDetailController.m
//  LocationNote
//
//  Created by 小华 on 16/5/5.
//  Copyright © 2016年 ark. All rights reserved.
//

#import "LN_NoteDetailController.h"
#import "BMKTool.h"
#import "LN_DataModel.h"
#import <objc/runtime.h>
#import "LN_ComposeToolbar.h"
#import "UIView+Extension.h"
#import "CalendarHomeViewController.h"
#import "LN_MapSearchViewController.h"
#import "LN_LocationM.h"


@interface LN_NoteDetailController ()<BMKLocationServiceDelegate,LN_ComposeToolbarDelegate,ln_MapSearchViewControllerDelegate>

@property(nonatomic,strong)UITextView * contentTextView;
@property(nonatomic,strong)BMKLocationService * locService;
@property(nonatomic,assign)int hotid;
@property(nonatomic,weak)LN_ComposeToolbar * toolbar;
@property(nonatomic,copy)NSString *dateStr;
@property(nonatomic,copy)NSString *timeStr;
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;
@property(nonatomic,strong)LN_DataModel *dataM;

@end

@implementation LN_NoteDetailController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupLocation];
    
    [self setupTextView];

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    // 键盘即将隐藏, 就会发出UIKeyboardWillHideNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    
    UIBarButtonItem *leftBack = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"nav_back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(pop)];
    
    leftBack.imageInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    self.navigationItem.leftBarButtonItem = leftBack;
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStylePlain) target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    LN_DataModel *dataM=[[LN_DataModel alloc] init];
    
    self.dataM=dataM;
    
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
    self.title=kAppName;

    self.view.backgroundColor=[UIColor whiteColor];
    
     CGRect contentTextVF= CGRectMake(kHorizontalMargin, 0, ScreenW-2*kHorizontalMargin, ScreenH);
    _contentTextView = [[UITextView alloc] initWithFrame:contentTextVF];
    _contentTextView.font = [UIFont systemFontOfSize:16];
    _contentTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    _contentTextView.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [_contentTextView setScrollEnabled:YES];
    [_contentTextView becomeFirstResponder];
    
    LN_ComposeToolbar *toolbar = [[LN_ComposeToolbar alloc] init];
    toolbar.width = ScreenW;
    toolbar.delegate = self;
    toolbar.height = 44;
    self.toolbar = toolbar;
    
    // 2.显示
    toolbar.y = ScreenH - toolbar.height;
    [self.view addSubview:_contentTextView];
    
    [self.view addSubview:toolbar];
    
}


- (void)composeTool:(LN_ComposeToolbar *)toolbar didClickedButton:(LN_ComposeToolbarButtonType)buttonType
{
    switch (buttonType) {
        case LN_ComposeToolbarButtonTypeCamera: // 照相机
//            [self openCamera];
            break;
            
        case LN_ComposeToolbarButtonTypePicture: // 相册
//            [self openAlbum];
            break;
            
        case LN_ComposeToolbarButtonTypeCalendar: //提醒
            [self calendar];
            break;
            
        case LN_ComposeToolbarButtonTypeSave: //保存
            [self save];
            break;

        case LN_ComposeToolbarButtonTypeMap: // 位置
            [self searchMap];
            break;

            
        default:
            break;
    }
}

- (void)calendar
{
    CalendarHomeViewController *leftVc=[[CalendarHomeViewController alloc]init];
    [leftVc setAirPlaneToDay:365 ToDateforString:[NSString stringWithFormat:@"%@",[NSDate date]]];
    [self presentViewController:leftVc animated:YES completion:NULL];
    
    leftVc.calendarblock=^(CalendarDayModel *model){//日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *strDate = [dateFormatter stringFromDate:model.date];
        self.dateStr=strDate;
        DLog(@"%@",self.dateStr);

    };
    
    leftVc.pickerDateblock=^(NSDate *date){//时间
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *strDate = [dateFormatter stringFromDate:date];
        self.timeStr=strDate;
        DLog(@"%@",self.timeStr);

    };
    
    //      objc_setAssociatedObject(self, &kUserAlertTime, , OBJC_ASSOCIATION_RETAIN_NONATOMIC);


}


static char kUserLocation;
static char kUserCacheData;
static char kUserAlertTime;


- (void)save
{    
    BMKUserLocation *userLocation=objc_getAssociatedObject(self, &kUserLocation);
    
    self.dataM.currentPosition=[NSString stringWithFormat:@"%f|%f", userLocation.location.coordinate.latitude ,userLocation.location.coordinate.longitude];
//    dataM.hostID =arc4random() ;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy MM dd|HH:mm"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    self.dataM.saveTime=strDate;
    self.dataM.content=self.contentTextView.text;
    
    NSDateFormatter *dateFormatterHH = [[NSDateFormatter alloc] init];
    [dateFormatterHH setDateFormat:@"HH:mm:ss"];
    NSString *HHDate = [dateFormatterHH stringFromDate:[NSDate date]];
    
    NSDateFormatter *dateFormatterYY = [[NSDateFormatter alloc] init];
    [dateFormatterYY setDateFormat:@"yyyy-MM-dd"];
    NSString *YYDate = [dateFormatterYY stringFromDate:[NSDate date]];
    
    NSString *fireDateStr;
    if (!self.timeStr) {
        fireDateStr=[NSString stringWithFormat:@"%@ %@",self.dateStr,HHDate];
    }else if (!self.dateStr){
        fireDateStr=[NSString stringWithFormat:@"%@ %@",YYDate,self.timeStr];
    }

    DLog(@"%@",fireDateStr);
    
    self.dataM.alertTime=fireDateStr;
    
    if (!self.dataM) return;
    
    [LN_DataModel insert:self.dataM resBlock:^(BOOL res) {
        
        objc_setAssociatedObject(self, &kUserCacheData, self.dataM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        [self setupAlert];
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }];
}

- (void)searchMap
{
    LN_MapSearchViewController *map=[[LN_MapSearchViewController alloc]init];
    map.delegate=self;
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:map];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
        objc_setAssociatedObject(self, &kUserLocation, userLocation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - 键盘处理
/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)note
{
    if (self.isChangingKeyboard) {
        self.changingKeyboard = NO;
        return;
    }
    
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        self.toolbar.transform = CGAffineTransformIdentity;
    }];
}

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)note
{
    // 1.键盘弹出需要的时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 2.动画
    [UIView animateWithDuration:duration animations:^{
        // 取出键盘高度
        CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        CGFloat keyboardH = keyboardF.size.height;
        self.toolbar.transform = CGAffineTransformMakeTranslation(0, - keyboardH);
    }];
}

-(void)setupAlert
{
    LN_DataModel *dataM=objc_getAssociatedObject(self, &kUserCacheData);
    
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    //设置通知时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFormStr = [dateFormatter dateFromString:dataM.alertTime];
    
    localNotif.timeZone = [NSTimeZone localTimeZone];
    localNotif.fireDate =dateFormStr;
    
    
    //设置弹出对话框的消息和按钮
    localNotif.alertBody =dataM.content;
    localNotif.alertAction = NSLocalizedString(@"OK", nil);
    
    
    //设置声音
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
    
    //设置BadgeNumber
    localNotif.applicationIconBadgeNumber = 1;
    
    
    //设置附加消息
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:@"Alert" forKey:@"kAlert"];
    localNotif.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
}

-(void)ln_searchViewdidCilckDone:(LN_MapSearchViewController *)searchVc seletM:(LN_LocationM *)dataM
{
    self.dataM.targetPosition=[NSString stringWithFormat:@"%f|%f", dataM.coor.latitude ,dataM.coor.longitude];
    self.dataM.targetAdress=[NSString stringWithFormat:@"%@%@", dataM.city,dataM.district];

}


@end
