//
//  OOSQLiteWrapper.m
//  DummyProjectForFramework
//
//  Created by Wiesner Péter Ádám on 9/19/13.
//  Copyright (c) 2013 Wiesner Péter Ádám. All rights reserved.
//

#import "SQLiteDataHandler.h"
#import <sqlite3.h>

#import "BaseDataObject.h"


/**
    Enumeration for error handling. SQLite returns interger errorCodes, this can be used two create human-readable errors.
 */
#define OOSQLiteWrapperDomain @"OOSQLiteWrapper"
#define SQLiteDataHandlerOriginalError @"SQLiteDataHandlerOriginalError"

typedef NS_ENUM(NSUInteger, OOSQLiteWrapperError){
    OOSQLiteWrapperErrorNoDataBase,
    OOSQLiteWrapperErrorNoDataBaseName,
    OOSQLiteWrapperErrorCouldNotCreatedDataBase,
    OOSQLiteWrapperErrorCouldNotSaveObject
};

@interface SQLiteDataHandler(){
    sqlite3 *_database; //The database API
    NSString* _dbname;  //name of the db
    BOOL _isDBOpen;     //indicates whether the DB API connection is open or not
    
    NSDictionary* _typeMapping; //wired in Object-C type <-> SQLite type dictionary
    NSDateFormatter* _dateFormatter; //dataformatter for converting datetime-s
}

@end

@implementation SQLiteDataHandler

@synthesize delegate;

