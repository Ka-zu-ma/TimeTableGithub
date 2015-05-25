//
//  SuperAttendanceRecordViewController.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/25.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "SuperAttendanceRecordViewController.h"

@interface SuperAttendanceRecordViewController ()

@end

@implementation SuperAttendanceRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
