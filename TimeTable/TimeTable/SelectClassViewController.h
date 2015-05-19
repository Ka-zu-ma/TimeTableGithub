//
//  SelectClassViewController.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/01.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperSelectClassViewController.h"

@interface SelectClassViewController : UIViewController

@property (strong,nonatomic) NSMutableArray *classes;
@property (strong,nonatomic) NSMutableArray *teachers;
@property (strong,nonatomic) NSMutableArray *classrooms;
@property (nonatomic) NSInteger row;

@end
