//
//  RootViewController.h
//  poke
//
//  Created by Toth Csaba on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RootViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,PFLogInViewControllerDelegate,PFSignUpViewControllerDelegate>
{
    UITableView*tbl;
    
    NSMutableArray*list;
}

@end
