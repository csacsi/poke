//
//  DataManager.m
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "DataManager.h"

#import "Friend.h"
#import "LendInteraction.h"

@implementation DataManager

-(id)init{
    self = [super init];
    if (self) {
        Friend *csacsi = [[Friend alloc]init];
        [csacsi setName:@"Toth Csaba"];
        [csacsi setEmail:@"huncsacsika@gmail.com"];
        [csacsi setPhoneNumber:@"+36304724243"];
        [csacsi setPicture:[UIImage imageNamed:@"user01"]];
        
        Friend * csomak = [[Friend alloc]init];
        [csomak setName:@"Csomak Gabor"];
        [csomak setEmail:@"csomakk@gmail.com"];
        [csomak setPhoneNumber:@"+36303211232"];
        [csomak setPicture:[UIImage imageNamed:@"user02"]];
        
        Friend * foxy = [[Friend alloc]init];
        [foxy setName:@"Zsofi Terjek"];
        [foxy setEmail:@"zsofi@gmail.com"];
        [foxy setPhoneNumber:@"+36303211232"];
        [foxy setPicture:[UIImage imageNamed:@"user03"]];
        
        
        LendInteraction * lendone = [[LendInteraction alloc]init];
        [lendone setName:@"Lord of the rings"];
        [lendone setCategoryType: lendCategoryBook];
        [lendone setAmount:@1];
        [lendone setStatus:100.0];
        [lendone setFriend:csomak];
        //        [lendone setUser:[PFUser currentUser]];
        
        LendInteraction*lendTwo = [[LendInteraction alloc]init];
        [lendTwo setName:@"Lunch"];
        [lendTwo setCategoryType:lendCategoryCash];
        [lendTwo setAmount:@1200];
        [lendTwo setStatus:1.0];
        [lendTwo setFriend:csacsi];
        //        [lendTwo setUser:[PFUser currentUser]];
        
        
        _myFriends = @[csacsi,csomak,foxy].mutableCopy;
        _myLends = @[lendTwo, lendone].mutableCopy;
        [_myLends sortUsingComparator:^NSComparisonResult(LendInteraction* obj1, LendInteraction* obj2) {
            return obj1 .status<obj2.status;
        }];

    }
    return self;
}

#pragma mark - SINGLETON

static DataManager* _instance;

+(DataManager*) getInstance
{
    
    @synchronized(self)
    {
        if (!_instance)
        {
            DataManager *dm = [[DataManager alloc]init];
            _instance = dm;
        }
        return _instance;
    }
}
@end
