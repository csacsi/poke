//
//  ParseObjectHelper.m
//  DummyProjectForFramework
//
//  Created by Wiesner Péter Ádám on 9/20/13.
//  Copyright (c) 2013 Wiesner Péter Ádám. All rights reserved.
//

#import "ParseObjectHelper.h"

#import <Parse/Parse.h>
#import "BaseDataObject.h"
#import "CustomMappingProtocoll.h"

@implementation ParseObjectHelper

+(PFObject*) parseObjectFrom:(BaseDataObject*)obj
{
    //Create base PFObject
    PFObject *object = [PFObject objectWithClassName:NSStringFromClass([obj class])];
    
    if ([obj.class conformsToProtocol:@protocol(CustomMappingProtocoll)])
    {
        object = [obj.class parseObjectFrom:obj];
        return object;
    }
    
    unsigned int  i;
    
    //Get properties of tis class
    NSDictionary *properties = [[obj class] propertyList];
    
    for(i = 0; i < properties.count; i++) {
        
        NSString *propName = properties.allKeys[i];
        NSArray *propAttributesComponents = properties.allValues[i];
        
        //Only process property if it is not readonly
        if(propName && ![propAttributesComponents containsObject:@"R"])
        {
            NSString *propertyName = propName;
            id value = [obj valueForKey:propertyName];
            
            value = [self parseValueFromElement:value]; //will recursievely process value
            
            //Give ability to present nullifying
            if (!value)
                value = [NSNull null];
            
            //this string should be replaced with the persistence protocoll call alter
            if (![propName isEqualToString:@"objectId"])
                [object setValue:value forKey:propertyName];
        }
    }
    
    return object;
}

/**
    parseValueFromElement: Convert a value to parseObject
    @param obj the value to convert
    @return The converted array or the param if no conversation needed
 */
+(id) parseValueFromElement:(id)obj
{
    id parseValue = obj;
    
    if ([obj isKindOfClass:[BaseDataObject class]])//Nested object, recursively convert
    {
        parseValue = [self parseObjectFrom:(BaseDataObject*)obj];
    }
    else if([obj isKindOfClass:[NSArray class]])//Its an array, convert each element
    {
        NSMutableArray* valueNew = [[NSMutableArray alloc] init];
        for (NSObject* item in (NSArray*)obj)
        {
            id valueOfObj = [self parseValueFromElement:item];
            
            if (valueOfObj)
                [valueNew addObject:valueOfObj];
        }
        
        parseValue = valueNew;
    }
    else if ([obj isKindOfClass:[NSDictionary class]])//Its a dictionary, convert each entry
    {
        NSMutableDictionary* valueNew = [[NSMutableDictionary alloc] init];
        
        for (NSString* key in [(NSDictionary*)obj allKeys])
        {
            id valueForKey = [(NSDictionary*)obj objectForKey:key];
            id valueOfObj = [self parseValueFromElement:valueForKey];
            
            if (valueOfObj)
                valueNew[key] = valueOfObj;
        }
        
        parseValue = valueNew;
    }
    
    return parseValue;
}

+(BaseDataObject*) objectFrom:(PFObject*)object
{
    Class klass = NSClassFromString(object.parseClassName);
    if(!klass) {
        
        NSLog(@"No class found matching:%@", object.parseClassName);
        return nil;
    }
    
    //Create base object
    id objcObject = [[klass alloc] init];
    
    if ([klass conformsToProtocol:@protocol(CustomMappingProtocoll)])
    {
        objcObject = [klass objectFrom:object];
    }
    
    //Get property list
    NSDictionary* propertyDict = [[klass propertyList] mutableCopy];
    
    for (NSString* key in propertyDict.allKeys) {
        
        id value = [object valueForKey:key];
        
        objcObject[key] = [self elementFromParseValue:value];//Recursively convert pfObject
    }
    
    return objcObject;
}

/**
     parseValueFromElement: Convert a value of a pfObject to value of a datamodel
     @param obj the value to convert
     @return The converted array or the param if no conversation needed
 */
+(id)elementFromParseValue:(id)obj
{
    id element = obj;
    
    if ([obj isKindOfClass:[PFObject class]])//Nested PFObject, recursive call 
    {
        element = [self objectFrom:(PFObject*)obj];
    }
    if([obj isKindOfClass:[NSArray class]])//Its an array, convert each element
    {
        NSMutableArray* newValues = [@[] mutableCopy];
        for (id valueInArray in obj) {
            [newValues addObject:[self elementFromParseValue:valueInArray]];
        }
        
        element = newValues;
    }
    else if ([obj isKindOfClass:[NSDictionary class]])//Its a dictionary, convert each entry
    {
        NSMutableDictionary* newValues = [@{} mutableCopy];
        for (id keyInDict in [obj allKeys]) {
            
            id valueInDict = [obj objectForKey:keyInDict];
            newValues[keyInDict] = [self elementFromParseValue:valueInDict];
            
        }
        
        element = newValues;
    }
    
    return element;
}
@end
