//
//  AttendanceRecordTableViewCell.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/12.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CountUpDelegate <NSObject>
-(void)attendanceCountUp;
-(void)absenceCountUp;
-(void)lateCountUp;

@end

@interface CountUpCell :UITableViewCell

@property (nonatomic,assign) id<CountUpDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIButton *attendanceButton;
@property (weak, nonatomic) IBOutlet UIButton *absenceButton;
@property (weak, nonatomic) IBOutlet UIButton *lateButton;

@end
