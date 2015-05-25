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

@property  NSInteger attendanceCountOfMaxId;
@property  NSInteger absenceCountOfMaxId;
@property  NSInteger lateCountOfMaxId;

- (IBAction)attendanceButton:(id)sender;
- (IBAction)absenceButton:(id)sender;
- (IBAction)lateButton:(id)sender;
-(void)selectCountsOfMaxId;
-(void)updateButtonTitleLabelText;
@end
