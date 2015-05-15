//
//  AttendanceRecordTableViewCell.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/12.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface CountUpCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *attendanceButton;
@property (weak, nonatomic) IBOutlet UIButton *absenceButton;
@property (weak, nonatomic) IBOutlet UIButton *lateButton;
- (IBAction)attendanceButton:(id)sender;
- (IBAction)absenceButton:(id)sender;
- (IBAction)lateButton:(id)sender;

@end
