//
//  DatabaseOfCountUpRecordTable.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/08.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "DatabaseOfCountUpRecordTable.h"
#import "CommonMethodsOfDatabase.h"

@implementation DatabaseOfCountUpRecordTable

+(void)createCountUpRecordTable{
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"count_up_record.db"];
    [db open];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS count_up_record_table (id INTEGER PRIMARY KEY AUTOINCREMENT, attendancecount INTEGER, absencecount INTEGER, latecount INTEGER, indexPath  INTEGER);"];
    
    [db close];
}

+(void)insertInitialValueCountUpRecordTable:(NSString *)indexPathRow{
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"count_up_record.db"];
    [db open];
    
    [db executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount,  latecount, indexPath) VALUES (?, ?, ?, ?);",@"0",@"0",@"0",indexPathRow];
    [db close];

}

+(void)insertCountUpRecordTable:(NSString *)attendancecount absencecount:(NSString *)absencecount latecount:(NSString *)latecount indexPathRow:(NSString *)indexPathRow{
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"count_up_record.db"];
    [db open];
    
    [db executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount,indexPath) VALUES (?, ?, ?, ?);",attendancecount,absencecount,latecount,indexPathRow];
    [db close];
}

+(void)selectCountUpRecordTable:(NSString *)indexPathRow attendanceCount:(NSString *)attendanceCountString absenceCount:(NSString *)absenceCountString lateCount:(NSString *)lateCountString{
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"count_up_record.db"];
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT attendancecount, absencecount ,latecount FROM count_up_record_table WHERE indexPath = ?;",indexPathRow];
    
    while ([results next]) {
        attendanceCountString=[results stringForColumn:@"attendancecount"];
        absenceCountString=[results stringForColumn:@"absencecount"];
        lateCountString=[results stringForColumn:@"latecount"];
    }
    
    [db close];

}

+(NSArray *)selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:(NSString *)indexPathRow{
    
    NSString *attendanceCountString;
    NSString *absenceCountString;
    NSString *lateCountString;
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"count_up_record.db"];
    [db open];
    
    FMResultSet *results=[db executeQuery:@"SELECT attendancecount, absencecount, latecount FROM  count_up_record_table WHERE id=(SELECT MAX(id) FROM count_up_record_table WHERE indexPath = ?);",indexPathRow];
    
    while ([results next]) {
        attendanceCountString=[results stringForColumn:@"attendancecount"];
        absenceCountString=[results stringForColumn:@"absencecount"];
        lateCountString=[results stringForColumn:@"latecount"];
    }
    [db close];
    
    return @[attendanceCountString,absenceCountString,lateCountString];
}

+(NSMutableArray *)selectIndexPath{
    
    NSMutableArray *indexPathes=[[NSMutableArray alloc]init];
    
    FMDatabase *db=[CommonMethodsOfDatabase getDatabaseFile:@"count_up_record.db"];
    [db open];

    FMResultSet *results=[db executeQuery:@"SELECT indexPath FROM count_up_record_table;"];
    while ([results next]) {
        [indexPathes addObject:[results stringForColumn:@"indexPath"]];
    }
    [db close];
    
    return indexPathes;
}

@end
