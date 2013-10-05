//
//  LendInteraction.h
//  poke
//
//  Created by Csomakk on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "BaseDataObject.h"
#import "Friend.h"
#import <Parse/Parse.h>
typedef enum {
    lendCategoryBook,
    lendCategoryCash,
    lendCategoryClothes,
    lendCategoryOther
} lendInteractionCateoryType;

@interface LendInteraction : BaseDataObject

@property lendInteractionCateoryType categoryType;
@property Friend *friend;
@property NSString *name;
@property NSNumber *amount;
@property UIImage *photo;
@property double status;

@property BOOL isBorrow;
@property NSDate *end_date;
@property (nonatomic,strong)NSString* objectId;
@property PFUser* user;
-(BOOL) isLend;



@end
