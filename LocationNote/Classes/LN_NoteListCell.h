//
//  LN_NoteListCell.h
//  LocationNote
//
//  Created by 小华 on 16/5/10.
//  Copyright © 2016年 ark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LN_DataModel.h"

@interface LN_NoteListCell : UITableViewCell

@property(nonatomic,strong)LN_DataModel * dataM;

+(LN_NoteListCell *)cellWithTable:(UITableView *)tableView;


@end
