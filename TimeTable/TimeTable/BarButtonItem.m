//
//  BarButtonItem.m
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/04.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import "BarButtonItem.h"

@implementation BarButtonItem

+(UIBarButtonItem *)createBarButtonItem{
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]
                                  initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                  target:self
                                  action:@selector(addButtontouched:)];
    return addButton;
}
-(void)addButtontouched:(UIBarButtonItem *)addButton{
    [self.delegate createClass];
}
@end
