//
//  AddAndSearchFriendsViewController.h
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import <AddressBookUI/AddressBookUI.h>
#import <UIKit/UIKit.h>
#import "ViewWithJoypad.h"
#import "Friend.h"
@class AddAndSearchFriendsViewController;
@protocol AddAndSearchFriendsViewControllerDelegate <NSObject>

-(void)personSelected:(Friend*)person;

@end

@interface AddAndSearchFriendsViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, ABPeoplePickerNavigationControllerDelegate,UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) NSMutableArray *filteredFriendsArray;
@property IBOutlet UISearchBar *friendsSearchBar;

@property (weak, nonatomic) IBOutlet UIButton *create;

- (IBAction)createAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *table;
- (IBAction)backPressed:(id)sender;

@property NSString *lastSearchText;

@property (strong, nonatomic) NSMutableArray *friendsArray;

@property (nonatomic,strong)id<ViewWithJoypadDelegate>delegate;

@property BOOL allowDismiss;

@property (nonatomic,strong) id<AddAndSearchFriendsViewControllerDelegate>personDelegate;

@end
