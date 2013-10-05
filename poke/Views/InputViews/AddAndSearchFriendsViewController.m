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
        [self.view setBackgroundColor:[UIColor redColor]];
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
    
    friendsArray = [DataManager getInstance].myFriends;
    
    [self.table reloadData];
    self.filteredFriendsArray = [NSMutableArray arrayWithCapacity:[friendsArray count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backPressed:(id)sender {
    [self.delegate viewWithJoypadBackPressed:self.view];
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
    ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self dismissViewControllerAnimated:YES completion: nil];
}

- (void)peoplePickerNavigationControllerDidCancel:
(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion: nil];
}


- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    CFStringRef firstName, lastName;
    firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
    lastName  = ABRecordCopyValue(person, kABPersonLastNameProperty);
    
    Friend *friend = [ Friend
                      name: [NSString stringWithFormat:@"%@ %@",firstName,lastName]
                      email:  (__bridge_transfer NSString*)ABRecordCopyValue(person, kABPersonEmailProperty)
                    ];
    [friendsArray addObject:friend];
    [self.table reloadData];
    [self dismissViewControllerAnimated:YES completion: nil];
    
    return NO;
}

- (BOOL)peoplePickerNavigationController:
(ABPeoplePickerNavigationController *)peoplePicker
      shouldContinueAfterSelectingPerson:(ABRecordRef)person
                                property:(ABPropertyID)property
                              identifier:(ABMultiValueIdentifier)identifier
{
    return NO;
}

@end
