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


@end
