//
//  LN_DataModel.h
//  LocationNote
//
//  Created by 小华 on 16/5/5.
//  Copyright © 2016年 ark. All rights reserved.
//

#import "CoreModel.h"


@interface LN_DataModel : CoreModel

@property(nonatomic,copy)NSString * content;

@property(nonatomic,copy)NSString * currentPosition;

@property(nonatomic,copy)NSString * targetPosition;

@property(nonatomic,copy)NSString * saveTime;

@property(nonatomic,copy)NSString * alertTime;

@property(nonatomic,strong)NSData * audio;

@property(nonatomic,strong)NSData * pic;




@end
