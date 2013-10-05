//
//  ItemsView.m
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "ItemsView.h"
#import "MainTableCell.h"

@implementation ItemsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [backBtn setTitle:@"<" forState:UIControlStateNormal];
        [backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
        
        
        tbl = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [tbl setDataSource:self];
        [tbl setContentInset:UIEdgeInsetsMake(60, 0, 0, 0)];
        [tbl  setDelegate:self];
        [tbl setBackgroundColor:[UIColor clearColor]];
        [self addSubview:tbl];
        [tbl registerClass:[MainTableCell class] forCellReuseIdentifier:@"mainCell"];
        list = [DataManager getInstance].myLends;
        
                
        [tbl reloadData];
        
        [self addSubview:backBtn];
    }
    return self;
}
-(void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self reArrange];
}
-(void)reArrange{
    [backBtn setFrame:CGRectMake(0, 0, 50, 50)];
    [tbl setFrame:CGRectMake(0, 0, self.width, self.height)];
}
-(void)goBack{
    [[NSNotificationCenter defaultCenter]postNotificationName:eventMainViewBackToNormal object:self];
}

#pragma mark tableViewdelegates
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    int number = indexPath.row;
    [cell setModel:list[number]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableview selected:%d",indexPath.row);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
