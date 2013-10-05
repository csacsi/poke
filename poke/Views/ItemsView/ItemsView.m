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
        list = @[].mutableCopy;
        
        Friend *csacsi = [[Friend alloc]init];
        [csacsi setName:@"Toth Csaba"];
        [csacsi setEmail:@"huncsacsika@gmail.com"];
        [csacsi setPhoneNumber:@"+36304724243"];
        
        Friend * csomak = [[Friend alloc]init];
        [csomak setName:@"Csomak Gabor"];
        [csomak setEmail:@"csomakk@gmail.com"];
        [csomak setPhoneNumber:@"+36303211232"];
        
        LendInteraction * lendone = [[LendInteraction alloc]init];
        [lendone setName:@"Lord of the rings"];
        [lendone setCategoryType: lendCategoryBook];
        [lendone setAmount:@1];
        [lendone setStatus:100.0];
        [lendone setFriend:csomak];
//        [lendone setUser:[PFUser currentUser]];
        
        LendInteraction*lendTwo = [[LendInteraction alloc]init];
        [lendTwo setName:@"Lunch"];
        [lendTwo setCategoryType:lendCategoryCash];
        [lendTwo setAmount:@1200];
        [lendTwo setStatus:1.0];
        [lendTwo setFriend:csacsi];
//        [lendTwo setUser:[PFUser currentUser]];
        
        
        friends = @[csacsi,csomak].mutableCopy;
        list = @[lendTwo, lendone].mutableCopy;
        [list sortUsingComparator:^NSComparisonResult(LendInteraction* obj1, LendInteraction* obj2) {
            return obj1 .status<obj2.status;
        }];
        
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
