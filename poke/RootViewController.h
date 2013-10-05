//
//  RootViewController.h
//  poke
//
//  Created by Toth Csaba on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseDataHandler.h"
#import "MainView.h"
@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate,DataHandlerDelegate>
{
    UITableView*tbl;
    
    NSMutableArray*list;
    NSMutableArray*friends;
    NSMutableArray*lendings;
    
    MainView* mainView;
}


@end
