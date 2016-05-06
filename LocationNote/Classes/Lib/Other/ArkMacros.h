//
//  ACMacros.h
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>




#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height
#define kNotificationCenter [NSNotificationCenter defaultCenter]

// 适配iphone6 所以用的它的分辨率 -- 因为标注都是按这个来的
// 公式：x = y * k；   ----> 坐标值 = 标尺 * 比率
#define widthRate ScreenW/750
#define heightRate ScreenH/1334

// 有值 就是 iphone6 以上的屏幕 -- 登录注册用了这个傻方法
#define iPhone6Height ScreenH >= 667

#ifndef ACMacros_h
#define ACMacros_h


//** 沙盒路径 ***********************************************************************************
#define PATH_OF_APP_HOME    NSHomeDirectory()
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


/* ****************************************************************************************************************** */
/** DEBUG LOG **/
#ifdef DEBUG

#define DLog(...) NSLog( @"< %s:(第%d行) > %@",__func__ , __LINE__, [NSString stringWithFormat:__VA_ARGS__] )

#else

#define DLog( s, ... )

#endif


/** DEBUG RELEASE **/
#if DEBUG

#define MCRelease(x)            [x release]

#else

#define MCRelease(x)            [x release], x = nil

#endif


/** NIL RELEASE **/
#define NILRelease(x)           [x release], x = nil


/* ****************************************************************************************************************** */
#pragma mark - Frame (宏 x, y, width, height)

// App Frame
#define Application_Frame       [[UIScreen mainScreen] applicationFrame]

// App Frame Height&Width

#define LHColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define LHAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)/1]


#define LHRandomColor LHColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))
#define LHGrayBackGroundColor LHColor(236, 236, 236)
#define LHGrayLineColor LHColor(216, 216, 216)
#define LHGrayBlueGroundColor LHColor(35, 141, 212)
#define LHGrayDeepBlueGroundColor LHColor(0, 125, 227)
#define LHNewGrayGroundColor LHColor(242, 242, 242)
#define LHNewCellGrayColor [UIColor whiteColor]
#define LHBrownFontColor LHColor(55, 35, 23)
#define LHGrayFontColor LHColor(142, 141,141)
#define LHlightBlueColor LHColor(117, 194,255)



// 标注中的规范
/** 标准色 ---- B 表示背景色 */
#define k_B1 LHColor(237,234,227)
#define k_B2 LHColor(255,252,245)
#define k_B3 LHColor(242,242,242)
/** 全局色 ---- C 表示color */
#define k_C1 LHColor(61,134,248)
#define k_C2 LHColor(126,173,255)
#define k_C3 LHColor(135,129,189)
#define k_C4 LHColor(253,184,44)
#define k_C5 LHColor(39,19,16)
#define k_C6 LHColor(255,93,92)
#define k_C7 LHColor(0,204,255)
#define k_C8 LHColor(77,73,72)
#define k_C9 LHColor(54,47,45)
#define k_C10 LHColor(133,133,133)
#define k_C11 LHColor(170,170,170)
#define k_C12 LHColor(242,242,242)
/** 间隔线 --- L 表示line */
#define k_L LHColor(197,197,197)

/** 文字色 ---- T 表示 text */
#define k_T1 LHColor(54,47,45)
#define k_T2 LHColor(90,90,90)
#define k_T3 LHColor(133,133,133)
#define k_T4 LHColor(170,170,170)
#define k_T5 LHColor(255,255,255)
#define k_T6 LHColor(211,235,255)
#define k_T7 LHColor(254,255,211)
#define k_T8 LHColor(252,133,54)
#define k_T8_1 LHColor(72,207,174)
#define k_T8_2 LHColor(133,133,133)


