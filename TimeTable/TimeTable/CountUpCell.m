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
    
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)attendanceButton:(id)sender {
    
    [self selectCountsOfMaxId];
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    [db executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount) VALUES (?, ?, ?);",_attendanceCountOfMaxId+1,_absenceCountOfMaxId,_lateCountOfMaxId];
    [db close];
   
    [self selectCountsOfMaxId];
    [self updateButtonTitleLabelText];
    
    FMDatabase *twodb=[super getDatabaseOfDateAndAttendanceRecordTable];
    [twodb open];
    [twodb executeUpdate:@"INSERT INTO date_attendancerecord_table (date, attendancerecord) VALUES (?, ?);",[self getNowTime],@"出席"];
    [twodb close];
}

- (IBAction)absenceButton:(id)sender {
    [self selectCountsOfMaxId];
    
    FMDatabase *onedb=[super getDatabaseOfCountUpRecordTable];
    [onedb open];
    [onedb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount) VALUES (?, ?, ?);",_attendanceCountOfMaxId,_absenceCountOfMaxId+1,_lateCountOfMaxId];
    [onedb close];
    
    [self selectCountsOfMaxId];
    [self updateButtonTitleLabelText];
    
    FMDatabase *twodb=[super getDatabaseOfDateAndAttendanceRecordTable];
    [twodb open];
    
    
    [twodb executeUpdate:@"INSERT INTO date_attendancerecord_table (date, attendancerecord) VALUES (?, ?);",[self getNowTime],@"欠席"];
    [twodb close];
}

- (IBAction)lateButton:(id)sender {
    [self selectCountsOfMaxId];
    
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    [db executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount) VALUES (?, ?, ?);",_attendanceCountOfMaxId,_absenceCountOfMaxId,_lateCountOfMaxId+1];
    [db close];
    
    [self selectCountsOfMaxId];
    [self updateButtonTitleLabelText];
    
    FMDatabase *twodb=[super getDatabaseOfDateAndAttendanceRecordTable];
    [twodb open];
    
    
    [twodb executeUpdate:@"INSERT INTO date_attendancerecord_table (date, attendancerecord) VALUES (?, ?);",[self getNowTime],@"遅刻"];
    [twodb close];

}

-(void)selectCountsOfMaxId{
    FMDatabase *db=[super getDatabaseOfCountUpRecordTable];
    [db open];
    
    FMResultSet *oneresults=[db executeQuery:@"SELECT attendancecount, absencecount , latecount FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table);"];
    
    _attendanceCountOfMaxId=[oneresults intForColumn:@"attendancecount"];
    _absenceCountOfMaxId=[oneresults intForColumn:@"absencecount"];
    _lateCountOfMaxId=[oneresults intForColumn:@"latecount"];
    
    [db close];
}

-(void)updateButtonTitleLabelText{
    _attendanceButton.titleLabel.text=[NSString stringWithFormat:@"%ld",(long)_attendanceCountOfMaxId];
    _absenceButton.titleLabel.text=[NSString stringWithFormat:@"%ld",(long)_absenceCountOfMaxId];
    _lateButton.titleLabel.text=[NSString stringWithFormat:@"%ld",(long)_lateCountOfMaxId];
    
}
-(NSString *)getNowTime{
    
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"ja_JP"]];
    [format setDateFormat:@"yyyy/MM/dd"];
    NSString *stringTime=[format stringFromDate:[NSDate date]];
    return stringTime;
}

@end
