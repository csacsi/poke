//
//  Friend.h
//  poke
//
//  Created by Csomakk on 10/4/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "BaseDataObject.h"

@interface Friend : BaseDataObject

@property NSString *name;
@property UIImage *picture;
@property NSString* phoneNumber;
@property NSString* email;
@property (nonatomic,strong)NSString* objectId;

+ (id)name:(NSString *)name email:(NSString *)email;

@end
