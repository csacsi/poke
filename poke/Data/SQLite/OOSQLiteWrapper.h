//
//  OOSQLiteWrapper.h
//  DummyProjectForFramework
//
//  Created by Wiesner Péter Ádám on 9/19/13.
//  Copyright (c) 2013 Wiesner Péter Ádám. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataLoaderProtocol.h"

@class BaseDataObject;

@interface OOSQLiteWrapper : NSObject <DataLoaderProtocol>

-(id) initWithName:(NSString*)name;
-(void) close;

@end
