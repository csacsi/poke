//
//  DataLoaderProtocol.h
//  DummyProjectForFramework
//
//  Created by Wiesner Péter Ádám on 9/20/13.
//  Copyright (c) 2013 Wiesner Péter Ádám. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataRowProtocoll.h"

@class BaseDataObject;

@protocol DataLoaderProtocol <NSObject>

//Synchronous API
-(void) saveObject:(BaseDataObject<DataRowProtocoll>*)obj;
-(void) saveArray:(NSArray*)array;
-(NSArray*) findObjectsOfKind:(Class)klass forQuery:(NSString*)query pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize;
-(NSArray*) findAllObjectOfKind:(Class)klass;

-(void)deleteObject:(BaseDataObject*)obj;
-(void)deleteArray:(NSArray*)array;

-(NSDictionary*) errorInfo;

@end