/** 字号大小 --- k_size_T*/
#define k_size_T1 [UIFont systemFontOfSize:20]
#define k_size_T2 [UIFont systemFontOfSize:18]
#define k_size_T3 [UIFont systemFontOfSize:16]
#define k_size_T4 [UIFont systemFontOfSize:15]
#define k_size_T5 [UIFont systemFontOfSize:14]
#define k_size_T6 [UIFont systemFontOfSize:13]
#define k_size_T7 [UIFont systemFontOfSize:12]
#define k_size_T8 [UIFont systemFontOfSize:11]
#define k_size_T9 [UIFont systemFontOfSize:10]
#define k_size_T10 [UIFont systemFontOfSize:17]
#define k_size_T7s [UIFont systemFontOfSize:12 weight:6]// 字号数字大小 --- k_font_T

/** 字号大小(加粗) --- k_size_blod_T*/

#define k_size_blod_T1 [UIFont blodSystemFontOfSize:20]
#define k_size_blod_T2 [UIFont boldSystemFontOfSize:18]
#define k_size_blod_T3 [UIFont boldSystemFontOfSize:16]
#define k_size_blod_T4 [UIFont boldSystemFontOfSize:15]
#define k_size_blod_T5 [UIFont boldSystemFontOfSize:14]
#define k_size_blod_T6 [UIFont boldSystemFontOfSize:13]
#define k_size_blod_T7 [UIFont boldSystemFontOfSize:12]
#define k_size_blod_T8 [UIFont boldSystemFontOfSize:11]
#define k_size_blod_T9 [UIFont boldSystemFontOfSize:10]
#define k_size_blod_T10 [UIFont boldSystemFontOfSize:17]
#define k_size_blod_T7s [UIFont boldSystemFontOfSize:12 weight:6]// 字号数字大小 --- k_font_T



#define k_font_T1 20
#define k_font_T2 18
#define k_font_T3 16
#define k_font_T4 15
#define k_font_T5 14
#define k_font_T6 13
#define k_font_T7 12
#define k_font_T8 11
#define k_font_T9 10
/**
 * 字体大小
 */
//文字

#define k_HUMediumTFontSize(v) [UIFont systemFontOfSize:(v)]
#define k_HULightTFontSize(v) [UIFont systemFontOfSize:(v)]
//数字
#define k_HURegularNFontSize(v) [UIFont systemFontOfSize:(v)]
#define k_HULightNFontSize(v) [UIFont systemFontOfSize:(v)]

#define ScreenW [UIScreen mainScreen].bounds.size.width
#define ScreenH [UIScreen mainScreen].bounds.size.height

// View 坐标(x,y)和宽高(width,height)
#define X(v)                    (v).frame.origin.x
#define Y(v)                    (v).frame.origin.y
#define WIDTH(v)                (v).frame.size.width
#define HEIGHT(v)               (v).frame.size.height

#define MinX(v)                 CGRectGetMinX((v).frame)
#define MinY(v)                 CGRectGetMinY((v).frame)

#define MidX(v)                 CGRectGetMidX((v).frame)
#define MidY(v)                 CGRectGetMidY((v).frame)

#define MaxX(v)                 CGRectGetMaxX((v).frame)
#define MaxY(v)                 CGRectGetMaxY((v).frame)
#define MaxYnv(nv)                 CGRectGetMaxY((nv))
#define MaxXnv(nv)                 CGRectGetMaxX((nv))


#define RECT_CHANGE_x(v,x)          CGRectMake(x, Y(v), WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_y(v,y)          CGRectMake(X(v), y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_point(v,x,y)    CGRectMake(x, y, WIDTH(v), HEIGHT(v))
#define RECT_CHANGE_width(v,w)      CGRectMake(X(v), Y(v), w, HEIGHT(v))
#define RECT_CHANGE_height(v,h)     CGRectMake(X(v), Y(v), WIDTH(v), h)
#define RECT_CHANGE_size(v,w,h)     CGRectMake(X(v), Y(v), w, h)

// 系统控件默认高度
#define kStatusBarHeight        (20.f)

#define kTopBarHeight           (44.f)
#define kBottomBarHeight        (49.f)
#define kNavHeight              (64.f)

