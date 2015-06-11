//
//  AttendanceRecordViewController.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/01.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CountUpCell.h"
@interface AttendanceRecordViewController : BaseViewController
@property (strong,nonatomic) NSIndexPath *indexPath;

@property (weak,nonatomic) UIButton *attendanceButton;
@property (weak,nonatomic) UIButton *absenceButton;
@property (weak,nonatomic) UIButton *lateButton;
@end
