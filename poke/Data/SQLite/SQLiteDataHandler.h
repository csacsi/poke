//
//  OOSQLiteWrapper.h
//  DummyProjectForFramework
//
//  Created by Wiesner Péter Ádám on 9/19/13.
//  Copyright (c) 2013 Wiesner Péter Ádám. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataHandler.h"
/**
    This DataHandler handles the SQLite database.
 */

@interface SQLiteDataHandler : BaseDataHandler

/**
    initWithName: Inits the handler with a given name. This name is used to create the database.
 */
-(id) initWithName:(NSString*)name;

/**
    close Closes the database. Open is called from API operations.
 */
-(void) close;

@end
