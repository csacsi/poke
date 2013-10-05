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

@interface ParseDataHandler()
{
    dispatch_queue_t _queue;    //Working queue for asyncronous operations
}

@end

@implementation ParseDataHandler
-(id)init
{
    if (self = [super init]){
        
        _queue = dispatch_queue_create("com.distinction.datalayer.parse", NULL);
    }
    
    return self;
}

#pragma mark LOADING
-(PFQuery*)makePFQueryOfKind:(Class)klass forQuery:(NSString*)query withPageIndex:(NSUInteger)pageIndex andPageSize:(NSUInteger)pageSize orderBy:(NSDictionary *)orderBy
{
    PFQuery*q = nil;
    //If we have query, make the predicate of it
    if (query)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:query];
        q = [PFQuery queryWithClassName:NSStringFromClass(klass) predicate:predicate];
    }
    else{
        q = [PFQuery queryWithClassName:NSStringFromClass(klass)];
    }

    if (orderBy){
        
        for (NSString* column in orderBy) {
            BOOL descendingByColumn = [orderBy[column] boolValue];
            
            if (descendingByColumn)
            {
                [q orderByDescending:column];
            }
            else{
                
                [q orderByAscending:column];
            }
        }
    }
    
    //We need to skip the first x element
    q.skip = pageIndex*pageSize;
    q.limit = pageSize;
    
    return q;
}

-(NSArray*) findObjectsOfKind:(Class)klass forQuery:(NSString*)query pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize orderBy:(NSDictionary *)orderBy
{
    PFQuery*q = [self makePFQueryOfKind:klass forQuery:query withPageIndex:pageIndex andPageSize:pageSize orderBy:orderBy];

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
       
    }
    
    return retValue;

}

-(NSArray*) findAllObjectOfKind:(Class)klass forQuery:(NSString*)query
{
    int skip = 0;
    int pageSize = 100;
    
    NSArray* objects;
    NSMutableArray* retValue = [[NSMutableArray alloc]init];
    
    //We are searching for the elements by 100, if we got less than 100 then we have got all of it
    do {
        objects = [self findObjectsOfKind:klass forQuery:query pageIndex:skip pageSize:pageSize orderBy:nil];
        
        [retValue addObjectsFromArray:objects];
        
        skip ++;
        
    } while (objects.count >= pageSize);
    
    return retValue;
}

-(void)findObjectsInBackgroundOfKind:(Class)klass forQuery:(NSString *)query pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize completionBlock:(void (^)(NSArray *, NSError *))completionBlock
{
    PFQuery*q = [self makePFQueryOfKind:klass forQuery:query withPageIndex:pageIndex andPageSize:pageSize orderBy:nil];
    
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        NSMutableArray*retValue = [@[]mutableCopy];
        
        if (!error) {
            for (PFObject* pfObj in objects)
            {
                [retValue addObject:[ParseObjectHelper objectFrom:pfObj]];
            }
        }
        
        completionBlock(retValue,error);
        
    }];
}

#pragma mark SAVING
-(BOOL) saveObject:(BaseDataObject<DataRowProtocoll>*)obj error:(NSError *__autoreleasing *)error
{
    return [self saveArray:@[obj] error:error];
}

-(BOOL) saveArray:(NSArray*)array error:(NSError *__autoreleasing *)error
{
    NSArray * saveArray = [self convertObjectsToPFObjectFromArray:array];
    
    NSError* err;
    BOOL succeeded = [PFObject saveAll:saveArray error:&err];
    
    if (!err)
    {
        //If the save is succes then we need to set the objectIds to the baseobjects.
        if (succeeded)
        {
            int i = 0;
            for (PFObject*pfObj in saveArray){
                BaseDataObject<DataRowProtocoll>* obj =(BaseDataObject<DataRowProtocoll>*) [array objectAtIndex:i];
                [obj setRowId:pfObj.objectId];
                i++;
            }
        }
    }
    else{
        *error = err;
    }
    
    return succeeded;
}

-(void) saveObjectInBackground:(BaseDataObject<DataRowProtocoll>*)obj completionBlock:(void(^)(BOOL succeeded, NSError* error))completionBlock
{
    [self saveArrayInBackground:@[obj] completionBlock:^(BOOL succeeded, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (succeeded)
//            {
//                [self.delegate dataHandlerDidSaveObject:obj];
//            }
//            else
//            {
//                [self.delegate dataHandlerFailedToSaveObject:obj withError:error];
//            }
            
        });
        completionBlock(succeeded,error);
    }];
}


-(void)saveArrayInBackground:(NSArray *)array completionBlock:(void (^)(BOOL succeeded, NSError* error))completionBlock
{
    NSArray * saveArray = [self convertObjectsToPFObjectFromArray:array];
    [PFObject saveAllInBackground:saveArray block:^(BOOL succeeded, NSError *error) {

        //If the save is succes then we need to set the objectIds to the baseobjects.
        if (succeeded)
        {
            int i = 0;
            for (PFObject*pfObj in saveArray){
                BaseDataObject<DataRowProtocoll>* obj =(BaseDataObject<DataRowProtocoll>*) [array objectAtIndex:i];
                [obj setRowId:pfObj.objectId];
                i++;
            }
        }
        
         dispatch_async(dispatch_get_main_queue(), ^{
//             if (!error && succeeded)
//             {
//                 [self.delegate dataHandlerDidSaveArray:array];
//             }
//             else
//             {
//                 [self.delegate dataHandlerFailedToSaveArray:array withError:error];
//             }
             
         });
         
        completionBlock(succeeded,error);

    }];
}

-(NSArray*)convertObjectsToPFObjectFromArray:(NSArray*)array
{
    NSMutableArray* newArray = [@[]mutableCopy];
    
    for (id obj in array) {
        if([obj isKindOfClass:[BaseDataObject class]])
        {
            [newArray addObject:[ParseObjectHelper parseObjectFrom:obj]];
        }
        else
        {
            
            return nil;
        }
    }
    
    return newArray;
}

#pragma mark DELETE
-(BOOL)deleteObject:(BaseDataObject<DataRowProtocoll>*)obj error:(NSError *__autoreleasing *)error
{
    return [self deleteArray:@[obj] error:error];
}

-(BOOL)deleteArray:(NSArray*)array error:(NSError *__autoreleasing *)error
{
    NSArray * deleteArray = [self convertObjectsToPFObjectFromArray:array];
    
    NSError*err;
    BOOL succeeded = [PFObject deleteAll:deleteArray error:&err];
    
    //If the delete is succes then we need to set the objectIds to the baseobjects.
    if (succeeded) {
        for (BaseDataObject<DataRowProtocoll>*obj in array){
            [obj setRowId:nil];
        }
    }
    
    if (err)
        *error = err;
    
    return succeeded;
}

-(void)deleteObjectInBackground:(BaseDataObject<DataRowProtocoll> *)obj completionBlock:(void (^)(BOOL succeeded, NSError* error))completionBlock
{
    [self deleteArrayInBackground:@[obj] completionBlock:completionBlock];
}

-(void)deleteArrayInBackground:(NSArray *)array completionBlock:(void (^)(BOOL succeeded, NSError* error))completionBlock
{
    NSArray * saveArray = [self convertObjectsToPFObjectFromArray:array];
    
    [PFObject deleteAllInBackground:saveArray block:^(BOOL succeeded, NSError *error) {
        
        //If the delete is succes then we need to set the objectIds to the baseobjects.
        if (succeeded) {
            for (BaseDataObject<DataRowProtocoll>*obj in array){
                [obj setRowId:nil];
            }
        }
        
        completionBlock(succeeded,error);
        
    }];
}
@end
