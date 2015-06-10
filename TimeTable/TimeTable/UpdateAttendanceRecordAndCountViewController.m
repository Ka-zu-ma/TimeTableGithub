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
    
    if (_latestDateString.length == 0 && _latestAttendanceRecordString.length == 0) {
        
        [self.navigationController popViewControllerAnimated:YES];
        return;
        
    }else if(_latestDateString.length == 0 && (!(_latestAttendanceRecordString.length == 0))){
        
        _latestDateString=_dateString;
    }else if ((!(_latestDateString.length == 0)) && _latestAttendanceRecordString.length == 0){
        
        _latestAttendanceRecordString=_attendanceRecordString;
    }
    
    [DatabaseOfDateAndAttendanceRecordTable update:_latestDateString attendanceRecordTextFieldText:_latestAttendanceRecordString dateString:_dateString attendanceRecordString:_attendanceRecordString];
    
    NSString *attendanceRecordString=_attendanceRecordString;
    NSString *latestAttendanceRecordString=_latestAttendanceRecordString;
    
    NSString *attendanceCountOfMaxIdString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][attendanceCountString];
    NSString *absenceCountOfMaxIdString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][absenceCountString];
    NSString *lateCountOfMaxIdString=[DatabaseOfCountUpRecordTable selectCountUpRecordTableToGetCountsWhereMaxIdWhereIndexPath:indexPathString][lateCountString];
    
    if ([attendanceRecordString isEqual:@"出席"]) {
        
        if ([latestAttendanceRecordString isEqual:@"遅刻"]) {
            NSLog(@"かきくけこ");
            [DatabaseOfCountUpRecordTable insertCountUpRecordTable:[NSString stringWithFormat:@"%d",attendanceCountOfMaxIdString.intValue-1] absencecount:absenceCountOfMaxIdString latecount:[NSString stringWithFormat:@"%d",lateCountOfMaxIdString.intValue+1] indexPathRow:indexPathString];

        }else if ([latestAttendanceRecordString isEqualToString:@"欠席"]){
            
            [DatabaseOfCountUpRecordTable insertCountUpRecordTable:[NSString stringWithFormat:@"%d",attendanceCountOfMaxIdString.intValue-1] absencecount:[NSString stringWithFormat:@"%d",absenceCountOfMaxIdString.intValue+1] latecount:lateCountOfMaxIdString indexPathRow:indexPathString];
        }
    }else if([attendanceRecordString isEqual:@"欠席"]){
        
        if ([latestAttendanceRecordString isEqual:@"出席"]) {
            
            [DatabaseOfCountUpRecordTable insertCountUpRecordTable:[NSString stringWithFormat:@"%d",attendanceCountOfMaxIdString.intValue+1] absencecount:[NSString stringWithFormat:@"%d",absenceCountOfMaxIdString.intValue-1] latecount:lateCountOfMaxIdString indexPathRow:indexPathString];
            
        }else if([latestAttendanceRecordString isEqual:@"遅刻"]){
            
            [DatabaseOfCountUpRecordTable insertCountUpRecordTable:attendanceCountOfMaxIdString absencecount:[NSString stringWithFormat:@"%d",absenceCountOfMaxIdString.intValue-1] latecount:[NSString stringWithFormat:@"%d",lateCountOfMaxIdString.intValue+1] indexPathRow:indexPathString];
        }
            
        
    }else{
        
        if ([latestAttendanceRecordString isEqual:@"出席"]) {
            
            [DatabaseOfCountUpRecordTable insertCountUpRecordTable:[NSString stringWithFormat:@"%d",attendanceCountOfMaxIdString.intValue+1] absencecount:absenceCountOfMaxIdString latecount:[NSString stringWithFormat:@"%d",lateCountOfMaxIdString.intValue-1] indexPathRow:indexPathString];
            
        }else if([latestAttendanceRecordString isEqual:@"欠席"]){
            
            [DatabaseOfCountUpRecordTable insertCountUpRecordTable:attendanceCountOfMaxIdString absencecount:[NSString stringWithFormat:@"%d",absenceCountOfMaxIdString.intValue+1] latecount:[NSString stringWithFormat:@"%d",lateCountOfMaxIdString.intValue-1] indexPathRow:indexPathString];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)changeDatePicker:(id)sender {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd"];
    _latestDateString=[dateFormatter stringFromDate:_datePicker.date];
}

@end