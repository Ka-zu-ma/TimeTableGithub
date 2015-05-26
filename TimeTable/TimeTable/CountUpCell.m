//
//  AttendanceRecordTableViewCell.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/12.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "CountUpCell.h"
#import "FMDatabase.h"
#import "SuperAttendanceRecordViewController.h"
#import "SuperCountUpCell.h"


@implementation CountUpCell

- (void)awakeFromNib {
    //出席ボタン
    //枠線色
    [[_attendanceButton layer] setBorderColor:[[UIColor redColor]CGColor]];
    //枠線太さ
    [[_attendanceButton layer] setBorderWidth:1.0];
    //枠線角丸
    [[_attendanceButton layer] setCornerRadius:10.0];
    [_attendanceButton setClipsToBounds:YES];
    
    [[_absenceButton layer] setBorderColor:[[UIColor blueColor]CGColor]];
    
    [[_absenceButton layer] setBorderWidth:1.0];
    
    [[_absenceButton layer] setCornerRadius:10.0];
    [_absenceButton setClipsToBounds:YES];
    
    [[_lateButton layer] setBorderColor:[[UIColor greenColor]CGColor]];
    
    [[_lateButton layer] setBorderWidth:1.0];
    
    [[_lateButton layer] setCornerRadius:10.0];
    [_lateButton setClipsToBounds:YES];
    
    //このメソッドはAttendanceRecordViewControllerのviewWillappearよりあとに呼ばれる
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)attendanceButton:(id)sender {
    
    [self selectCountsOfMaxIdAndNewCounts];
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    [db executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount) VALUES (?, ?, ?);",_renewAttendanceCountOfMaxIdString,_absenceCountOfMaxIdString,_lateCountOfMaxIdString];
    [db close];
   
    FMDatabase *twodb=[super getDatabaseOfDateAndAttendanceRecordTable];
    [twodb open];
    [twodb executeUpdate:@"INSERT INTO date_attendancerecord_table (date, attendancerecord) VALUES (?, ?);",[self getNowTime],@"出席"];
    [twodb close];
    
}

- (IBAction)absenceButton:(id)sender {
    [self selectCountsOfMaxIdAndNewCounts];
    
    FMDatabase *onedb=[super getDatabaseOfCountUpRecordTable];
    [onedb open];
    
    [onedb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount) VALUES (?, ?, ?);",_attendanceCountOfMaxIdString,_renewAbsenceCountOfMaxIdString,_lateCountOfMaxIdString];
    [onedb close];
    
    FMDatabase *twodb=[super getDatabaseOfDateAndAttendanceRecordTable];
    [twodb open];
    
    [twodb executeUpdate:@"INSERT INTO date_attendancerecord_table (date, attendancerecord) VALUES (?, ?);",[self getNowTime],@"欠席"];
    [twodb close];
}

- (IBAction)lateButton:(id)sender {
    [self selectCountsOfMaxIdAndNewCounts];
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    
    [db executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount) VALUES (?, ?, ?);",_attendanceCountOfMaxIdString,_absenceCountOfMaxIdString,_renewlateCountOfMaxIdString];
    [db close];
    
    FMDatabase *twodb=[super getDatabaseOfDateAndAttendanceRecordTable];
    [twodb open];
    
    [twodb executeUpdate:@"INSERT INTO date_attendancerecord_table (date, attendancerecord) VALUES (?, ?);",[self getNowTime],@"遅刻"];
    [twodb close];

}

-(void)selectCountsOfMaxIdAndNewCounts{
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    
    FMResultSet *oneresults=[db executeQuery:@"SELECT attendancecount, absencecount, latecount  FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table);"];
    
    _attendanceCountOfMaxIdString=[oneresults stringForColumn:@"attendancecount"];
    _absenceCountOfMaxIdString=[oneresults stringForColumn:@"absencecount"];
    _lateCountOfMaxIdString=[oneresults stringForColumn:@"latecount"];
    
    int a=_renewAttendanceCountOfMaxIdString.intValue;
    int b=_attendanceCountOfMaxIdString.intValue;
    int c=_renewAbsenceCountOfMaxIdString.intValue;
    int d=_absenceCountOfMaxIdString.intValue;
    int e=_renewlateCountOfMaxIdString.intValue;
    int f=_lateCountOfMaxIdString.intValue;
    
    a=b+1;
    c=d+1;
    e=f+1;
    NSLog(@"%d",a);
    [db close];
    
    //この書き方だとなぜエラーが出るのか
    //_renewAttendanceCountOfMaxIdString.intValue=_attendanceCountOfMaxIdString.intValue + 1;
}

-(NSString *)getNowTime{
    
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"ja_JP"]];
    [format setDateFormat:@"yyyy/MM/dd"];
    NSString *stringTime=[format stringFromDate:[NSDate date]];
    return stringTime;
}

@end
