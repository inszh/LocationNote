//
//  LN_CreatBtn.m
//  LocationNote
//
//  Created by 小华 on 16/5/10.
//  Copyright © 2016年 ark. All rights reserved.
//

#import "LN_CreatBtn.h"
#import "LN_NoteDetailController.h"

@implementation LN_CreatBtn

-(instancetype)init
{
    CGRect frame = CGRectMake(ScreenW-60, ScreenH-kTopBarHeight-40, 40, 40);
    if (self=[super initWithFrame:frame]) {
        
        [self configBallView];
    }
    return self;
}
+ (instancetype)shareView
{
    return [[self alloc]init];
}



+ (void)creatBtnWithVC:(UIView *)view
{
    [view addSubview:[LN_CreatBtn shareView]];
}


- (void)configBallView
{
    self.userInteractionEnabled=YES;
    self.image=[UIImage imageNamed:@"detail_post_ugc_h"];
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(createNote)];
    [self addGestureRecognizer:tapGes];
    
}

- (void)createNote
{
    LN_NoteDetailController *note=[LN_NoteDetailController new];
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:note];
    [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
}


@end
