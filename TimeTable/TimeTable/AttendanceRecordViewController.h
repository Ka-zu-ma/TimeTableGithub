//
//  AttendanceRecordViewController.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/01.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperAttendanceRecordViewController.h"
#import "CountUpCell.h"
@interface AttendanceRecordViewController : SuperAttendanceRecordViewController
@property (strong,nonatomic) NSIndexPath *indexPath;

@property (weak,nonatomic) UIButton *attendanceButton;
@property (weak,nonatomic) UIButton *absenceButton;
@property (weak,nonatomic) UIButton *lateButton;
@end
