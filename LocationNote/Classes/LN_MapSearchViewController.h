//
//  LN_MapSearchViewController.h
//  LocationNote
//
//  Created by 小华 on 16/5/10.
//  Copyright © 2016年 ark. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LN_MapSearchViewController,LN_LocationM;

@protocol ln_MapSearchViewControllerDelegate <NSObject>

@optional

- (void)ln_searchViewdidCilckDone:(LN_MapSearchViewController *)searchVc seletM:(LN_LocationM *)dataM;

@end

@interface LN_MapSearchViewController : UIViewController

@property(nonatomic,assign)id<ln_MapSearchViewControllerDelegate> delegate;

@end
