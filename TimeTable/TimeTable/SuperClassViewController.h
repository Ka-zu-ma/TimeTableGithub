//
//  SuperSelectClassViewController.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/18.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"
@interface SuperClassViewController : UIViewController

-(FMDatabase *)getDatabaseOfcreateclass;
-(FMDatabase *)getDatabaseOfselectclass;
-(void)createCreateClassTable;
-(void)createSelectClassTable;

@end
