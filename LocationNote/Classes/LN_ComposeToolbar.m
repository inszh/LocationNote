//
//  LN_ComposeToolbar.m
//  LocationNote
//
//  Created by 小华 on 16/5/8.
//  Copyright © 2016年 ark. All rights reserved.
//

#import "LN_ComposeToolbar.h"
#import "UIView+Extension.h"

@interface LN_ComposeToolbar()

@property (nonatomic, weak) UIButton *dateButton;

@end

@implementation LN_ComposeToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"compose_toolbar_background"]];
        
        // 添加所有的子控件
        [self addButtonWithIcon:@"compose_camerabutton_background" highIcon:@"compose_camerabutton_background_highlighted" title:nil tag:LN_ComposeToolbarButtonTypeCamera];
        [self addButtonWithIcon:@"compose_toolbar_picture" highIcon:@"compose_toolbar_picture_highlighted" title:nil tag:LN_ComposeToolbarButtonTypePicture];
        [self addButtonWithIcon:nil highIcon:nil title:@"提醒" tag:LN_ComposeToolbarButtonTypeCalendar];
        [self addButtonWithIcon:nil highIcon:nil title:@"位置" tag:LN_ComposeToolbarButtonTypeMap];
//        [self addButtonWithIcon:nil highIcon:nil title:@"保存" tag:LN_ComposeToolbarButtonTypeSave];

//        self.dateButton = [self addButtonWithIcon:nil highIcon:nil title:@"闹钟" tag:LN_ComposeToolbarButtonTypedate];
    }
    return self;
}

-(void)setShowdateButton:(BOOL)showdateButton
{
    _showdateButton = showdateButton;
    if (showdateButton) {
        [self.dateButton setImage:nil forState:UIControlStateNormal];
        [self.dateButton setTitle:@"闹钟" forState:0];

    } else { // 切换为键盘按钮
        
        [self.dateButton setImage:[UIImage imageNamed:@"compose_keyboardbutton_background"] forState:UIControlStateNormal];
        [self.dateButton setImage:[UIImage imageNamed:@"compose_keyboardbutton_background_highlighted"] forState:UIControlStateHighlighted];
        [self.dateButton setTitle:@"" forState:0];

    }
}

/**
 *  添加一个按钮
 *
 *  @param icon     默认图标
 *  @param highIcon 高亮图标
 */
- (UIButton *)addButtonWithIcon:(NSString *)icon highIcon:(NSString *)highIcon title:(NSString *)title tag:(LN_ComposeToolbarButtonType)tag
{
    UIButton *button = [[UIButton alloc] init];
    button.tag = tag;
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setTitle:title  forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    [self addSubview:button];
    [button setTitleColor:[UIColor grayColor] forState:0];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];

    return button;
}

/**
 *  监听按钮点击
 */
- (void)buttonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(composeTool:didClickedButton:)]) {
        [self.delegate composeTool:self didClickedButton:button.tag];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    

    int count = self.subviews.count;
    CGFloat buttonW = self.width / count;
    CGFloat buttonH = self.height;
    for (int i = 0; i<count; i++) {
        UIButton *button = self.subviews[i];
        button.y = 0;
        button.width = buttonW;
        button.height = buttonH;
        button.x = i * buttonW;
    }
}


@end
