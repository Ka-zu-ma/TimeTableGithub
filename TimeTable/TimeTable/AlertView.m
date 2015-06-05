//
//  AlertView.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/05.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "AlertView.h"

@implementation AlertView
+(UIAlertView *)createAlertView:messageString{
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"警告" message:messageString delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    
    return  alertView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
