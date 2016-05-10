//
//  LN_NoteListController.m
//  LocationNote
//
//  Created by 小华 on 16/5/10.
//  Copyright © 2016年 ark. All rights reserved.
//

#import "LN_NoteListController.h"
#import "LN_DataModel.h"
@interface LN_NoteListController ()

@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation LN_NoteListController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *barBtn=[[UIBarButtonItem alloc]initWithTitle:@"地图" style:UIBarButtonItemStylePlain target:self action:@selector(changeViewModel)];
    self.navigationItem.rightBarButtonItem=barBtn;
    
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [LN_DataModel selectWhere:nil groupBy:nil orderBy:nil limit:nil selectResultsBlock:^(NSArray *selectResults) {
        
        for (LN_DataModel *dataM in selectResults) {
            
            [self.dataArray addObject:dataM];
            
            [self.tableView reloadData];
        }
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
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    LN_DataModel *dataM=self.dataArray[indexPath.row];
    cell.textLabel.text=dataM.content;
    cell.detailTextLabel.text=dataM.saveTime;
    return cell;
}

- (void)changeViewModel
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
