//
//  OOSQLiteWrapper.m
//  DummyProjectForFramework
//
//  Created by Wiesner Péter Ádám on 9/19/13.
//  Copyright (c) 2013 Wiesner Péter Ádám. All rights reserved.
//

#import "OOSQLiteWrapper.h"
#import <sqlite3.h>

#import "BaseDataObject.h"

#define OOSQLiteWrapperDomain @"OOSQLiteWrapper"

typedef NS_ENUM(NSUInteger, OOSQLiteWrapperError){
    OOSQLiteWrapperErrorNoDataBase,
    OOSQLiteWrapperErrorNoDataBaseName,
    OOSQLiteWrapperErrorCouldNotCreatedDataBase
};

@interface OOSQLiteWrapper(){
    NSMutableDictionary* _errorInfo;
    sqlite3 *_database;
    NSString* _dbname;
    BOOL _isDBOpen;
    
    NSDictionary* _typeMapping;
}

@end

@implementation OOSQLiteWrapper

-(id) init
{
    if (self = [super init])
    {
        _dbname = @"defaultDatabase";
        _isDBOpen = NO;
        
        _errorInfo = [@{} mutableCopy];
        
        [self createTypeStringMap];
    }
    
    return self;
}

-(id) initWithName:(NSString*)name
{
    if (self = [self init])
    {
        _dbname = name;
    }
    
    return self;
}

-(NSError*) open
{
    if (_dbname.length == 0)
        return [NSError errorWithDomain:OOSQLiteWrapperDomain code:OOSQLiteWrapperErrorNoDataBaseName userInfo:@{NSLocalizedDescriptionKey:@"OOSQLiteWrapperErrorNoDataBaseName"}];
    
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [[document stringByAppendingPathComponent:_dbname] stringByAppendingFormat:@".db"];
    
    if (sqlite3_open(path.UTF8String, &_database)) {
        return [NSError errorWithDomain:OOSQLiteWrapperDomain code:OOSQLiteWrapperErrorCouldNotCreatedDataBase userInfo:@{NSLocalizedDescriptionKey:@"OOSQLiteWrapperErrorCouldNotCreatedDataBase"}];
    }
    
    _isDBOpen = YES;
    
    return nil;
}

-(void) createDataBaseForObjectKind:(Class)klass
{
    NSDictionary* propertyInfo = [klass propertyList];
    
    char *errMsg;
    NSString *sql_stmt = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(",[NSStringFromClass(klass) uppercaseString]];
    
    NSMutableArray* paramComponents = [@[] mutableCopy];
    
    for (NSString* key in propertyInfo) {
        NSString* type = propertyInfo[key][0];
        
        [paramComponents addObject:[NSString stringWithFormat:@"%@ %@",[key uppercaseString],[_typeMapping[type] uppercaseString]]];
    }
    
    sql_stmt = [sql_stmt stringByAppendingString:[paramComponents componentsJoinedByString:@","]];
    
    sql_stmt =  [sql_stmt stringByAppendingString:@")"];
    
//    if (sqlite3_exec(_database, sql_stmt.UTF8String, NULL, NULL, &errMsg))
//    {
//        _errorInfo[[NSDate date]] = [NSError errorWithDomain:OOSQLiteWrapperDomain code:OOSQLiteWrapperErrorCouldNotCreatedDataBase userInfo:@{NSLocalizedDescriptionKey:@"OOSQLiteWrapperErrorCouldNotCreatedDataBase"}];
//    }
}

-(BOOL) tableExistsForObjectKind:(Class)klass
{
    if (klass == nil)
        return NO;
    
    if (_isDBOpen == NO)
        [self open];
    
    NSString* testQuery = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'",NSStringFromClass(klass)];
    
    sqlite3_stmt *statement;
    
    BOOL result = NO;
    
    if (sqlite3_prepare_v2(_database, testQuery.UTF8String, -1, &statement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            result = YES;
        }
        
        sqlite3_finalize(statement);
    }
    
    [self close];
    
    return result;
}

-(void) saveObject:(BaseDataObject*)obj
{
    BOOL tableExists = [self tableExistsForObjectKind:obj.class];
    
    if (!tableExists)
    {
        [self createDataBaseForObjectKind:obj.class];
    }
}

-(void) saveArray:(NSArray*)array
{
    
}

-(NSArray*) findObjectsOfKind:(Class)klass forQuery:(NSString*)query pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize
{
    return @[];
}

-(NSArray*) findAllObjectOfKind:(Class)klass
{
    return @[];
}

-(void) close
{
    sqlite3_close(_database);
    _isDBOpen = NO;
}

-(NSDictionary*) errorInfo
{
    return _errorInfo;
}

-(void)createTypeStringMap
{
    _typeMapping = @{
                     @"NSString" : @"TEXT",
                     @"NSNumber" : @"INTEGER",
                     @"int" : @"INTEGER",
                     @"NSDate" : @"DATETIME",
                     @"id"   : @"TEXT",
                     @"NSArray"   : @"TEXT",
                     @"NSMutableArray"   : @"TEXT",
                     @"NSDictionary"   : @"TEXT",
                     @"NSMutableDictionary"   : @"TEXT"
                     };
}
@end
