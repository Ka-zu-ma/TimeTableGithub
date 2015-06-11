//
//  SuperAttendanceRecordViewController.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/25.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
@interface BaseViewController : UIViewController
-(NSString *)getToday;
-(UIColor *)setTintColor;
-(UIColor *)setBarTintColor;
-(UIBarButtonItem *)createBarButtonItem;
@end
