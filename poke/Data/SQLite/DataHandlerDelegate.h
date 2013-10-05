//
//  DataHandlerDelegate.h
//  Distinction.Common.ObjC
//
//  Created by Péter Ádám Wiesner on 9/24/13.
//  Copyright (c) 2013 Distinction Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataRowProtocoll.h"

@class BaseDataObject;

@protocol DataHandlerDelegate <NSObject>

@optional
-(void) dataHandlerDidSaveObject:(BaseDataObject<DataRowProtocoll>*)obj;
-(void) dataHandlerDidSaveArray:(NSArray*) array;

-(void) dataHandlerFailedToSaveObject:(BaseDataObject<DataRowProtocoll>*)obj withError:(NSError*)err;
-(void) dataHandlerFailedToSaveArray:(NSArray*)array withError:(NSError*)err;

-(void) dataHandlerDidDeleteObject:(BaseDataObject<DataRowProtocoll>*)obj;
-(void) dataHandlerDidDeleteArray:(NSArray*) array;

-(void) dataHandlerFailedToDeleteObject:(BaseDataObject<DataRowProtocoll>*)obj withError:(NSError*)err;
-(void) dataHandlerFailedToDeleteArray:(NSArray*)array withError:(NSError*)err;

@end
