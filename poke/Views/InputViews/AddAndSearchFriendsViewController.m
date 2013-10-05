//
//  AddAndSearchFriendsViewController.m
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "AddAndSearchFriendsViewController.h"
#import "Friend.h"

@interface AddAndSearchFriendsViewController ()

@end

@implementation AddAndSearchFriendsViewController

@synthesize friendsArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [friendsArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Create a new Candy Object
    Friend *friendItem = nil;
    friendItem = [friendsArray objectAtIndex:indexPath.row];
    // Configure the cell
    cell.textLabel.text = friendItem.name;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    friendsArray = [ NSArray arrayWithObjects:
                    [ Friend name:@"Csomak" email:@"csomakk@gmail.com" ]
                    ,[ Friend name:@"Csacsi" email:@"huncsacsika@gmail.com" ]
                    ,[ Friend name:@"Jezus" email:@"csomakk@gmail.com" ]
                    ,[ Friend name:@"Jenny" email:@"csomakk@gmail.com" ]
                    ,nil ];
    
    
    [self.table reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backPressed:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:eventMainViewBackToNormal object:self.view];
}

@end
