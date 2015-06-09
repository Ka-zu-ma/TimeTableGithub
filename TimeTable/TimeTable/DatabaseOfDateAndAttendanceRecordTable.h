//
//  DatabaseOfDateAndAttendanceRecordTable.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/08.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

@interface DatabaseOfDateAndAttendanceRecordTable : NSObject

+(void)createTable;
+(void)insertDateAndAttendanceRecord:(NSString *)today attendanceRecord:(NSString *)attendanceRecord indexPathRow:(NSString *)indexPathRow;
+(void)update:(NSString *)dateTextFieldText attendanceRecordTextFieldText:(NSString *)attendanceRecordTextFieldText dateString:(NSString *)dateString attendanceRecordString:(NSString *)attendanceRecordString;
+(NSArray *)selectDateAndAttendanceRecord:(NSString *)indexPathRow;
+(NSArray *)selectWhereMaxIdWhereindexPath:(NSString *)indexPathRow;
+(void)delete:(NSString *)date attendancerecord:(NSString *)attendancerecord indexPathRow:(NSString *)indexPathRow;
@end
