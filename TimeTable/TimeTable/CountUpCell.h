//
//  AttendanceRecordTableViewCell.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/12.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "SuperCountUpCell.h"
@interface CountUpCell : SuperCountUpCell
@property (weak, nonatomic) IBOutlet UIButton *attendanceButton;
@property (weak, nonatomic) IBOutlet UIButton *absenceButton;
@property (weak, nonatomic) IBOutlet UIButton *lateButton;

@property  (strong,nonatomic) NSString *attendanceCountOfMaxIdString;
@property  (strong,nonatomic) NSString *absenceCountOfMaxIdString;
@property  (strong,nonatomic) NSString *lateCountOfMaxIdString;

@property (strong,nonatomic) NSString *renewAttendanceCountOfMaxIdString;
@property (strong,nonatomic) NSString *renewAbsenceCountOfMaxIdString;
@property (strong,nonatomic) NSString *renewlateCountOfMaxIdString;

- (IBAction)attendanceButton:(id)sender;
- (IBAction)absenceButton:(id)sender;
- (IBAction)lateButton:(id)sender;
-(void)selectCountsOfMaxIdAndNewCounts;
@end
