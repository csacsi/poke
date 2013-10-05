//
//  Message.m
//  poke
//
//  Created by Csomakk on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "Message.h"

@implementation Message

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
