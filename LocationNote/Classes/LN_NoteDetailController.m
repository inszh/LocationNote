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

@interface LN_NoteDetailController ()<BMKLocationServiceDelegate,LN_ComposeToolbarDelegate>

@property(nonatomic,strong)UITextView * contentTextView;
@property(nonatomic,strong)BMKLocationService * locService;
@property(nonatomic,assign)int hotid;
@property(nonatomic,weak)LN_ComposeToolbar * toolbar;
@property (nonatomic, assign, getter = isChangingKeyboard) BOOL changingKeyboard;


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
            
//        case LN_ComposeToolbarButtonTypedate: // 日期
//            [self showDate];
            break;

            
        case LN_ComposeToolbarButtonTypeCalendar: // 日期
            [self calendar];
            break;
            
        case LN_ComposeToolbarButtonTypeSave: //保存
            [self save];
            
        default:
            break;
    }
}

- (void)calendar
{
    CalendarHomeViewController *leftVc=[[CalendarHomeViewController alloc]init];
    [leftVc setAirPlaneToDay:365 ToDateforString:[NSString stringWithFormat:@"%@",[NSDate date]]];
    leftVc.calendartitle=@"日历";
    [leftVc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];

    [self presentViewController:leftVc animated:YES completion:NULL];
    
    leftVc.calendarblock=^(CalendarDayModel *model,NSDate *date){
        DLog(@"%@%@",model.date,date);
        
//        objc_setAssociatedObject(self, &kUserAlertTime, , OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    };

}

//- (void)showDate
//{
//    self.changingKeyboard = YES;
//
//    if (_contentTextView.inputView) {
//        
//        _contentTextView.inputView=nil;
//        self.toolbar.showdateButton = YES;
//
//    }else{
//        
//        UIDatePicker *picker=[UIDatePicker new];
//        picker.datePickerMode=UIDatePickerModeTime;
//        [picker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
//        picker.backgroundColor=[UIColor whiteColor];
//        _contentTextView.inputView=picker;
//        self.toolbar.showdateButton = NO;
//
//    }
//    
//    [_contentTextView resignFirstResponder];
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        [_contentTextView becomeFirstResponder];
//
//    });
//
//    
//}

static char kUserLocation;
static char kUserCacheData;
static char kUserAlertTime;


- (void)save
{    
    BMKUserLocation *userLocation=objc_getAssociatedObject(self, &kUserLocation);
    LN_DataModel *dataM=[LN_DataModel new];
    dataM.currentPosition=[NSString stringWithFormat:@"%f|%f", userLocation.location.coordinate.latitude ,userLocation.location.coordinate.longitude];
//    dataM.hostID =arc4random() ;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *strDate = [dateFormatter stringFromDate:[NSDate date]];
    dataM.saveTime=strDate;
    dataM.content=self.contentTextView.text;
    
    [LN_DataModel insert:dataM resBlock:^(BOOL res) {
        
        objc_setAssociatedObject(self, &kUserCacheData, dataM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        [self setupAlert];
        
        [self dismissViewControllerAnimated:YES completion:nil];

    }];
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
    NSTimeInterval  intervalPlus =31; //1:天数
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFormStr = [dateFormatter dateFromString:dataM.saveTime];
    NSDate *datePlus = [[NSDate alloc] initWithTimeInterval:intervalPlus sinceDate:dateFormStr];

    localNotif.fireDate =datePlus;
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    
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




@end
