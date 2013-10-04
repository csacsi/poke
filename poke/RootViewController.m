//
//  RootViewController.m
//  poke
//
//  Created by Toth Csaba on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "RootViewController.h"
#import "MainTableCell.h"
#import <Parse/Parse.h>

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self initParse];
        // Custom initialization
        [self.view setBackgroundColor:[UIColor redColor]];
        tbl = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [tbl setDataSource:self];
        [tbl  setDelegate:self];
        [self.view addSubview:tbl];
        [tbl registerClass:[MainTableCell class] forCellReuseIdentifier:@"mainCell"];
        list = @[@"elso",@"masodik",@"harmadik"].mutableCopy;
    }
    return self;
}
-(void)initParse
{
    [Parse setApplicationId:@"7rie26iRzAwT5W1AlPweu6hFcIbqRT5DT9cmWJQb" clientKey:@"sk4dkLvdjQALhli0O1cPjU2Wpqng28e0Fnc1Q3wr"];
    
    NSError* error;
    [PFUser logInWithUsername:@"testuser" password:@"123456" error:&error];
    
    if (error) {
        NSLog(@"Cant login to parse:%@",[error localizedDescription]);
    }

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    
    [cell setText:list[indexPath.row]];
    
    return cell;
}
@end