#define kCellDefaultHeight      (44.f)

#define kEnglishKeyboardHeight  (216.f)
#define kChineseKeyboardHeight  (252.f)


/* ****************************************************************************************************************** */
#pragma mark - Funtion Method (宏 方法)

// PNG JPG 图片路径
#define PNGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"png"]
#define JPGPATH(NAME)           [[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:NAME] ofType:@"jpg"]
#define PATH(NAME, EXT)         [[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]

// 加载图片
#define PNGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"png"]]
#define JPGIMAGE(NAME)          [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:@"jpg"]]
#define IMAGE(NAME, EXT)        [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:(NAME) ofType:(EXT)]]

// 字体大小(常规/粗体)
#define BOLDSYSTEMFONT(FONTSIZE)[UIFont boldSystemFontOfSize:FONTSIZE]
#define SYSTEMFONT(FONTSIZE)    [UIFont systemFontOfSize:FONTSIZE]
#define FONT(NAME, FONTSIZE)    [UIFont fontWithName:(NAME) size:(FONTSIZE)]

// 颜色(RGB)
#define RGBCOLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r, g, b, a)   [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

//number转String
#define IntTranslateStr(int_str) [NSString stringWithFormat:@"%d",int_str];
#define FloatTranslateStr(float_str) [NSString stringWithFormat:@"%.2d",float_str];

// View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES];\
                                [View.layer setBorderWidth:(Width)];\
                                [View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
                                \
                                [View.layer setCornerRadius:(Radius)];\
                                [View.layer setMasksToBounds:YES]

// 当前版本
#define FSystemVersion          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DSystemVersion          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define SSystemVersion          ([[UIDevice currentDevice] systemVersion])

// 当前语言
#define CURRENTLANGUAGE         ([[NSLocale preferredLanguages] objectAtIndex:0])

// 是否Retina屏
#define isRetina                ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                                CGSizeEqualToSize(CGSizeMake(640, 960), \
                                                  [[UIScreen mainScreen] currentMode].size) : \
                                NO)

// 是否iPhone5
#define isiPhone5               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                                CGSizeEqualToSize(CGSizeMake(640, 1136), \
                                                  [[UIScreen mainScreen] currentMode].size) : \
                                NO)
// 是否iPhone4
#define isiPhone4               ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
                                CGSizeEqualToSize(CGSizeMake(640, 960), \
                                [[UIScreen mainScreen] currentMode].size) : \
                                NO)

// 是否IOS7
#define isIOS7                  ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)

// 是否IOS6
#define isIOS6                  ([[[UIDevice currentDevice]systemVersion]floatValue] < 7.0)

#define isLessThanIOS9          ([[[UIDevice currentDevice]systemVersion]floatValue] < 9.0)
#define isLessThanIOS8          ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0)



// 是否iPad
#define isPad                   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// UIView - viewWithTag
#define VIEWWITHTAG(_OBJECT, _TAG)\
                                \
                                [_OBJECT viewWithTag : _TAG]

// 本地化字符串
/** NSLocalizedString宏做的其实就是在当前bundle中查找资源文件名“Localizable.strings”(参数:键＋注释) */
#define LocalString(x, ...)     NSLocalizedString(x, nil)
/** NSLocalizedStringFromTable宏做的其实就是在当前bundle中查找资源文件名“xxx.strings”(参数:键＋文件名＋注释) */
#define AppLocalString(x, ...)  NSLocalizedStringFromTable(x, @"someName", nil)

// RGB颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue)\
                                \
                                [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                 blue:((float)(rgbValue & 0xFF))/255.0 \
                                                alpha:1.0]

#if TARGET_OS_IPHONE
/** iPhone Device */
#endif

#if TARGET_IPHONE_SIMULATOR
/** iPhone Simulator */
#endif

// ARC
#if __has_feature(objc_arc)
/** Compiling with ARC */
#else
/** Compiling without ARC */
#endif


