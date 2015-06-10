//
//  NavigationBar.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/04.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "NavigationBar.h"

@implementation NavigationBar
+(UINavigationBar *)setColor{
    
    UINavigationBar *navigationBar=[[UINavigationBar alloc]init];
    navigationBar.tintColor=[UIColor blackColor];
    //[UINavigationBar appearance].tintColor=[UIColor blackColor];
    navigationBar.barTintColor=[UIColor blueColor];
    return navigationBar;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
