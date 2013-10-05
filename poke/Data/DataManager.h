//
//  DataManager.h
//  poke
//
//  Created by Toth Csaba on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property(nonatomic,strong)NSMutableArray*myFriends;
@property(nonatomic,strong)NSMutableArray*myLends;

#pragma mark Singleton
+(DataManager*) getInstance;



@end
