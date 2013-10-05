//
//  RootViewController.m
//  poke
//
//  Created by Toth Csaba on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "RootViewController.h"
#import "MainTableCell.h"

#import "LendInteraction.h"
#import "Message.h"
#import "ParseDataHandler.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
//        [self.view setBackgroundColor:[UIColor redColor]];
//        tbl = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
//        [tbl setDataSource:self];
//        [tbl setContentInset:UIEdgeInsetsMake(60, 0, 0, 0)];
//        [tbl  setDelegate:self];
//        [self.view addSubview:tbl];
//        [tbl registerClass:[MainTableCell class] forCellReuseIdentifier:@"mainCell"];
//        list = @[].mutableCopy;
        
        mainView = [[MainView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        [self.view addSubview:mainView];
        
       
        
    }
    return self;
}

-(void)initParse
{
    [Parse setApplicationId:@"es6gaHEsuLTK94BfIsTbsadbEnCeb065c32dwcMq" clientKey:@"WWbpWKeHZwK4JEgQXIVUDPOWGFxA63S0ZCxtruWG"];
    
    if (![PFUser currentUser])
    {
        PFLogInViewController* loginVC = [[PFLogInViewController alloc]init];
        [loginVC setDelegate:self];
        
        PFSignUpViewController* signupVC = [[PFSignUpViewController alloc]init];
        [signupVC setDelegate:self];
        
        [loginVC setSignUpController:signupVC];
        
        [self presentViewController:loginVC animated:YES completion:nil];
        
        
        
    } else {
        
        PFObject *msgObject = [PFObject objectWithClassName:@"Message"];
        [msgObject setObject: @"derjugoBaszod" forKey:@"text"];
        [msgObject setObject:[NSNumber numberWithBool:NO] forKey:@"cancelled"];
        [msgObject setObject:[NSNumber numberWithBool:NO] forKey:@"sent"];
        [msgObject setObject:[NSNumber numberWithBool:NO] forKey:@"isSMS"];
        [msgObject setObject: @"csomakk@gmail.com" forKey:@"to"];
        [msgObject setObject: [NSDate date] forKey:@"date"];
        [msgObject saveInBackground];
 
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
        [self initParse];
    
    if ([PFUser currentUser]) {
       
//        ParseDataHandler* ph = [[ParseDataHandler alloc]init];
//        
//        [ph saveArrayInBackground:@[csacsi,csomak,lendone,lendTwo] completionBlock:^(BOOL succeeded, NSError *error) {
//            if (!succeeded) {
//                NSLog(@"Baj van babam");
//            }
//        }];
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark parse delegate methods
// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}
// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}
// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}
// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}

#pragma mark parsedataHandlerDelegate



@end
