//
//  BarButtonItem.h
//  TimeTable
//
//  Created by SDT-B004 on 2015/06/04.
//  Copyright (c) 2015年 SDT-B004. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BarButtonItemDelegate <NSObject>
-(void)createClass;
@end

@interface BarButtonItem : NSObject

@property (nonatomic,assign) id <BarButtonItemDelegate> delegate;
+(UIBarButtonItem *)createBarButtonItem;
-(void)addButtontouched:(UIBarButtonItem *)addButton;
@end
