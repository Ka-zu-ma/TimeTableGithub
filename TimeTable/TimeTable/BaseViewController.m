//
//  SuperAttendanceRecordViewController.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/05/25.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)getToday{
    
    NSDateFormatter *format=[[NSDateFormatter alloc]init];
    [format setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"ja_JP"]];
    [format setDateFormat:@"yyyy/MM/dd"];
    NSString *stringTime=[format stringFromDate:[NSDate date]];
    return stringTime;
}

#pragma mark - Navigation Bar 

-(UIColor *)setTintColor{
    
    UIColor *tintColor=[UIColor blackColor];
    return tintColor;
}

-(UIColor *)setBarTintColor{
    UIColor *barTintColor=[UIColor blueColor];
    return barTintColor;
}

-(UIBarButtonItem *)createBarButtonItem{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(addButtontouched:)];
    return addButton;
}

-(void)addButtontouched:(UIBarButtonItem *)addButton{
    
}




@end
