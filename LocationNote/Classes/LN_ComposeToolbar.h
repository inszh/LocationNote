//
//  LN_ComposeToolbar.h
//  LocationNote
//
//  Created by 小华 on 16/5/8.
//  Copyright © 2016年 ark. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    LN_ComposeToolbarButtonTypeCamera, // 照相机
    LN_ComposeToolbarButtonTypePicture, // 相册
    LN_ComposeToolbarButtonTypeCalendar, // 日历
    LN_ComposeToolbarButtonTypeSave, // 话题
    LN_ComposeToolbarButtonTypedate // 日期
} LN_ComposeToolbarButtonType;

@class LN_ComposeToolbar;

@protocol LN_ComposeToolbarDelegate <NSObject>

@optional
- (void)composeTool:(LN_ComposeToolbar *)toolbar didClickedButton:(LN_ComposeToolbarButtonType)buttonType;

@end

@interface LN_ComposeToolbar : UIView

@property (nonatomic, weak) id<LN_ComposeToolbarDelegate> delegate;

@property (nonatomic, assign, getter = isShowdateButton) BOOL showdateButton;

@end
