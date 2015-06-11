//
//  UpdateAttendanceRecordAndCountViewController.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/29.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface UpdateAttendanceRecordAndCountViewController : BaseViewController
@property (strong,nonatomic) NSString *dateString;
@property (strong,nonatomic) NSString *attendanceRecordString;
@property (strong,nonatomic) NSIndexPath *indexPath;
@end
