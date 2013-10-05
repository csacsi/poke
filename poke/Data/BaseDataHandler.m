//
//  BaseDataHandler.m
//  Distinction.Common.ObjC
//
//  Created by Wiesner Péter Ádám on 9/26/13.
//  Copyright (c) 2013 Distinction Ltd. All rights reserved.
//

#import "BaseDataHandler.h"

@interface BaseDataHandler(){
    dispatch_queue_t _queue;    //Working queue for asyncronous operations
}

@end

@implementation BaseDataHandler

-(id) init
{
    if (self  = [super init])
    {
        _queue = dispatch_queue_create("com.distinction.datalayer.sqlite", NULL);
    }
    
    return self;
}

#pragma mark - SAVE
-(BOOL) saveObject:(BaseDataObject<DataRowProtocoll> *)obj error:(NSError *__autoreleasing *)error
{
//    @throw [NSException exceptionWithName:@"NotImplementedException" reason:nil userInfo:@{@"Class":NSStringFromClass(self.class)}];
    return NO;
}

//TODO: Error handling
-(void) saveObjectInBackground:(BaseDataObject<DataRowProtocoll> *)obj completionBlock:(void (^)(BOOL, NSError *))completionBlock
{
    dispatch_async(_queue, ^{
        
        NSError* error;
        BOOL succeded = [self saveObject:obj error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error)
                [self.delegate dataHandlerDidSaveObject:obj];
            else
                [self.delegate dataHandlerFailedToSaveObject:obj withError:error];
            
            completionBlock(succeded, error);
        });
    });
    
}

-(BOOL) saveArray:(NSArray *)array error:(NSError *__autoreleasing *)error
{
//    @throw [[NSException exceptionWithName:@"NotImplementedException" reason:nil userInfo:@{@"Class":NSStringFromClass(self.class)}];
    return NO;
}

//TODO: Error handling
-(void) saveArrayInBackground:(NSArray *)array completionBlock:(void (^)(BOOL succeded, NSError *error))completionBlock
{
    dispatch_async(_queue, ^{
        
        NSError* error;
        BOOL succeded = [self saveArray:array error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error)
                [self.delegate dataHandlerDidSaveArray:array];
            else
                [self.delegate dataHandlerFailedToSaveArray:array withError:error];
            
            completionBlock(succeded, error);
        });
    });
}

#pragma mark - LOAD
-(NSArray*) findObjectsOfKind:(Class)klass forQuery:(NSString *)query pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize orderBy:(NSDictionary *)orderBy
{
//    @throw [NSException exceptionWithName:@"NotImplementedException" reason:nil userInfo:@{@"Class":NSStringFromClass(self.class)}];
    return nil;
}

-(void) findObjectsInBackgroundOfKind:(Class)klass forQuery:(NSString *)query pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize orderBy:(NSDictionary*)orderBy completionBlock:(void (^)(NSArray * objects, NSError *error))completionBlock
{
    dispatch_async(_queue, ^{
        NSArray* objects = [self findObjectsOfKind:klass forQuery:query pageIndex:pageIndex pageSize:pageSize orderBy:orderBy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(objects,nil);
        });
    });
}

-(NSArray*) findAllObjectOfKind:(Class)klass forQuery:(NSString *)query
{
//    @throw [NSException exceptionWithName:@"NotImplementedException" reason:nil userInfo:@{@"Class":NSStringFromClass(self.class)}];
    return nil;
}

-(NSArray*) findAllObjectOfKind:(Class)klass
{
    return [self findAllObjectOfKind:klass forQuery:nil];
}

-(void) findAllObjectInBackgroundOfKind:(Class)klass completionBlock:(void (^)(NSArray * objects, NSError * error))completionBlock
{
    dispatch_async(_queue, ^{
        
        NSArray* objects = [self findAllObjectOfKind:klass];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(objects,nil);
        });
    });
}

#pragma mark - DELETE
-(BOOL) deleteObject:(BaseDataObject<DataRowProtocoll> *)obj error:(NSError *__autoreleasing *)error
{
//    @throw [NSException exceptionWithName:@"NotImplementedException" reason:nil userInfo:@{@"Class":NSStringFromClass(self.class)}];
    return NO;
}

-(void) deleteObjectInBackground:(BaseDataObject<DataRowProtocoll> *)obj completionBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    dispatch_async(_queue, ^{
        
        NSError* error;
        BOOL succeded = [self deleteObject:obj error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error)
                [self.delegate dataHandlerDidDeleteObject:obj];
            else
                [self.delegate dataHandlerFailedToDeleteObject:obj withError:error];
            
            completionBlock(succeded, error);
        });
    });
}

-(BOOL) deleteArray:(NSArray *)array error:(NSError *__autoreleasing *)error
{
//    @throw [NSException exceptionWithName:@"NotImplementedException" reason:nil userInfo:@{@"Class":NSStringFromClass(self.class)}];
    return NO;
}

-(void) deleteArrayInBackground:(NSArray *)array completionBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock
{
    dispatch_async(_queue, ^{
        
        NSError* error;
        BOOL succeded = [self deleteArray:array error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error)
            {
                [self.delegate dataHandlerDidDeleteArray:array];
            }
            else
            {
                [self.delegate dataHandlerFailedToDeleteArray:array withError:error];
            }
            
            completionBlock(succeded, error);
        });
    });
}
@end
