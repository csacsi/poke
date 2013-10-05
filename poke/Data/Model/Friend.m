//
//  Friend.m
//  poke
//
//  Created by Csomakk on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "Friend.h"

@implementation Friend

-(void) setRowId:(id<NSCopying>)rowId
{
    self.objectId = (NSString*)rowId;
}

-(id<NSCopying>)getRowId
{
    return self.objectId;
}

+(NSString*) getRowIdName
{
    return @"objectId";
}
@end
