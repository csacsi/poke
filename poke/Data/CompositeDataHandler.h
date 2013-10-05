//
//  DataPipeHandler.h
//  Distinction.Common.ObjC
//
//  Created by Wiesner Péter Ádám on 9/25/13.
//  Copyright (c) 2013 Distinction Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseDataHandler.h"

@interface CompositeDataHandler : BaseDataHandler{
    NSMutableArray* _sources;
    NSMutableArray* _targets;
}

-(void)addSource:(id<DataHandlerProtocoll>)handler;
-(void)addTarget:(id<DataHandlerProtocoll>)handler;

//Overridable caching behaviour (primary and secondary) source,target handling
-(id<DataHandlerProtocoll>)primarySourceDataHandler;
-(id<DataHandlerProtocoll>)primaryTargetDataHandler;

-(NSArray*) filterCachableObjects:(NSArray*)array;

@end
