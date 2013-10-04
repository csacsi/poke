//
//  LendInteraction.m
//  poke
//
//  Created by Csomakk on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "LendInteraction.h"

@implementation LendInteraction

-(BOOL) isLend
{
    return !_isBorrow;
}

@end
