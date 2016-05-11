//
//  LN_LocationM.h
//  LocationNote
//
//  Created by 小华 on 16/5/11.
//  Copyright © 2016年 ark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LN_LocationM : NSObject

@property (nonatomic, copy)NSString *city;
@property (nonatomic, copy)NSString *district;
@property (nonatomic, copy)NSString *keyName;
@property (nonatomic, copy)NSString *poiId;
@property(nonatomic,strong)NSValue * pt;
@property (nonatomic, assign)CLLocationCoordinate2D coor;

@end
