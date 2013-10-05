//
//  QueryConstrains.h
//  DummyProjectForFramework
//
//  Created by Péter Ádám Wiesner on 9/23/13.
//  Copyright (c) 2013 Wiesner Péter Ádám. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, QueryConstraintType)
{
    QueryConstraintTypeTypeIsEqual,
    QueryConstraintTypeGreatherThan,
    QueryConstraintTypeLessThan
};

@interface QueryConstrains : NSObject

@property (nonatomic, strong) NSString* columnName;
@property (nonatomic) QueryConstraintType constraintType;
@property (nonatomic) id value;

@end
