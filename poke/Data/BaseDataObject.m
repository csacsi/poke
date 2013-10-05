//
//  BaseDataObject.m
//  Distinction.Common.ObjC
//
//  Created by Wiesner Péter Ádám on 9/18/13.
//  Copyright (c) 2013 Distinction Ltd. All rights reserved.
//

#import "BaseDataObject.h"
#import <objc/runtime.h>

@implementation BaseDataObject

- (id)objectForKeyedSubscript:(id)key
{
    //Currently only NSString type keys are allowed
    //so if
    //    this is not the case OR
    //    there is no property defined with the name like the key
    //return to prevent errors.
    if (![key isKindOfClass:[NSString class]] || ![self respondsToSelector:NSSelectorFromString(key)])
        return nil;
    
    //Use the built in KVM
    return [self valueForKey:key];
}

- (void)setObject:(id)obj forKeyedSubscript:(id <NSCopying, NSObject>)key
{
    //Make the object nil tolerant, if the key is nil or the object is nil, then it wont be set
    if (key == nil || obj == nil || ![key isKindOfClass:[NSString class]])
        return;
    
    NSString* keyString = (NSString*)key;
    
    //The synthetized property setters looks like set+Capitalized first letter of property name+property name untouched from the 2. letter (first if array)
    keyString = [NSString stringWithFormat:@"set%@%@:",[[keyString substringWithRange:NSMakeRange(0, 1)] capitalizedString],[keyString substringFromIndex:1]];
    
    //Only complete operation if object synthetized the setter for property
    if ([self respondsToSelector:NSSelectorFromString((NSString*)keyString)])
        [self setValue:obj forKey:(NSString*)key];
}

-(NSDictionary*)objectAsDictionary
{
    NSArray* properties = [[self class] propertyList].allKeys;
    NSMutableDictionary* returnDict = [@{} mutableCopy];
    
    //For all properties queried from the class meta, get the value for each property and set to a dict. Notice that the dictionary is not nil-tolerant.
    for (NSString* property in properties) {
        id value = self[property];
        
        if (value)
            returnDict[property] = value;
    }
    
    return returnDict;
}

/**
    propertyList: Wrapper around the real property lister to write less
 */
+(NSDictionary*)propertyList
{
    return [BaseDataObject propertyListOfClass:[self class]];
}

/**
    propertyList: Collects the property names to a given class
    @param klass the target class
    @return A NSDictionary with the following structure:
        {
            propertyName : [
                type in string(if its recognisable),
                [,property attribute components],
                type in int (0 = object, 1 = primitive, 2 = MISC (class, selector))
            ]
        }
 */
+(NSDictionary*)propertyListOfClass:(Class)klass
{
    //Use reflection to get the property informations
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(klass, &outCount);
    NSMutableDictionary* propertyDictionary = [NSMutableDictionary dictionaryWithCapacity:outCount];
    
    for(i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];//get property struct
        const char *propName = property_getName(property);//the name
        const char *propAttributes = property_getAttributes(property);//the attribute
        NSString *propAttributesStr = [NSString stringWithUTF8String:propAttributes];//name as string
        NSString *propertyName = [NSString stringWithUTF8String:propName];//attribute as string
        
        int type;
        NSMutableArray* attrComponents = [[propAttributesStr componentsSeparatedByString:@","] mutableCopy];//separate attributecomponents
        attrComponents[0] = [BaseDataObject getTypeStringForFirstPropertyAttribute:attrComponents[0] type:&type];//determine type information
        [attrComponents addObject:@(type)];
        propertyDictionary[propertyName] = attrComponents;//set dictionary entry
    }
    
    free(properties);
    
    //If it is a subclass of BaseDataObject, continue with superclass
    if(klass != [BaseDataObject class])
    {
        NSDictionary* superObjectProperties = [BaseDataObject propertyListOfClass:klass.superclass];
        [propertyDictionary addEntriesFromDictionary:superObjectProperties];
    }
    
    return  propertyDictionary;
}

/**
    getTypeStringForFirstPropertyAttribute:type: collect property type information
    @param attr the attribute string like T@\"NSString\"
    @param out type will store the type as int
    @return type as string
 */

+(NSString*)getTypeStringForFirstPropertyAttribute:(NSString*)attr type:(out int*)type
{
    //Every attrbiute string should start with a T, if this is not the case return
    if (attr.length == 0 || ![[attr substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"T"]) {
        return nil;
    }
    
    //Continue with the rest of the string
    attr = [attr substringWithRange:NSMakeRange(1, attr.length-1)];
    
    NSArray* miscTypeEncodings = @[@"*", @"#", @":"];
    
    //Check the next letter and call the subtype checkers if needed
    //If its @, then its an object
    if ([[attr substringWithRange:NSMakeRange(0, 1)] isEqualToString:@"@"])
    {
        *type = 0;
        
        //If the string is only a @ char, then it is of type id
        if (attr.length == 1)
            return @"id";
        //Else extract the type name from it
        else
            return [BaseDataObject getObjectTypeStringFromString:[attr substringFromIndex:2]];
    }
    //If it is one of the thre special char *,#,:, then its MISC type
    else if ([miscTypeEncodings containsObject:[attr substringWithRange:NSMakeRange(0, 1)]])
    {
        *type = 2;
        return [BaseDataObject getMiscTypeStringFromString:[attr substringFromIndex:2]];
    }
    //Else its a primiteve like int, float
    else
    {
        *type = 1;
        return [BaseDataObject getPrimitiveTypeStringFromString:attr];
    }
}

/**
     getObjectTypeStringFromString: extracts the object type from the string like from \"NSString\"
     @param attr the string
     @return the extracted type as a string
 */
+(NSString*)getObjectTypeStringFromString:(NSString*)attr
{
    return [attr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
}

/**
     getPrimitiveTypeStringFromString: extracts the object type from the string like from "i"
     @param attr the string
     @return the extracted type as a string
 */
+(NSString*)getPrimitiveTypeStringFromString:(NSString*)attr
{
    NSString* c = [attr substringWithRange:NSMakeRange(0, 1)];
    
    NSArray* encodings = @[@"c",@"i",@"s",@"l",@"q",@"C",@"I",@"S",@"L",@"Q",@"f",@"d",@"B",@"v"];
    NSArray* types = @[@"char",@"int",@"short",@"long",@"long long",@"unsigned char",@"unsigned int",@"unsigned short",@"unsigned long",@"unsigned long long",@"float",@"double",@"_Bool",@"void"];
    
    //the match in the first array will index the result in the second one
    return types[[encodings indexOfObject:c]];
}

/**
     getMiscTypeStringFromString: extracts the object type from the string like from ":"
     @param attr the string
     @return the extracted type as a string
 */
+(NSString*)getMiscTypeStringFromString:(NSString*)attr
{
    NSString* c = [attr substringWithRange:NSMakeRange(0, 1)];
    
    if ([c isEqualToString:@"*"])
        return @"char *";
    else if ([c isEqualToString:@"#"])
        return @"Class";
    else
        return @"SEL";
}


@end
