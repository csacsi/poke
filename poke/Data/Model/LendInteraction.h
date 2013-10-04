//
//  LendInteraction.h
//  poke
//
//  Created by Csomakk on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "BaseDataObject.h"
#import "Friend.h"

@interface LendInteraction : BaseDataObject

@property NSInteger id;
@property NSInteger category_group_id;
@property NSString *description;
@property NSNumber *amount;
@property NSObject *photo;
@property NSInteger status;
@property Friend *friend;
@property BOOL isBorrow;
@property NSDate *end_date;

-(BOOL) isLend;



@end