/* ****************************************************************************************************************** */
#pragma mark - Log Method (宏 LOG)

// 日志 / 断点
// =============================================================================================================================
// DEBUG模式
#define ITTDEBUG

// LOG等级
#define ITTLOGLEVEL_INFO        10
#define ITTLOGLEVEL_WARNING     3
#define ITTLOGLEVEL_ERROR       1

// =============================================================================================================================
// LOG最高等级
#ifndef ITTMAXLOGLEVEL

#ifdef DEBUG
#define ITTMAXLOGLEVEL ITTLOGLEVEL_INFO
#else
#define ITTMAXLOGLEVEL ITTLOGLEVEL_ERROR
#endif

#endif

// =============================================================================================================================
// LOG PRINT
// The general purpose logger. This ignores logging levels.
#ifdef ITTDEBUG
#define ITTDPRINT(xx, ...)      NSLog(@"< %s:(%d) > : " xx , __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
#define ITTDPRINT(xx, ...)      ((void)0)
#endif

// Prints the current method's name.
#define ITTDPRINTMETHODNAME()   ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

// Log-level based logging macros.
#if ITTLOGLEVEL_ERROR <= ITTMAXLOGLEVEL
#define ITTDERROR(xx, ...)      ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDERROR(xx, ...)      ((void)0)
#endif

#if ITTLOGLEVEL_WARNING <= ITTMAXLOGLEVEL
#define ITTDWARNING(xx, ...)    ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDWARNING(xx, ...)    ((void)0)
#endif

#if ITTLOGLEVEL_INFO <= ITTMAXLOGLEVEL
#define ITTDINFO(xx, ...)       ITTDPRINT(xx, ##__VA_ARGS__)
#else
#define ITTDINFO(xx, ...)       ((void)0)
#endif

// 条件LOG
#ifdef ITTDEBUG
#define ITTDCONDITIONLOG(condition, xx, ...)\
                                \
                                {\
                                    if ((condition))\
                                    {\
                                        ITTDPRINT(xx, ##__VA_ARGS__);\
                                    }\
                                }
#else
#define ITTDCONDITIONLOG(condition, xx, ...)\
                                \
                                ((void)0)
#endif

// 断点Assert
#define ITTAssert(condition, ...)\
                                \
                                do {\
                                    if (!(condition))\
                                    {\
                                        [[NSAssertionHandler currentHandler]\
                                        handleFailureInFunction:[NSString stringWithFormat:@"< %s >", __PRETTY_FUNCTION__]\
                                                           file:[[NSString stringWithUTF8String:__FILE__] lastPathComponent]\
                                                     lineNumber:__LINE__\
                                                    description:__VA_ARGS__];\
                                    }\
                                } while(0)


/* ****************************************************************************************************************** */
#pragma mark - Constants (宏 常量)


/** 时间间隔 */
#define kHUDDuration            (1.f)

/** 一天的秒数 */
#define SecondsOfDay            (24.f * 60.f * 60.f)
/** 秒数 */
#define Seconds(Days)           (24.f * 60.f * 60.f * (Days))

/** 一天的毫秒数 */
#define MillisecondsOfDay       (24.f * 60.f * 60.f * 1000.f)
/** 毫秒数 */
#define Milliseconds(Days)      (24.f * 60.f * 60.f * 1000.f * (Days))


//** textAlignment ***********************************************************************************

#if !defined __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
# define LINE_BREAK_WORD_WRAP UILineBreakModeWordWrap
# define TextAlignmentLeft UITextAlignmentLeft
# define TextAlignmentCenter UITextAlignmentCenter
# define TextAlignmentRight UITextAlignmentRight

#else
# define LINE_BREAK_WORD_WRAP NSLineBreakByWordWrapping
# define TextAlignmentLeft NSTextAlignmentLeft
# define TextAlignmentCenter NSTextAlignmentCenter
# define TextAlignmentRight NSTextAlignmentRight

#endif



#endif
