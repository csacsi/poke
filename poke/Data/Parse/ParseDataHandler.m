//
//  ParseDataHandler.m
//  Distinction.Common.ObjC
//
//  Created by Toth Csaba on 9/23/13.
//  Copyright (c) 2013 Distinction Ltd. All rights reserved.
//

#import "ParseDataHandler.h"
#import "ParseObjectHelper.h"
#import <Parse/Parse.h>
#import "BaseDataObject.h"

@implementation ParseDataHandler
-(id)init
{
    if (self = [super init]){
        errorsDictionary = [@{}mutableCopy];
    }
    
    return self;
}


#pragma mark LOADING

-(NSArray*) findObjectsOfKind:(Class)klass forQuery:(NSString*)query pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize
{
    PFQuery*q = nil;
    //If we have query, make the predicate of it
    if (query)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:query];
        q = [PFQuery queryWithClassName:NSStringFromClass([klass class]) predicate:predicate];
    }
    q = [PFQuery queryWithClassName:NSStringFromClass([klass class])];

    //We need to skip the first x element
    q.skip = pageIndex*pageSize;
    q.limit = pageSize;
    
    NSError* err;
    NSArray* objects;
    NSMutableArray* retValue = [[NSMutableArray alloc]init];
    
    err = nil;
    objects = [q findObjects:&err];
    if (!err) {
        for (PFObject* pfObj in objects)
        {
            [retValue addObject:[ParseObjectHelper objectFrom:pfObj]];
        }
    }
    else{
        //Just adding the error by date
        [errorsDictionary setObject:err forKey:[NSDate date]];
    }
    
    return retValue;

}

-(NSArray*) findAllObjectOfKind:(Class)klass
{
    int skip = 0;
    int pageSize = 100;
    
    NSArray* objects;
    NSMutableArray* retValue = [[NSMutableArray alloc]init];

    //We are searching for the elements by 100, if we got less than 100 then we have got all of it
    do {
        objects = [self findObjectsOfKind:klass forQuery:nil pageIndex:skip pageSize:pageSize];
        
        [retValue addObjectsFromArray:objects];
        
    } while (objects.count >= pageSize);

  return retValue;
}


#pragma mark SAVING
-(void) saveObject:(BaseDataObject<DataRowProtocoll>*)obj
{
    [self saveArray:@[obj]];
}

-(void) saveArray:(NSArray*)array
{
    NSMutableArray * saveArray = [@[]mutableCopy];
    
    //First need to make the PFObjects from the BaseDataObjects
    for (id obj in array) {
        if([obj isKindOfClass:[BaseDataObject class]])
        {
            [saveArray addObject:[ParseObjectHelper parseObjectFrom:obj]];
        }
        else
        {
            [errorsDictionary setObject:@"Can't save, not BaseDataObject objects" forKey:[NSDate date]];
            return;
        }
    }
    
    NSError* err;
    BOOL succeeded = [PFObject saveAll:saveArray error:&err];
    
    
    if (err) {
        [errorsDictionary setObject:err forKey:[NSDate date]];
    }
    
    
    //If the save is succes then we need to set the objectIds to the baseobjects.
    if (succeeded)
    {
        int i = 0;
        for (PFObject*pfObj in saveArray){
            BaseDataObject<DataRowProtocoll>* obj =(BaseDataObject<DataRowProtocoll>*) [array objectAtIndex:i];
            [obj setObjectId:pfObj.objectId];
            i++;
        }
    }
}

#pragma mark DELETE
-(void)deleteObject:(BaseDataObject<DataRowProtocoll>*)obj
{
    [self deleteArray:@[obj]];
}

-(void)deleteArray:(NSArray*)array
{
    NSMutableArray * deleteArray = [@[]mutableCopy];
    
    for (id obj in array) {
        if([obj isKindOfClass:[BaseDataObject class]])
        {
            [deleteArray addObject:[ParseObjectHelper parseObjectFrom:obj]];
        }
        else
        {
            [errorsDictionary setObject:@"Can't delete, not BaseDataObject objects" forKey:[NSDate date]];
            return;
        }
    }
    
    NSError*err;
    BOOL succeeded = [PFObject deleteAll:deleteArray error:&err];
    
    if (err) {
        [errorsDictionary setObject:err forKey:[NSDate date]];
    }

    
    //If the delete is succes then we need to set the objectIds to the baseobjects.
    if (succeeded) {
        for (BaseDataObject<DataRowProtocoll>*obj in array){
            [obj setObjectId:nil];
        }
    }
}


-(NSDictionary*) errorInfo
{
    return errorsDictionary;
}


@end
