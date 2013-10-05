//
//  MainView.h
//  poke
//
//  Created by Toth Csaba on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewWithJoypad.h"
#import "AddAndSearchFriendsViewController.h"
#import "ItemsView.h"
#import "NewLend.h"

@interface MainView : ViewWithJoypad<ViewWithJoypadDelegate>
{
    NewLend* lendView;
    AddAndSearchFriendsViewController* addfriendsView;
    ItemsView* itemsView;
}

@end
