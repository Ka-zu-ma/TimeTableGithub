//
//  SuperCountUpCell.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/25.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "SuperCountUpCell.h"

@implementation SuperCountUpCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(FMDatabase *)getDatabaseOfCountUpRecordTable{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathString=paths[0];
    FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"count_up_record.db"]];
    
    return db;
    
}
-(void)createCountUpRecordTable{
    
    FMDatabase *db=[self getDatabaseOfCountUpRecordTable];
    [db open];
    
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS count_up_record_table (id INTEGER PRIMARY KEY AUTOINCREMENT, attendancecount INTEGER, absencecount INTEGER, latecount INTEGER);"];
    
    [db close];
}
-(FMDatabase *)getDatabaseOfDateAndAttendanceRecordTable{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPathString=paths[0];
    FMDatabase *db=[FMDatabase databaseWithPath:[dbPathString stringByAppendingPathComponent:@"date_attendancerecord.db"]];
    
    return db;
}

-(void)createDateAndAttendanceRecordTable{
    FMDatabase *db=[self getDatabaseOfDateAndAttendanceRecordTable];
    [db open];
    [db executeUpdate:@"CREATE TABLE IF NOT EXISTS dates_attendancerecord_table (id INTEGER PRIMARY KEY AUTOINCREMENT, date TEXT, attendancerecord TEXT);"];
    [db close];
}
/*-(void)selectAttendanceCountOfMaxIdFromCountUpRecordTable{
    FMDatabase *db=[self getDatabaseOfCountUpRecordTable];
    [db open];
    FMResultSet *results=[db executeQuery:@"SELECT attendancecount FROM count_up_record_table　WHERE id= (SELECT MAX(id) FROM count_up_record_table);"];
    
    _attendanceCountOfMaxId=[results stringForColumn:@"attendancecount"];
    
    [db close];
}*/

@end