#pragma mark - INIT 
-(id) init
{
    if (self = [super init])
    {
        _dbname = @"defaultDatabase";
        _isDBOpen = NO;
        
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
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

/**
    open: Opens the database from the .app/Documents folder.
 */
-(NSError*) open
{
    //Return if there is no DB name
    if (_dbname.length == 0)
        return [NSError errorWithDomain:OOSQLiteWrapperDomain code:OOSQLiteWrapperErrorNoDataBaseName userInfo:@{NSLocalizedDescriptionKey:@"OOSQLiteWrapperErrorNoDataBaseName"}];
    
    NSString *document = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *path = [[document stringByAppendingPathComponent:_dbname] stringByAppendingFormat:@".db"];
    
//    Uncomment this when testing
//    path = @"/Users/peteee24/Library/Developer/Xcode/DerivedData/Distinction.Common.ObjC-caigjqaxmnluioelmpykurzaxzia/Build/Products/testDb.db";
    
    //Return error if we could not open the DB. SQLite returns 0 if everything went OK
    if (sqlite3_open(path.UTF8String, &_database)) {
        return [NSError errorWithDomain:OOSQLiteWrapperDomain code:OOSQLiteWrapperErrorCouldNotCreatedDataBase userInfo:@{NSLocalizedDescriptionKey:@"OOSQLiteWrapperErrorCouldNotCreatedDataBase"}];
    }
    
    _isDBOpen = YES;
    
    return nil;
}

/**
    close: Closes the database.
 */
-(void) close
{
    sqlite3_close(_database);
    _isDBOpen = NO;
}

-(id)queryFromConstraints:(NSArray *)arrayOfConstraints
{
    return nil;
}

/**
 createTypeStringMap Creates the Objective-C <-> SQLite type mapping
 */
-(void)createTypeStringMap
{
    _typeMapping = @{
                     @"NSString" : @"TEXT",
                     @"NSNumber" : @"INTEGER",
                     @"int" : @"INTEGER",
                     @"NSDate" : @"DATETIME",
                     @"id"   : @"TEXT"
                     };
}

/**
    createDataBaseIfNotExistsForObjectKind: Creates the table [className] if it does not exist
     @param klass the target Class
 */
-(void) createDataBaseIfNotExistsForObjectKind:(Class)klass
{
    BOOL tableExists = [self tableExistsForObjectKind:klass];
    
    //If table already exists, return
    if (tableExists)
        return;
    
    //Else open the DB API
    if (_isDBOpen == NO)
        [self open];
    
    //Get the property names and informations
    NSMutableDictionary* propertyInfo = [[klass propertyList] mutableCopy];
    
    //The following code assembles a SQLite create table statement, first set the tableName
    NSString *sql_stmt = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(", NSStringFromClass(klass)];
    
    NSMutableArray* paramComponents = [@[] mutableCopy];
    
    //Create all [propertyName SQLiteType] pairs
    for (NSString* key in propertyInfo) {
        NSString* type = propertyInfo[key][0];
        id sqliteTypeStr = _typeMapping[type];
        
        if (!sqliteTypeStr)
            continue;
        
        //If the property is the ID property, add PRIMARY KEY attribute to the declaration
        if ([key isEqualToString:[klass getRowIdName]])
        {
            sqliteTypeStr = [sqliteTypeStr stringByAppendingString:@" PRIMARY KEY"];
        }
        
        [paramComponents addObject:[NSString stringWithFormat:@"%@ %@", key,sqliteTypeStr]];
    }
    
    //Add the pairs separated by ','
    sql_stmt = [sql_stmt stringByAppendingString:[paramComponents componentsJoinedByString:@","]];
    sql_stmt = [sql_stmt stringByAppendingString:@")"];
    
    //Run the statement
    char *errMsg;
    if (sqlite3_exec(_database, sql_stmt.UTF8String, NULL, NULL, &errMsg))
    {
        NSError* error = [NSError errorWithDomain:OOSQLiteWrapperDomain code:OOSQLiteWrapperErrorCouldNotCreatedDataBase userInfo:@{NSLocalizedDescriptionKey:@"OOSQLiteWrapperErrorCouldNotCreatedDataBase",SQLiteDataHandlerOriginalError:[NSString stringWithUTF8String:errMsg]}];
    }
    
    //Close the DB API
    [self close];
}

/**
    tableExistsForObjectKind: checks whether table for Class exists
    @param klass the target Class
 */

-(BOOL) tableExistsForObjectKind:(Class)klass
{
    //If no klass is given return
    if (klass == nil)
        return NO;
    
    //Open the DB API if its closed
    if (_isDBOpen == NO)
        [self open];
    
    //Query to check if a table exists in DB
    NSString* testQuery = [NSString stringWithFormat:@"SELECT name FROM sqlite_master WHERE type='table' AND name='%@'",NSStringFromClass(klass)];
    
    sqlite3_stmt *statement;
    
    BOOL result = NO;
    
    //Run query and if it has result rows, then the answer is YES else its NO
    if (sqlite3_prepare_v2(_database, testQuery.UTF8String, -1, &statement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            result = YES;
        }
        
        sqlite3_finalize(statement);
    }
    
    //Close the DB API
    [self close];
    
    return result;
}

/**
    objectExists: Check wether the object is in the table or not. Currently INSERT OR REPLACE is used
    @param object object to decide
 */
-(BOOL) objectExists:(BaseDataObject<DataRowProtocoll>*)object
{
    //Open DB API if its closed
    if (_isDBOpen == NO)
        [self open];
    
    //Query for getting the object by the ID property
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = '%@'",NSStringFromClass(object.class), [object.class getRowIdName], object.getRowId];
    
    sqlite3_stmt *statement;
    
    BOOL result = NO;
    
    //If the result has rows, then it exists, else NOT
    if (sqlite3_prepare_v2(_database, query.UTF8String, -1, &statement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            result = YES;
        }
        
        sqlite3_finalize(statement);
    }
    
    //Close the DB API
    [self close];
    
    return result;
}

#pragma mark - SAVE
-(BOOL) saveObject:(BaseDataObject<DataRowProtocoll>*)obj error:(NSError *__autoreleasing *)error
{
    //Create the table if it does not exist
    [self createDataBaseIfNotExistsForObjectKind:obj.class];
    
    //Open DB API
    if (_isDBOpen == NO)
        [self open];
    
    //Create save statement
    NSString *sql_stmt = [self saveStatementFromObject:obj];
    
    //Try to save the object
    char *errMsg;
    BOOL succeded = sqlite3_exec(_database, sql_stmt.UTF8String, NULL, NULL, &errMsg) == SQLITE_OK;
    
    if (!succeded)
    {
        *error = [NSError errorWithDomain:OOSQLiteWrapperDomain code:OOSQLiteWrapperErrorCouldNotSaveObject userInfo:@{NSLocalizedDescriptionKey:@"OOSQLiteWrapperErrorCouldNotSaveObject",SQLiteDataHandlerOriginalError:[NSString stringWithUTF8String:errMsg]}];
    }
    
    //Close the DB API
    [self close];
    
    return succeded;
}

-(BOOL) saveArray:(NSArray*)array error:(NSError *__autoreleasing *)error
{
    //Iterate through the array
    for (id object in array) {
        
        //Only call saveObject if the object class and interface is correct
        if ([object isKindOfClass:[BaseDataObject class]] && [object conformsToProtocol:@protocol(DataRowProtocoll)])
        {
            if (![self saveObject:object error:error])
                return NO;
        }
    }
    
    return YES;
}

/**
    saveStatementFromObject: Creates a statement as string, that inserts or replace the object in db
    @param obj the object, from that the SQL statement is created
    @return the SQL statement string
    
    Example:
        TestModel:
            NSString* name = @"distinction"
            NSString* objectId @"78uJiKo8gg"
        Statement
            INSERT OR REPLACE INTO TestModel (name,objectId) VALUES ('distinction','78uJiKo8gg');
 */
-(NSString*)saveStatementFromObject:(BaseDataObject<DataRowProtocoll>*)obj
{
    NSMutableArray* columnNames = [@[] mutableCopy];
    NSMutableArray* valueNames = [@[] mutableCopy];
    
    NSDictionary* propertyInfo = [obj.class propertyList];
    
    for (NSString* key in propertyInfo) {
        
        id value = obj[key];
        NSString* sqlType = _typeMapping[propertyInfo[key][0]];
        
        if (value && sqlType.length > 0)
        {
            //If its a date, create an SQLite-compatible text from it
            if ([value isKindOfClass:[NSDate class]])
            {                
                value = [NSString stringWithFormat:@"datetime(%lf, 'unixepoch')",[value timeIntervalSince1970]];
            }
            //If it is a string, wrap in ''
            else if ([value isKindOfClass:[NSString class]])
            {
                value = [NSString stringWithFormat:@"'%@'",value];
            }
            
            [columnNames addObject:key];
            [valueNames addObject:value];
        }
    }
    
    NSString *sql_stmt = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@)",
                          NSStringFromClass(obj.class),
                          [columnNames componentsJoinedByString:@","],
                          [valueNames componentsJoinedByString:@","]
                          ];
    
    return sql_stmt;
}

#pragma mark -  LOAD
-(NSArray*) findObjectsOfKind:(Class)klass forQuery:(NSString*)query pageIndex:(NSUInteger)pageIndex pageSize:(NSUInteger)pageSize orderBy:(NSDictionary *)orderBy
{
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    NSString *queryStmt = [self queryStatementForObjectKind:klass]; //Create basic query for class. e.g. SELECT * FROM MyModel
    
    //If query presented add a WHERE condition
    if (query.length > 0)
    {
        @try {
            NSPredicate* predicateFromQuery = [NSPredicate predicateWithFormat:query];
            
            //If we are here, then NSPredicate didnt throw exception, the query is good for a WHERE condition
            queryStmt = [queryStmt stringByAppendingFormat:@" WHERE %@",query];
        }
        @catch (NSException *exception) {
            //Error handling
        }
    }
    
    //Appending order values
    if (orderBy)
    {
        NSString* orderByStr = @" ORDER BY ";
        NSMutableArray* params = [@[] mutableCopy];
        
        for (NSString* column in orderBy) {
            BOOL descendingByColumn = [orderBy[column] boolValue];
            
            [params addObject:[NSString stringWithFormat:@"%@ %@", column, descendingByColumn ? @"DESC" : @"ASC"]];
        }
        
        orderByStr = [orderByStr stringByAppendingString:[params componentsJoinedByString:@","]];
        queryStmt = [queryStmt stringByAppendingString:orderByStr];
    }
    
    //Append paging variables
    queryStmt = [queryStmt stringByAppendingFormat:@" LIMIT %d OFFSET %d",pageSize, pageIndex*pageSize];
    
    sqlite3_stmt *statement;
    
    if (_isDBOpen == NO)
        [self open];
    
    //Run the query
    if (sqlite3_prepare_v2(_database, queryStmt.UTF8String, -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
        
            BaseDataObject* object = [self objectFromRow:statement ofKind:klass];//Create object from result row
            [objects addObject:object];
        }
        
        sqlite3_finalize(statement);
    }
    else{
        //Error handling
    }
    
    [self close];
    
    return objects;
}

-(NSArray*) findAllObjectOfKind:(Class)klass
{
    return [self findAllObjectOfKind:klass forQuery:nil];
}

-(NSArray*) findAllObjectOfKind:(Class)klass forQuery:(NSString*)query
{
    NSUInteger pageIndex = 0;
    NSUInteger size = 100;
    
    NSMutableArray* objects = [@[] mutableCopy];
    NSArray* objectOnPage;
    
    do {
        
        objectOnPage = [self findObjectsOfKind:klass forQuery:query pageIndex:pageIndex pageSize:size orderBy:nil];
        
        if (objectOnPage.count)
        {
            [objects addObjectsFromArray:objectOnPage];
            pageIndex ++;
        }
        
    } while (objectOnPage.count >= size);
    
    return objects;
}



/**
    queryStatementForObjectKind: Creates the basic query string for a given object
    @param klass the class of that object
    @return the query string
 */

-(NSString*)queryStatementForObjectKind:(Class)klass
{
    return [NSString stringWithFormat:@"SELECT * FROM %@",NSStringFromClass(klass)];
}

/**
     objectFromRow: ofKind: Creates a [klass] instance from the statement (result row)
     @param statement the result row
     @param klass the class of the expected object
     @return the object
 */
-(BaseDataObject*)objectFromRow:(sqlite3_stmt*)statement ofKind:(Class)klass
{
    //Get infos about the properties of the target class
    NSDictionary* propList = [klass propertyList];
    
    //Get the num of columns in the result row
    int numOfColumns = sqlite3_column_count(statement);
    
    BaseDataObject<DataRowProtocoll>* object = [[klass alloc] init];
    
    //For every column row
    for (int i = 0; i < numOfColumns; i++) {
        const char *columnName = sqlite3_column_name(statement, i); //get the name of the i.th column
        NSString* columnStr = [NSString stringWithUTF8String:columnName]; //NSString version of previous column name
        NSArray* attributes = propList[columnStr]; //get the attributes to this property
        
        //If there is any
        if (attributes.count){
            NSString* columnType = _typeMapping[attributes[0]]; //Get the SQLite type to the property type
            
            if (!columnType)//Cannot handle this type, continue
                continue;
            else if ([columnType isEqualToString:@"TEXT"])//If its a text
            {
                char *chars = (char *) sqlite3_column_text(statement, i);
                
                if (chars == NULL)//No values, no need to process
                    continue;
                
                //SQLite does not make a difference between dates and strings, they both stored as TEXT, if we can create an nsdate from it then its a date, if not then its a string
                NSString* string = [NSString stringWithUTF8String:chars];//NSString version of the value
                NSDate* date = [_dateFormatter dateFromString:string];//NSDate from the string
                
                if (date)//We could create date from it
                    object[columnStr] = date;
                else{
                    if ([columnStr isEqualToString:[klass getRowIdName]])//If the string is a value of the rowId use the protocoll to set it
                        [object setRowId:string];
                    else
                        object[columnStr] = string;
                }
            }
            else if ([columnType isEqualToString:@"INTEGER"])//If the value is an integer, create NSNUmber from it
            {
                int integer = sqlite3_column_int(statement, i);
                object[columnStr] = @(integer);
            }
        }
    }
    
    return object;
}

#pragma mark - DELETE
-(BOOL) deleteObject:(BaseDataObject<DataRowProtocoll> *)obj error:(NSError *__autoreleasing *)error
{
    //Open DB API
    if (_isDBOpen == NO)
        [self open];
    
    //Create delete statement
    NSString *sql_stmt = [self deleteStatementFrom:obj];
    
    //Try to delete the object
    char *errMsg;
    BOOL succeded = sqlite3_exec(_database, sql_stmt.UTF8String, NULL, NULL, &errMsg) == SQLITE_OK;
    if (!succeded)
    {
        *error = [NSError errorWithDomain:OOSQLiteWrapperDomain code:OOSQLiteWrapperErrorCouldNotCreatedDataBase userInfo:@{NSLocalizedDescriptionKey:@"OOSQLiteWrapperErrorCouldNotCreatedDataBase",SQLiteDataHandlerOriginalError:[NSString stringWithUTF8String:errMsg]}];
    }
    
    //Close the DB API
    [self close];
    
    return succeded;
}

-(BOOL) deleteArray:(NSArray *)array error:(NSError *__autoreleasing *)error
{
    for (id object in array) {
        if ([object isKindOfClass:[BaseDataObject class]] && [object conformsToProtocol:@protocol(DataRowProtocoll) ])
        {
            if (![self deleteObject:object error:error])
                return NO;
        }
    }
    
    return YES;
}

//DELETE FROM Books2 WHERE Id=1;
-(NSString*) deleteStatementFrom:(BaseDataObject<DataRowProtocoll>*)obj
{
    return [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@ ='%@'",NSStringFromClass(obj.class), [[obj class] getRowIdName], [obj getRowId]];
}

@end
