//
//  NewLend.h
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAndSearchFriendsViewController.h"
#import "ItemsView.h"
#import "ViewWithJoypad.h"
#import "Friend.h"

@interface NewLend :ViewWithJoypad<AddAndSearchFriendsViewControllerDelegate>
{
    UIButton*backBtn;
    
    AddAndSearchFriendsViewController* friendsController;
    
    Friend* borrower;
}
@property (nonatomic,strong)id<ViewWithJoypadDelegate>delegate;

@end
