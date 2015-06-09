//
//  UpdateAttendanceRecordAndCountViewController.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/29.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "UpdateAttendanceRecordAndCountViewController.h"
#import "FMDatabase.h"
#import "TitleLabel.h"
#import "DatabaseOfDateAndAttendanceRecordTable.h"
#import "AttendanceRecordPickerData.h"
#import "DatabaseOfCountUpRecordTable.h"

@interface UpdateAttendanceRecordAndCountViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIPickerView *attendanceRecordPicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

@property (strong,nonatomic) NSString *attendanceCountString;
@property (strong,nonatomic) NSString *absenceCountString;
@property (strong,nonatomic) NSString *lateCountString;

@property  (strong,nonatomic) NSString *attendanceCountOfMaxIdString;
@property  (strong,nonatomic) NSString *absenceCountOfMaxIdString;
@property  (strong,nonatomic) NSString *lateCountOfMaxIdString;

@property (strong,nonatomic) NSString *latestDateString;
@property (strong,nonatomic) NSString *latestAttendanceRecordString;

- (IBAction)updateButton:(id)sender;
- (IBAction)changeDatePicker:(id)sender;

@end

@implementation UpdateAttendanceRecordAndCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _attendanceRecordPicker.delegate=self;
    _attendanceRecordPicker.dataSource=self;
    _attendanceRecordPicker.showsSelectionIndicator=YES;
    
    
    if ([_attendanceRecordString isEqual:@"出席"]) {
        [_attendanceRecordPicker selectRow:0 inComponent:0 animated:NO];
    }else if ([_attendanceRecordString  isEqual:@"欠席"]){
        [_attendanceRecordPicker selectRow:1 inComponent:0 animated:NO];
    }else{
        [_attendanceRecordPicker selectRow:2 inComponent:0 animated:NO];
    }
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    
    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
   
    _datePicker.date=[formatter dateFromString:_dateString];

    
    [[_updateButton layer] setCornerRadius:10.0];
    [_updateButton setClipsToBounds:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    self.navigationItem.titleView=[TitleLabel createTitlelabel:@"日付変更、出席状況変更"];
    
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];//バーアイテムカラー
    self.navigationController.navigationBar.barTintColor=[UIColor blueColor];//バー背景色
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UIPickerView Delegate

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    return [AttendanceRecordPickerData createAttendanceRecordList].count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    return [AttendanceRecordPickerData createAttendanceRecordList][row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _latestAttendanceRecordString=[[NSString alloc]initWithFormat:@"%@",[AttendanceRecordPickerData createAttendanceRecordList][row]];
}

#pragma mark - IBAction

