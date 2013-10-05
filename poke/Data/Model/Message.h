//
//  Message.h
//  poke
//
//  Created by Csomakk on 10/5/13.
//  Copyright (c) 2013 Distinction. All rights reserved.
//

#import "BaseDataObject.h"
#import "DataRowProtocoll.h"

@interface Message : BaseDataObject<DataRowProtocoll>

@property (nonatomic,strong)NSString* objectId;
@property BOOL cancelled;
@property NSDate *date;
@property BOOL isSMS;
@property BOOL sent;
@property NSString *text;
@property NSString *to;
@property NSNumber *userid;


@end
