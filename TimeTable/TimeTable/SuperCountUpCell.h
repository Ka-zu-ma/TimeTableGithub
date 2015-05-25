//
//  SuperCountUpCell.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/25.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface SuperCountUpCell : UITableViewCell
-(FMDatabase *)getDatabaseOfCountUpRecordTable;
-(void)createCountUpRecordTable;
-(void)createDateAndAttendanceRecordTable;
-(FMDatabase *)getDatabaseOfDateAndAttendanceRecordTable;


//-(void)selectAttendanceCountOfMaxIdFromCountUpRecordTable;
@end
