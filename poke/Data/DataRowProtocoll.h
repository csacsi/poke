//
//  DataIdentificationProtocoll.h
//  DummyProjectForFramework
//
//  Created by Wiesner Péter Ádám on 9/23/13.
//  Copyright (c) 2013 Wiesner Péter Ádám. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DataRowProtocoll <NSObject>

@required
-(void) setRowId:(id<NSCopying>)rowId;
-(id<NSCopying>) getRowId;
+(NSString*) getRowIdName;

-(void)setObjectId:(NSString*)oId;
-(NSString*)objectId;

@end