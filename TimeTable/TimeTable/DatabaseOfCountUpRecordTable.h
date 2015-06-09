//
//  DatabaseOfCountUpRecordTable.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/08.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DatabaseOfCountUpRecordTable : NSObject
+(void)createCountUpRecordTable;
+(void)insertInitialValueCountUpRecordTable:(NSString *)indexPathRow;
+(void)insertCountUpRecordTable:(NSString *)attendancecount absencecount:(NSString *)absencecount latecount:(NSString *)latecount indexPathRow:(NSString *)indexPathRow;
+(void)selectCountUpRecordTable:(NSString *)indexPathRow attendanceCount:(NSString *)attendanceCountString absenceCount:(NSString *)absenceCountString lateCount:(NSString *)lateCountString;
+(NSArray *)selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:(NSString *)indexPathRow;
+(NSMutableArray *)selectIndexPath;
@end
