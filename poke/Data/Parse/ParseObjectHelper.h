//
//  ParseObjectHelper.h
//  DummyProjectForFramework
//
//  Created by Wiesner Péter Ádám on 9/20/13.
//  Copyright (c) 2013 Wiesner Péter Ádám. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
    Helper to handle application model <-> PFObject conversations
 */

@class PFObject;
@class BaseDataObject;

@interface ParseObjectHelper : NSObject

/**
    parseObjectFrom: Creates PFObject from a given BaseDataObject
    @param object a BaseDataObject
    @return the PFObject
 */
+(PFObject*) parseObjectFrom:(BaseDataObject*)object;

/**
     objectFrom: Creates BaseDataObject from a given PFObject
     @param object a PFObject
     @return the BaseDataObject
 */
+(BaseDataObject*) objectFrom:(PFObject*)object;
@end
