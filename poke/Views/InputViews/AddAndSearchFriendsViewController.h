//
//  AddAndSearchFriendsViewController.h
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddAndSearchFriendsViewController : UIViewController
@property (strong, nonatomic) IBOutlet UITableView *table;
- (IBAction)backPressed:(id)sender;


@property (strong, nonatomic) NSArray *friendsArray;

@end
