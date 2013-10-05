//
//  DataIdentificationProtocoll.h
//  DummyProjectForFramework
//
//  Created by Wiesner Péter Ádám on 9/23/13.
//  Copyright (c) 2013 Wiesner Péter Ádám. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    This protocoll declares an interface, that helps other classes to access that property of the implementing class, what identifactes the given object.
 */

@protocol DataRowProtocoll <NSObject>

@required
/**
    setRowId: Sets the ID property
    @param rowId the new value. Currently every ID is an NSString, but the protocoll declaration let every object, that can be a key in a dictionary.
 */
-(void) setRowId:(id<NSCopying>)rowId;

/**
    getRowId: Gets the ID property value
    @return the ID value
 */
-(id<NSCopying>) getRowId;

/**
    getRowIdName: Get th name of the ID property as a string
    @return name of the ID proeprty
 */
+(NSString*) getRowIdName;
@end