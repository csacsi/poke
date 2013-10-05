//
//  Profile.h
//  poke
//
//  Created by Csomakk on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "BaseDataObject.h"

@interface Profile : BaseDataObject

@property NSInteger id;
@property NSNumber *defaultDuration;
@property (nonatomic,strong)NSString* objectId;

@end
