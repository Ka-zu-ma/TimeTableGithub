//
//  DatabaseOfCreateClassTable.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/03.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "DatabaseOfCreateClassTable.h"

@implementation DatabaseOfCreateClassTable

+(FMDatabase *)getDatabaseOfcreateclass{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathString=paths[0];
    FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"createclass.db"]];
    
    NSLog(@"createclass.dbの場所:%@",[dbPathString stringByAppendingPathComponent:@"createclass.db"]);
    return db;
}

+(void)createCreateClassTable{
    
    FMDatabase *db=[self getDatabaseOfcreateclass];
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS createclasstable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT, teacherName TEXT, classroomName TEXT);"];
    [db close];
    
}

+(void)insertCreateClassTable:(NSString *)classNameString teacherName:(NSString *)teacherNameString classroomName:(NSString *)classroomNameString{
    
    FMDatabase *db=[self getDatabaseOfcreateclass];
    [db open];
    [db executeUpdate:@"INSERT INTO createclasstable (className, teacherName, classroomName) VALUES  (?, ?, ?);",classNameString,teacherNameString,classroomNameString];
    
    [db close];
}

+(void)updateCreateClassTable:(NSString *)classNameTextField teacherNameTextField:(NSString *)teacherNameTextField  classroomNameTextField:(NSString *)classroomNameTextField classNameString:(NSString *)classNameString teacherNameString:(NSString *)teacherNameString classroomNameString:(NSString *)classroomNameString{
    
    FMDatabase *db=[self getDatabaseOfcreateclass];
    
    [db open];
    [db executeUpdate:@"UPDATE createclasstable SET className = ?, teacherName = ?, classroomName = ? WHERE className = ? AND teacherName = ? AND classroomName = ?;",classNameTextField,teacherNameTextField,classroomNameTextField,classNameString,teacherNameString,classroomNameString];
    
    [db close];
}

+(void)selectCreateClassTable:(NSString *)query className:(NSString *)className teacherName:(NSString *)teacherName classroomName:(NSString *)classroomName classes:(NSMutableArray *)classes teachers:(NSMutableArray *)teachers classroomNameString:(NSString *)classroomNameString{
    
    FMDatabase *db=[self getDatabaseOfcreateclass];
    [db open];
    
    FMResultSet *results=[db executeQuery:query,className,teacherName,classroomName];
    while ([results next]) {
        
        [classes addObject:[results stringForColumn:@"className"]];
        [teachers addObject:[results stringForColumn:@"teacherName"]];
        classroomName=[results stringForColumn:@"classroomName"];
    }
    
    [db close];

}

@end
