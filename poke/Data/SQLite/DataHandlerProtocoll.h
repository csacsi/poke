//
//  DataLoaderProtocol.h
//  DummyProjectForFramework
//
//  Created by Wiesner Péter Ádám on 9/20/13.
//  Copyright (c) 2013 Wiesner Péter Ádám. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataRowProtocoll.h"

#import "DataHandlerDelegate.h"

@class BaseDataObject;

@protocol DataHandlerProtocoll <NSObject>

@required

/**
    Syncronous API
 */

/**
    saveObject: Saves the given object. The object's class must be subclass of BaseDataObject and should conform to DataRowProtocoll
    @param obj the object at hand
 */
//TODO: change to return BOOL for success, and outpout paramter ERROR
-(BOOL) saveObject:(BaseDataObject<DataRowProtocoll>*)obj error:(NSError**)error;

/**
    saveArray: Iterates through the array and calls saveObject to each element
    @param array the array of saveObject-compatible objects
 */
-(BOOL) saveArray:(NSArray*)array error:(NSError**)error;

/**
    findObjectsOfKind: Searches the [Classname] table at the [pageIndex]th page, where a page is [pageSize] big and returns the objects that comply with [query]
    @param klass The class type expected in return param. The name of the class will be the name of the table.
    @param query A condition from variation of AND,OR and comparison like objectId = '8kjUhiO09i'. For checking equality the '=' should be used. String must be between \'-s.
    @param pageIndex The index of the page. The first object's index is the pageIndex*pageSize, the last's is pageIndex*pageSize+pageSize-1.
    @param pageSize The size of the page requested
    @param orderBy A dictionary with the order by parameters. The keys of this dictionary is the columnames and the values are NSNUmber-wrapped boolean values. 1 == DESC order, 0 == ASC order. Optional parameter.
    Example:
        {
            "updatedAt" : @(1)
        }
    @return the matching Class-type objects
 */

-(NSArray*) findObjectsOfKind:(Class)klass forQuery:(NSString*)query pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize orderBy:(NSDictionary*)orderBy;

/**
     findObjectsOfKind: Returns all objects of the given class-type
     @param klass The class type expected in return param. The name of the class will be the name of the table.
     @return all Class-type objects
 */
-(NSArray*) findAllObjectOfKind:(Class)klass;


/**
    findObjectsOfKind:forQuery: Returns all objects of the given class-type by a query
    @param klass The class type expected in return param. The name of the class will be the name of the table.
    @param query A condition from variation of AND,OR and comparison like objectId = '8kjUhiO09i'. For checking equality the '=' should be used. String must be between \'-s.
    @return all Class-type objects
 */
-(NSArray*) findAllObjectOfKind:(Class)klass forQuery:(NSString*)query;


/**
     deleteObject: Delete an object from the table.
     @param obj The object to delete.
 */
-(BOOL) deleteObject:(BaseDataObject<DataRowProtocoll>*)obj error:(NSError**)error;

/**
     deleteArray: Delete whole array of objects.
     @param deleteArray the array of objects to delete, the items should be inherits from BaseDataObject<DataRowProtocoll>.
 */
-(BOOL) deleteArray:(NSArray*)array error:(NSError**)error;


/**
    Asyncronous API
 */

/**
    saveObjectInBackground:completionBlock: The async verison of saveObject: .
    @param obj see saveObject:
    @param completionBlock: This block will be called after the save processed
        @param succeeced Indicates whether the save really did happen
        @param error If there was an error, this stores it
 */
-(void) saveObjectInBackground:(BaseDataObject<DataRowProtocoll>*)obj completionBlock:(void(^)(BOOL succeeded, NSError* error))completionBlock;

/**
     saveArrayInBackground:completionBlock: The async verison of saveArray: .
     @param array see saveObject:
     @param completionBlock: This block will be called after the save processed
         @param succeeced Indicates whether the save really did happen
         @param error If there was an error, this stores it
 */

-(void) saveArrayInBackground:(NSArray*)array completionBlock:(void(^)(BOOL succeeded, NSError* error))completionBlock;

/**
      findObjectsInBackgroundOfKind:query:pageIndex:pageSize:completionBlock Async version of findObjectsOfKind. Please see description of all property (except completionBlock) at findObjects:query:pageIndex:pageSize
      @param completionBlock Called after the query is run
            @param objects the matching objects
            @param error if there was an erorr, this stores it
 */
-(void) findObjectsInBackgroundOfKind:(Class)klass forQuery:(NSString*)query pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize orderBy:(NSDictionary*)orderBy completionBlock:(void(^)(NSArray* objects, NSError* error))completionBlock;

/**
    findAllObjectInBackgroundOfKind:completionBlock: Async version of findAllObjectsOfKind: .
     @param completionBlock Called after the query is run
         @param objects the matching objects
         @param error if there was an erorr, this stores it
 */
-(void) findAllObjectInBackgroundOfKind:(Class)klass completionBlock:(void(^)(NSArray* objects, NSError* error))completionBlock;

/**
    deleteObjectInBackground:completionBlock: Async version of deleteObject:.
    @param obj The object to delete.
    @param completionBlock Called after the delete.
 */
-(void)deleteObjectInBackground:(BaseDataObject<DataRowProtocoll> *)obj completionBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock;

/**
    deleteArrayInBackground:completionBlock: Async version of deleteArray:.
    @param array The array of objects to delete, the items should be inherits from BaseDataObject<DataRowProtocoll>.
    @param completionBlock Called after the delete.
 */
-(void)deleteArrayInBackground:(NSArray *)array completionBlock:(void (^)(BOOL succeeded, NSError *error))completionBlock;

@optional
/**
    Helpers
 */

/**
     queryFromConstraints: Create a query with the given array of QueryConstraints
     @param arrayOfConstrains The list is constraints and condition to apply
     @return A query matching the current datahandler implementation
 */
-(id)queryFromConstraints:(NSArray*)arrayOfConstraints;

/** 
    delegate: This property is called, when a (currently just save) operation is finished. As this property is defined in the protocoll as optional, dont forget to synthetize in the implementation.
 */
@property (nonatomic, strong) id<DataHandlerDelegate> delegate;

@end
