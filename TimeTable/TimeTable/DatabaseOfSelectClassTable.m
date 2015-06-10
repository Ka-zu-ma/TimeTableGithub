//
//  DatabaseOfSelectClassTable.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/03.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "DatabaseOfSelectClassTable.h"
#import "CommonMethodsOfDatabase.h"
@implementation DatabaseOfSelectClassTable

+(void)createSelectClassTable{
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"selectclass.db"];//クラスメソッド内のselfは自身のClassオブジェクトを指している
    
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS selectclasstable (id INTEGER PRIMARY KEY AUTOINCREMENT, className TEXT, teacherName TEXT, classroomName TEXT, indexPath INTEGER);"];
    [db close];
}

+(void)insertSelectClassTable:(NSString *)classNameString teacherName:(NSString *)teacherNameString classroomName:(NSString *)classroomNameString indexPathRow:(NSString *)indexPathRowString{
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"selectclass.db"];
    [db open];
    
    [db executeUpdate:@"INSERT INTO selectclasstable (className, teacherName, classroomName, indexPath) VALUES  (?, ?, ?, ?);",classNameString,teacherNameString,classroomNameString,indexPathRowString];
    
    [db close];
}

+(void)selectSelectClassTable:(NSMutableDictionary *)classNamesAndIndexPathes classroomNamesAndIndexPathes:(NSMutableDictionary *)classroomNamesAndIndexPathes{
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"selectclass.db"];
    [db open];
    
    [db beginTransaction];
    
    FMResultSet *results=[db executeQuery:@"SELECT className, classroomName, indexPath FROM selectclasstable;"];
    
    while ([results next]) {
        
        [classNamesAndIndexPathes setObject:[results stringForColumn:@"className"] forKey:[results stringForColumn:@"indexPath"]];
        [classroomNamesAndIndexPathes setObject:[results stringForColumn:@"classroomName"] forKey:[results stringForColumn:@"indexPath"]];
    }
    
    [db commit];
    
    [db close];
}
@end
