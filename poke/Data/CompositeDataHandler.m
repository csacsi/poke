//
//  DataPipeHandler.m
//  Distinction.Common.ObjC
//
//  Created by Wiesner Péter Ádám on 9/25/13.
//  Copyright (c) 2013 Distinction Ltd. All rights reserved.
//

#import "CompositeDataHandler.h"

@interface CompositeDataHandler(){
    dispatch_queue_t _queue;    //Working queue for asyncronous operations
}

@end

@implementation CompositeDataHandler

-(id) init
{
    if (self  = [super init])
    {
        _sources = [NSMutableArray array];
        _targets = [NSMutableArray array];
    }
    
    return self;
}

#pragma mark - MANAGE SOURCE & TARGET
-(void) addSource:(id<DataHandlerProtocoll>)handler
{
    if (![handler conformsToProtocol:@protocol(DataHandlerProtocoll)])
        return;
    
    [_sources addObject:handler];
}

-(void) addTarget:(id<DataHandlerProtocoll>)handler
{
    if (![handler conformsToProtocol:@protocol(DataHandlerProtocoll)])
        return;
    
    [_targets addObject:handler];
}

-(id<DataHandlerProtocoll>)primarySourceDataHandler
{
    return nil;
}

-(id<DataHandlerProtocoll>)primaryTargetDataHandler
{
    return nil;
}


#pragma mark - SAVE
-(BOOL) saveObject:(BaseDataObject<DataRowProtocoll> *)obj error:(NSError **)error
{
    id<DataHandlerProtocoll> primary = [self primaryTargetDataHandler];
    
    if (primary)
    {
        return [primary saveObject:obj error:error];
    }
    else
    {
        for (id<DataHandlerProtocoll> handler in _targets) {
            if (![handler saveObject:obj error:error])
                return NO;
        }
    }
    
    return YES;
}

-(BOOL) saveArray:(NSArray *)array error:(NSError *__autoreleasing *)error
{
    id<DataHandlerProtocoll> primary = [self primaryTargetDataHandler];
    
    if (primary)
    {
        return [primary saveArray:array error:error];
    }
    else
    {
        for (id<DataHandlerProtocoll> handler in _targets) {
            if (![handler saveArray:array error:error])
                return NO;
        }
    }
    
    return YES;
}

#pragma mark - LOAD
-(NSArray*)findObjectsOfKind:(Class)klass forQuery:(NSString *)query pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize orderBy:(NSDictionary *)orderBy
{
    NSMutableArray* objects;
    id<DataHandlerProtocoll> primary = [self primarySourceDataHandler];
    
    if (primary)
    {
        objects = [[primary findObjectsOfKind:klass forQuery:query pageIndex:pageIndex pageSize:pageSize orderBy:orderBy] mutableCopy];
    }
    else
    {
        objects = [@[] mutableCopy];
        
        for (id<DataHandlerProtocoll> handler in _sources) {
            [objects addObjectsFromArray:[handler findObjectsOfKind:klass forQuery:query pageIndex:pageIndex pageSize:pageSize orderBy:orderBy]];
        }
    }
    
    NSError* error;
    [self saveArray:[self filterCachableObjects:objects] error:&error];
    
    return objects;
}

-(NSArray*) findAllObjectOfKind:(Class)klass forQuery:(NSString *)query
{
    NSMutableArray* objects;
    
    id<DataHandlerProtocoll> primary = [self primarySourceDataHandler];
    
    if (primary)
    {
        objects = [[primary findAllObjectOfKind:klass forQuery:query] mutableCopy];
    }
    else
    {
        objects = [@[] mutableCopy];
        
        for (id<DataHandlerProtocoll> handler in _sources) {
            [objects addObjectsFromArray:[handler findAllObjectOfKind:klass forQuery:query]];
        }
    }
    
    NSError* error;
    [self saveArray:[self filterCachableObjects:objects] error:&error];
    
    return objects;
}

-(NSArray*) findAllObjectOfKind:(Class)klass
{
    NSMutableArray* objects;
    
    id<DataHandlerProtocoll> primary = [self primarySourceDataHandler];
    
    if (primary)
    {
        objects = [[primary findAllObjectOfKind:klass] mutableCopy];
    }
    else
    {
        objects = [@[] mutableCopy];
        
        for (id<DataHandlerProtocoll> handler in _sources) {
            [objects addObjectsFromArray:[handler findAllObjectOfKind:klass]];
        }
    }
    
    NSError* error;
    [self saveArray:[self filterCachableObjects:objects] error:&error];
    
    return objects;
}

#pragma mark - DELETE
-(BOOL)deleteObject:(BaseDataObject<DataRowProtocoll> *)obj error:(NSError *__autoreleasing *)error
{
    id<DataHandlerProtocoll> primary = [self primarySourceDataHandler];
    
    if (primary)
    {
        return [primary deleteObject:obj error:error];
    }
    else
    {
        for (id<DataHandlerProtocoll> handler in _sources) {
            if (![handler deleteObject:obj error:error])
                return NO;
        }
    }
    
    return YES;
}

-(BOOL)deleteArray:(NSArray *)array error:(NSError *__autoreleasing *)error
{
    id<DataHandlerProtocoll> primary = [self primarySourceDataHandler];
    
    if (primary)
    {
        return [primary deleteArray:array error:error];
    }
    else
    {
        for (id<DataHandlerProtocoll> handler in _sources) {
            if (![handler deleteArray:array error:error])
                return NO;
        }
    }
    
    return YES;
}

-(NSArray*) filterCachableObjects:(NSArray*)array
{
    return array;
}
@end