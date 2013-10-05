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
    [Parse setApplicationId:@"7rie26iRzAwT5W1AlPweu6hFcIbqRT5DT9cmWJQb" clientKey:@"sk4dkLvdjQALhli0O1cPjU2Wpqng28e0Fnc1Q3wr"];
    
    if (![PFUser currentUser])
    {
        PFLogInViewController* loginVC = [[PFLogInViewController alloc]init];
        [loginVC setDelegate:self];
        
        PFSignUpViewController* signupVC = [[PFSignUpViewController alloc]init];
        [signupVC setDelegate:self];
        
        [loginVC setSignUpController:signupVC];
        
        [self presentViewController:loginVC animated:YES completion:nil];
        
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
        Friend *csacsi = [[Friend alloc]init];
        [csacsi setName:@"Toth Csaba"];
        [csacsi setEmail:@"huncsacsika@gmail.com"];
        [csacsi setPhoneNumber:@"+36304724243"];
        
        Friend * csomak = [[Friend alloc]init];
        [csomak setName:@"Csomak Gabor"];
        [csomak setEmail:@"csomakk@gmail.com"];
        [csomak setPhoneNumber:@"+36303211232"];
        
        LendInteraction * lendone = [[LendInteraction alloc]init];
        [lendone setName:@"Lord of the rings"];
        [lendone setCategoryType: lendCategoryBook];
        [lendone setAmount:@1];
        [lendone setStatus:100.0];
        [lendone setFriend:csomak];
        [lendone setUser:[PFUser currentUser]];
        
        LendInteraction*lendTwo = [[LendInteraction alloc]init];
        [lendTwo setName:@"Lunch"];
        [lendTwo setCategoryType:lendCategoryCash];
        [lendTwo setAmount:@1200];
        [lendTwo setStatus:1.0];
        [lendTwo setFriend:csacsi];
        [lendTwo setUser:[PFUser currentUser]];
        
        
        friends = @[csacsi,csomak].mutableCopy;
        list = @[lendTwo, lendone].mutableCopy;
        [list sortUsingComparator:^NSComparisonResult(LendInteraction* obj1, LendInteraction* obj2) {
            return obj1 .status<obj2.status;
        }];
        
        [tbl reloadData];
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

#pragma mark 
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return list.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableCell* cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    int number = indexPath.row;
    [cell setModel:list[number]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tableview selected:%d",indexPath.row);
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
