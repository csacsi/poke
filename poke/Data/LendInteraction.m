//
//  LendInteraction.m
//  poke
//
//  Created by Csomakk on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "LendInteraction.h"

@implementation LendInteraction

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

-(BOOL) isLend
{
    return !_isBorrow;
}

@end
