//
//  LN_UserLocation.h
//  LocationNote
//
//  Created by 小华 on 16/5/6.
//  Copyright © 2016年 ark. All rights reserved.
//

#import "CoreModel.h"
@class CLLocation;

@interface LN_UserLocation : CoreModel

/// 位置信息，尚未定位成功，则该值为nil
@property (nonatomic,strong) CLLocation *location;

@end
