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
@synthesize friendsSearchBar;
@synthesize filteredFriendsArray;
@synthesize lastSearchText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    if (table == self.searchDisplayController.searchResultsTableView) {
        return [filteredFriendsArray count];
    } else {
        return [friendsArray count];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Create a new Candy Object
    Friend *friendItem = nil;
    
    // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        friendItem = [filteredFriendsArray objectAtIndex:indexPath.row];
    } else {
        friendItem = [friendsArray objectAtIndex:indexPath.row];
    }
    
    // Configure the cell
    cell.textLabel.text = friendItem.name;
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    return cell;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    friendsArray = [ NSMutableArray arrayWithObjects:
                    [ Friend name:@"Csomak" email:@"csomakk@gmail.com" ]
                    ,[ Friend name:@"Csacsi" email:@"huncsacsika@gmail.com" ]
                    ,[ Friend name:@"Jezus" email:@"csomakk@gmail.com" ]
                    ,[ Friend name:@"Jenny" email:@"csomakk@gmail.com" ]
                    ,nil ];
    
    
    [self.table reloadData];
    self.filteredFriendsArray = [NSMutableArray arrayWithCapacity:[friendsArray count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backPressed:(id)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:eventMainViewBackToNormal object:self.view];
}

#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.filteredFriendsArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@", searchText];
    filteredFriendsArray = [NSMutableArray arrayWithArray:[friendsArray filteredArrayUsingPredicate:predicate]];
    lastSearchText = searchText;
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (IBAction)createAction:(id)sender {
    Friend *friend = [ Friend name: lastSearchText email:@"csomakk@gmail.com" ];
    [friendsArray addObject:friend];
    [self.table reloadData];
    
}

@end
