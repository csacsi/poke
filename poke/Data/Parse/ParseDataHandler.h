//
//  ParseDataHandler.h
//  Distinction.Common.ObjC
//
//  Created by Toth Csaba on 9/23/13.
//  Copyright (c) 2013 Distinction Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataLoaderProtocol.h"


@interface ParseDataHandler : NSObject<DataLoaderProtocol>
{
    NSMutableDictionary* errorsDictionary;
}


@end
