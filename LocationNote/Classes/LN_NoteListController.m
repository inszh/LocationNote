//
//  LN_NoteListController.m
//  LocationNote
//
//  Created by 小华 on 16/5/10.
//  Copyright © 2016年 ark. All rights reserved.
//

#import "LN_NoteListController.h"
#import "LN_DataModel.h"
#import "LN_NoteListCell.h"
#import "UIView+Extension.h"
#import "LN_NoteDetailController.h"
#import "LN_CreatBtn.h"

@interface LN_NoteListController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation LN_NoteListController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    UIBarButtonItem *barBtn=[[UIBarButtonItem alloc]initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(changeViewModel)];
    self.navigationItem.rightBarButtonItem=barBtn;

    [LN_CreatBtn creatBtnWithVC:self.view];

}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [LN_DataModel selectWhere:nil groupBy:nil orderBy:nil limit:nil selectResultsBlock:^(NSArray *selectResults) {
        
        for (LN_DataModel *dataM in selectResults) {
            
            [self.dataArray addObject:dataM];
            
        }
        
        [self.tableView reloadData];

    }];

}

-(NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LN_NoteListCell *cell = [LN_NoteListCell cellWithTable:tableView];
    cell.dataM=self.dataArray[indexPath.row];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LN_NoteListCell *cell = (LN_NoteListCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];;

    return cell.height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (UITableViewCellEditingStyleDelete)
    {
        
        LN_DataModel*dataM=self.dataArray[indexPath.row];
        
        [LN_DataModel deleteWhere:[NSString stringWithFormat: @"content=%@", dataM.content] resBlock:^(BOOL res) {
            
        }];
        [self.dataArray removeObject:self.dataArray[indexPath.row]];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationRight];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LN_NoteDetailController *noteDetail=[LN_NoteDetailController new];
    [self.navigationController pushViewController:noteDetail animated:YES];
}


- (void)changeViewModel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
