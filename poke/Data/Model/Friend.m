//
//  Friend.m
//  poke
//
//  Created by Csomakk on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "Friend.h"

@implementation Friend

@synthesize name;
@synthesize email;


-(void) setRowId:(id<NSCopying>)rowId
{
    self.objectId = (NSString*)rowId;
}

-(id<NSCopying>)getRowId
{
    return self.objectId;
}


+ (id)name:(NSString *)name email:(NSString *)email picture:(UIImage *)picture
{
    Friend *newFriend = [[self alloc] init];
    newFriend.email = email;
    newFriend.name = name;
    newFriend.picture = picture;
    return newFriend;
}

+(NSString*) getRowIdName
{
    return @"objectId";
}
@end
