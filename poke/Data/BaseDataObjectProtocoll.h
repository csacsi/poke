//
//  BaseDataObjectProtocoll.h
//  Distinction.Common.ObjC
//
//  Created by Wiesner Péter Ádám on 9/26/13.
//  Copyright (c) 2013 Distinction Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseDataObjectProtocoll <NSObject>

/**
 objectForKeyedSubscript: Built in solution enhance and object with directory keying ability
 @param key the property name
 @return the property value wrapped in an object
 
 @usage NSString* name = person[@"name"];
 */
- (id)objectForKeyedSubscript:(id)key;

/**
 setObject: forKeyedSubscript: Built in solution enhance and object with directory keying ability
 @param obj the object to store
 @param key the property name
 
 @usage person[@"name"] = @"Distinction";
 */
- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying>)key;

/**
 objectAsDictionary: Create an NSDictionary from the object
 */
-(NSDictionary*)objectAsDictionary;

+(NSDictionary*)propertyList;
@end
