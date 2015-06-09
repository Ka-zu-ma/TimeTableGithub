//
//  AttendanceRecordPickerData.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/09.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "AttendanceRecordPickerData.h"

@implementation AttendanceRecordPickerData
+(NSArray *)createAttendanceRecordList{
    NSArray *attendanceRecordList=@[@"出席",@"欠席",@"遅刻"];
    return attendanceRecordList;
}
@end
