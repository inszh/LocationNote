//
//  LN_NoteListCell.m
//  LocationNote
//
//  Created by 小华 on 16/5/10.
//  Copyright © 2016年 ark. All rights reserved.
//

#import "LN_NoteListCell.h"
#import "UIView+Extension.h"

@interface LN_NoteListCell ()

@property(nonatomic,weak)UILabel *timeLab;
@property(nonatomic,weak)UILabel *listTitleLab;
@property(nonatomic,weak)UILabel *listSubTitleLab;
@property(nonatomic,weak)UIView *line;


@end

@implementation LN_NoteListCell

+(LN_NoteListCell *)cellWithTable:(UITableView *)tableView
{
    static NSString *ID=@"listCell";
    
    LN_NoteListCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell==nil) {
        cell=[[LN_NoteListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        UILabel *timeLab=[[UILabel alloc]init];
        self.timeLab=timeLab;
        self.timeLab.numberOfLines=0;
        self.timeLab.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.timeLab];
        
        UILabel *listTitleLab=[[UILabel alloc]init];
        self.listTitleLab=listTitleLab;
        listTitleLab.numberOfLines=0;
        listTitleLab.font=[UIFont systemFontOfSize:16];
        [self.contentView addSubview:listTitleLab];
        
        
        UILabel *listSubTitleLab=[[UILabel alloc]initWithFrame:CGRectMake(MaxX(self.timeLab)+10,MaxY(self.listTitleLab)+5, ScreenW-MaxX(self.timeLab)-20, 30)];
        self.listSubTitleLab=listSubTitleLab;
        self.listSubTitleLab.numberOfLines=0;
        self.listSubTitleLab.font=[UIFont systemFontOfSize:13];
        self.listSubTitleLab.contentMode=UIViewContentModeTop;
        self.listSubTitleLab.textColor=[UIColor darkGrayColor];
        [self.contentView addSubview:self.listSubTitleLab];
        
        UIView *line=[[UIView alloc]init];
        line.backgroundColor=LHNewGrayGroundColor;
        self.line=line;
        [self.contentView addSubview:line];
        
    }
    
    return self;
}


-(void)setDataM:(LN_DataModel *)dataM
{
    _dataM=dataM;
    
    NSArray  * array= [dataM.saveTime componentsSeparatedByString:@"|"];
    self.timeLab.text=[NSString stringWithFormat:@"%@\n%@",array[0],array[1]];
    self.timeLab.frame=CGRectMake(10,5,ScreenW*0.2,[self sizeWithLab:self.timeLab]);

    self.listTitleLab.text=dataM.content;
    DLog(@"%@",dataM.content);
    self.listTitleLab.frame=CGRectMake(MaxX(self.timeLab)+10,5, ScreenW-MaxX(self.timeLab)-10,[self sizeWithLab:self.listTitleLab]);
    
    self.listSubTitleLab.text=dataM.targetAdress;
    self.listSubTitleLab.frame=CGRectMake(self.listTitleLab.x-10,MaxY(self.listTitleLab)+5, ScreenW-MaxX(self.timeLab)-10,[self sizeWithLab:self.listSubTitleLab]);
    
    self.line.frame=CGRectMake(0, MaxY(self.listSubTitleLab)+5, ScreenW, 1);
    
    self.height=MaxY(self.line) ;

}

-(CGFloat)sizeWithLab:(UILabel *)lab
{
    CGRect rect = [lab.text boundingRectWithSize:CGSizeMake(ScreenW-MaxX(self.timeLab)-20, 1000)//限制最大的宽度和高度
                                         options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                      attributes:@{NSFontAttributeName: lab.font}//传入的字体字典
                                         context:nil];
    
    return rect.size.height+10;
}

@end
