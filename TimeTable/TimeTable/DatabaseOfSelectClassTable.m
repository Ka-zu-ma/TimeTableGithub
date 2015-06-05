//
//  DatabaseOfSelectClassTable.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/03.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "DatabaseOfSelectClassTable.h"

@implementation DatabaseOfSelectClassTable

+(FMDatabase *)getDatabaseOfselectclass{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathString=paths[0];
    FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"selectclass.db"]];
    
    return db;
}

+(void)createSelectClassTable{
    
    FMDatabase *db=[self getDatabaseOfselectclass];//クラスメソッド内のselfは自身のClassオブジェクトを指している
    
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS selectclasstable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT, teacherName TEXT, classroomName TEXT, indexPath INTEGER);"];
    [db close];
}

+(void)insertSelectClassTable:(NSString *)classNameString teacherName:(NSString *)teacherNameString classroomName:(NSString *)classroomNameString indexPathRow:(NSString *)indexPathRowString{
    
    FMDatabase *db=[DatabaseOfSelectClassTable getDatabaseOfselectclass];
    [db open];
    
    [db executeUpdate:@"INSERT INTO selectclasstable (className, teacherName, classroomName, indexPath) VALUES  (?, ?, ?, ?);",classNameString,teacherNameString,classroomNameString,indexPathRowString];
    
    [db close];
}

+(void)selectSelectClassTable{
    
    FMDatabase *db=[self getDatabaseOfselectclass];
    [db open];
    
    
    
    
}
@end