- (IBAction)updateButton:(id)sender {
    
    NSString *indexPathString=[NSString stringWithFormat:@"%ld",(long)_indexPath.row];
    
    [DatabaseOfDateAndAttendanceRecordTable update:_latestDateString attendanceRecordTextFieldText:_latestAttendanceRecordString dateString:_dateString attendanceRecordString:_attendanceRecordString];
    
    
    //以下　Original Methodの引数に値を入れてコード量を減らしたい。
    if ([_attendanceRecordString isEqual:@"出席"]) {
        
        if ([_latestAttendanceRecordString isEqual:@"欠席"]) {
            
            
            NSString *attendanceCountOfMaxIdString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][0];
            NSString *absenceCountOfMaxIdString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][1];
            NSString *lateCountOfMaxIdString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][2];
            
            [DatabaseOfCountUpRecordTable insertCountUpRecordTable:[NSString stringWithFormat:@"%d",attendanceCountOfMaxIdString.intValue-1] absencecount:[NSString stringWithFormat:@"%d",absenceCountOfMaxIdString.intValue+1] latecount:lateCountOfMaxIdString indexPathRow:indexPathString];
        
        }else{
            
            //出席を遅刻に変更
            FMDatabase *twodb=[super getDatabaseOfCountUpRecordTable];
            [twodb open];
            
            FMResultSet *results=[twodb executeQuery:@"SELECT attendancecount, absencecount, latecount FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table WHERE indexPath = ?);",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
            
            while ([results next]) {
                
                _attendanceCountOfMaxIdString=[results stringForColumn:@"attendancecount"];
                _absenceCountOfMaxIdString=[results stringForColumn:@"absencecount"];
                _lateCountOfMaxIdString=[results stringForColumn:@"latecount"];
            }
            [twodb close];
            
            FMDatabase *threedb=[super getDatabaseOfCountUpRecordTable];
            [threedb open];
            
            [threedb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount, indexPath) VALUES  (?, ?, ?, ?);",[NSString stringWithFormat:@"%d",_attendanceCountOfMaxIdString.intValue - 1],_absenceCountOfMaxIdString,[NSString stringWithFormat:@"%d",_lateCountOfMaxIdString.intValue + 1 ],[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
            [threedb close];
        
        }
    }else if([_attendanceRecordString isEqual:@"欠席"]){
        if ([_latestAttendanceRecordString isEqual:@"出席"]) {
            
            //欠席を出席に変更
            FMDatabase *twodb=[super getDatabaseOfCountUpRecordTable];
            [twodb open];
            
            FMResultSet *results=[twodb executeQuery:@"SELECT attendancecount, absencecount, latecount FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table WHERE indexPath = ?);",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
            
            while ([results next]) {
                
                _attendanceCountOfMaxIdString=[results stringForColumn:@"attendancecount"];
                _absenceCountOfMaxIdString=[results stringForColumn:@"absencecount"];
                _lateCountOfMaxIdString=[results stringForColumn:@"latecount"];
            }
            [twodb close];
            
            FMDatabase *threedb=[super getDatabaseOfCountUpRecordTable];
            [threedb open];
            
            [threedb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount, indexPath) VALUES  (?, ?, ?, ?);",[NSString stringWithFormat:@"%d",_attendanceCountOfMaxIdString.intValue + 1],[NSString stringWithFormat:@"%d",_absenceCountOfMaxIdString.intValue - 1],_lateCountOfMaxIdString,[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
            [threedb close];
        }else{
            
            //欠席を遅刻に変更
            FMDatabase *twodb=[super getDatabaseOfCountUpRecordTable];
            [twodb open];
            
            FMResultSet *results=[twodb executeQuery:@"SELECT attendancecount, absencecount, latecount FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table WHERE indexPath = ?);",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
            
            while ([results next]) {
                
                _attendanceCountOfMaxIdString=[results stringForColumn:@"attendancecount"];
                _absenceCountOfMaxIdString=[results stringForColumn:@"absencecount"];
                _lateCountOfMaxIdString=[results stringForColumn:@"latecount"];
            }
            [twodb close];
            
            FMDatabase *threedb=[super getDatabaseOfCountUpRecordTable];
            [threedb open];
            
            [threedb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount, indexPath) VALUES  (?, ?, ?, ?);",_attendanceCountOfMaxIdString,[NSString stringWithFormat:@"%d",_absenceCountOfMaxIdString.intValue - 1],[NSString stringWithFormat:@"%d",_lateCountOfMaxIdString.intValue + 1],[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
            [threedb close];

        }
        
        
    }else{
        
        if ([_latestAttendanceRecordString isEqual:@"出席"]) {
            
            //遅刻を出席に変更
            FMDatabase *twodb=[super getDatabaseOfCountUpRecordTable];
            [twodb open];
            
            FMResultSet *results=[twodb executeQuery:@"SELECT attendancecount, absencecount, latecount FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table WHERE indexPath = ?);",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
            
            while ([results next]) {
                
                _attendanceCountOfMaxIdString=[results stringForColumn:@"attendancecount"];
                _absenceCountOfMaxIdString=[results stringForColumn:@"absencecount"];
                _lateCountOfMaxIdString=[results stringForColumn:@"latecount"];
            }
            [twodb close];
            
            FMDatabase *threedb=[super getDatabaseOfCountUpRecordTable];
            [threedb open];
            
            [threedb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount, indexPath) VALUES  (?, ?, ?, ?);",[NSString stringWithFormat:@"%d",_attendanceCountOfMaxIdString.intValue + 1],_absenceCountOfMaxIdString,[NSString stringWithFormat:@"%d",_lateCountOfMaxIdString.intValue - 1],[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
            [threedb close];

            
        }else{
            
            //遅刻を欠席に変更
            FMDatabase *twodb=[super getDatabaseOfCountUpRecordTable];
            [twodb open];
            
            FMResultSet *results=[twodb executeQuery:@"SELECT attendancecount, absencecount, latecount FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table WHERE indexPath = ?);",[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
            
            while ([results next]) {
                
                _attendanceCountOfMaxIdString=[results stringForColumn:@"attendancecount"];
                _absenceCountOfMaxIdString=[results stringForColumn:@"absencecount"];
                _lateCountOfMaxIdString=[results stringForColumn:@"latecount"];
            }
            [twodb close];
            
            FMDatabase *threedb=[super getDatabaseOfCountUpRecordTable];
            [threedb open];
            
            [threedb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount, indexPath) VALUES  (?, ?, ?, ?);",_attendanceCountOfMaxIdString,[NSString stringWithFormat:@"%d",_absenceCountOfMaxIdString.intValue + 1],[NSString stringWithFormat:@"%d",_lateCountOfMaxIdString.intValue - 1],[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
            [threedb close];
            
         }
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeDatePicker:(id)sender {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    _latestDateString=[dateFormatter stringFromDate:_datePicker.date];
}

#pragma mark - Original Method


//出席状況カウントを更新
-(void)updateCounts:(NSString *)attendanceCount absenceCount:(NSString *)absenceCount lateCount:(NSString *)lateCount attendanceCountPlusMinus:(int)attendanceCountPlusMinus absenceCountPlusMinus:(int)absenceCountPlusMinus lateCountPlusMinus:(int)lateCountPlusMinus{
    
    attendanceCount=[NSString stringWithFormat:@"%d",_attendanceCountOfMaxIdString.intValue + attendanceCountPlusMinus];
    absenceCount=[NSString stringWithFormat:@"%d",_absenceCountOfMaxIdString.intValue + absenceCountPlusMinus];
    lateCount=[NSString stringWithFormat:@"%d",_lateCountOfMaxIdString.intValue + lateCountPlusMinus];
    
    FMDatabase *twodb=[super getDatabaseOfCountUpRecordTable];
    [twodb open];
    
    FMResultSet *results=[twodb executeQuery:@"SELECT attendancecount, absencecount, latecount FROM count_up_record_table WHERE id = (SELECT MAX(id) FROM count_up_record_table);"];
    
    while ([results next]) {
        
        _attendanceCountOfMaxIdString=[results stringForColumn:@"attendancecount"];
        _absenceCountOfMaxIdString=[results stringForColumn:@"absencecount"];
        _lateCountOfMaxIdString=[results stringForColumn:@"latecount"];
    }
    [twodb close];
    
    FMDatabase *threedb=[super getDatabaseOfCountUpRecordTable];
    [threedb open];
    
    [threedb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount, indexPath) VALUES  (?, ?, ?, ?);",attendanceCount,absenceCount,lateCount,[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
    [threedb close];
    
}

-(void)plusMinusCounts{
    
    
}

@end