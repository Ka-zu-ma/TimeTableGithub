//
//  DatabaseOfDateAndAttendanceRecordTable.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/08.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "DatabaseOfDateAndAttendanceRecordTable.h"
#import "CommonMethodsOfDatabase.h"


@implementation DatabaseOfDateAndAttendanceRecordTable

+(void)createTable{
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"date_attendancerecord.db"];
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS date_attendancerecord_table (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, attendancerecord TEXT, indexPath INTEGER);"];
    [db close];
}

+(void)insertDateAndAttendanceRecord:(NSString *)today attendanceRecord:(NSString *)attendanceRecord indexPathRow:(NSString *)indexPathRow{
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"date_attendancerecord.db"];
    
    [db open];
    [db executeUpdate:@"INSERT INTO date_attendancerecord_table (date, attendancerecord, indexPath) VALUES (?, ?, ?);",today,attendanceRecord,indexPathRow];
    [db close];
}

+(void)selectDateAndAttendanceRecord:(NSMutableArray *)dates attendanceOrAbsenceOrLates:(NSMutableArray *)attendanceOrAbsenceOrLates indexPathRow:(NSString *)indexPathRow{
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"date_attendancerecord.db"];
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT date, attendancerecord FROM date_attendancerecord_table WHERE indexPath=?;",indexPathRow];
    
    while ([results next]) {
        [dates addObject:[results stringForColumn:@"date"]];
        [attendanceOrAbsenceOrLates addObject:[results stringForColumn:@"attendancerecord"]];
        
    }
    [db close];
}

+(NSArray *)selectDateAndAttendanceRecordWhereMaxIdWhereindexPath:(NSString *)indexPathRow{
    
    NSMutableArray *dates=[[NSMutableArray alloc]init];
    NSMutableArray *attendanceOrAbsenceOrLates=[[NSMutableArray alloc]init];
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"date_attendancerecord.db"];
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT date, attendancerecord FROM  date_attendancerecord_table WHERE id = (SELECT MAX(id) FROM date_attendancerecord_table  WHERE indexPath = ?);",indexPathRow];
    
    while ([results next]) {
        [dates addObject:[results stringForColumn:@"date"]];
        [attendanceOrAbsenceOrLates addObject:[results stringForColumn:@"attendancerecord"]];
        
    }
    [db close];
    
    return @[dates,attendanceOrAbsenceOrLates];
}



@end
