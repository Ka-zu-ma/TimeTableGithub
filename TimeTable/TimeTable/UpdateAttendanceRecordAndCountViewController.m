//
//  UpdateAttendanceRecordAndCountViewController.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/29.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "UpdateAttendanceRecordAndCountViewController.h"
#import "FMDatabase.h"

@interface UpdateAttendanceRecordAndCountViewController ()
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *attendanceRecordTextField;
@property (weak, nonatomic) IBOutlet UIButton *updateButton;

/*@property (strong,nonatomic) NSString *attendanceCountString;
@property (strong,nonatomic) NSString *absenceCountString;
@property (strong,nonatomic) NSString *lateCountString;*/

@property  (strong,nonatomic) NSString *attendanceCountOfMaxIdString;
@property  (strong,nonatomic) NSString *absenceCountOfMaxIdString;
@property  (strong,nonatomic) NSString *lateCountOfMaxIdString;


- (IBAction)updateButton:(id)sender;

@end

@implementation UpdateAttendanceRecordAndCountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[_updateButton layer] setCornerRadius:10.0];
    [_updateButton setClipsToBounds:YES];
    
    _dateTextField.text=_dateString;
    _attendanceRecordTextField.text=_attendanceRecordString;
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    //タイトル色変更
    UILabel *titleLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    titleLabel.textColor=[UIColor whiteColor];
    titleLabel.text=@"日付け、出席状況　変更";
    [titleLabel sizeToFit];
    self.navigationItem.titleView=titleLabel;
    
    self.navigationController.navigationBar.tintColor=[UIColor blackColor];//バーアイテムカラー
    self.navigationController.navigationBar.barTintColor=[UIColor blueColor];//バー背景色
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateButton:(id)sender {
    
    FMDatabase *db=[super getDatabaseOfDateAndAttendanceRecordTable];
    [db open];
    
    [db executeUpdate:@"UPDATE date_attendancerecord_table SET date = ?, attendancerecord = ? WHERE date = ? AND attendancerecord = ?;",[NSString stringWithFormat:@"%@",_dateTextField.text],_attendanceRecordTextField.text,_dateString,_attendanceRecordString];
    [db close];
    
    
    //以下　Original Methodの引数に値を入れてコード量を減らしたい。
    if ([_attendanceRecordString isEqual:@"出席"]) {
        
        if ([_attendanceRecordTextField.text isEqual:@"欠席"]) {
            
            //出席を欠席に変更
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
            
            [threedb executeUpdate:@"INSERT INTO count_up_record_table (attendancecount, absencecount, latecount, indexPath) VALUES  (?, ?, ?, ?);",[NSString stringWithFormat:@"%d",_attendanceCountOfMaxIdString.intValue-1],[NSString stringWithFormat:@"%d",_absenceCountOfMaxIdString.intValue+1],_lateCountOfMaxIdString,[NSString stringWithFormat:@"%ld",(long)_indexPath.row]];
            [threedb close];
        
      
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
        if ([_attendanceRecordTextField.text isEqual:@"出席"]) {
            
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
        
        if ([_attendanceRecordTextField.text isEqual:@"出席"]) {
            
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

//
-(void)plusMinusCounts{
    
    
}

@end